// Wave.cpp: Implementierung der Klasse CWave.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "acdsrv.h"
#include "Wave.h"
#include "errors.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Konstruktion/Destruktion
//////////////////////////////////////////////////////////////////////


CWave::CWave(LONG id,CResMan * pRM)
{
	pResMan=pRM;
	intID=id;
    m_pData=0;
    m_hWaveOut=0;
    m_hWaveIn=0;
    m_pWaveHdr=0;
    m_nRecordedSize=0;
    m_pFormat=0;
    m_nFormatSize=0;
    m_bStopping=false;
    m_bOwnData=false;
	destroyed=FALSE;
}

CWave::~CWave()
{
    Close();
}

bool CWave::Load(LPCTSTR pszFileName)
{
    // Make sure we're not open
    Close();

    ASSERT(!m_pFormat);
    ASSERT(!m_nFormatSize);
    ASSERT(!m_pData);
    ASSERT(!m_nRecordedSize);

    // Open the given file for reading using buffered I/O
    HMMIO   hmmio;
    hmmio = mmioOpen(const_cast<TCHAR*>(pszFileName), 0, MMIO_READ | MMIO_ALLOCBUF);
    if( !hmmio )
    {
        OutputDebugString("mmioOpen() -- Failed to open file: ");
        OutputDebugString(pszFileName);
        OutputDebugString("\n");
        return false;
    }

    bool    bSuccess = Load(hmmio);
    
    // We're done with the file, close it
    mmioClose(hmmio, 0);

    return bSuccess;
}

bool CWave::Load(HMODULE hm, UINT nID)
{
    return Load(hm, MAKEINTRESOURCE(nID));
}

bool CWave::Load(HMODULE hm, LPCTSTR pszID)
{
    // Make sure we're not open
    Close();

    ASSERT(!m_pFormat);
    ASSERT(!m_nFormatSize);
    ASSERT(!m_pData);
    ASSERT(!m_nRecordedSize);

    // Load the resource
    HRSRC   hrsrc = FindResource(hm, pszID, __TEXT("wave"));
    if( !hrsrc )
    {
        OutputDebugString("Failed to find 'wave' resource ");
        OutputDebugString(pszID);
        OutputDebugString("\n");
        return false;
    }

    ASSERT(SizeofResource(hm, hrsrc));

    HGLOBAL hg = LoadResource(hm, hrsrc);
    if( !hg )
    {
        OutputDebugString("Failed to load 'wave' resource ");
        OutputDebugString(pszID);
        OutputDebugString("\n");
        return false;
    }

    // Open the given resource for reading
    MMIOINFO    mii = { 0 };
    mii.pchBuffer = (HPSTR)hg;
    mii.fccIOProc = FOURCC_MEM;
    mii.cchBuffer = SizeofResource(hm, hrsrc);

    HMMIO   hmmio;
    hmmio = mmioOpen(0, &mii, MMIO_READ | MMIO_ALLOCBUF);
    if( !hmmio )
    {
        OutputDebugString("mmioOpen() -- Failed to open 'wave' resource ");
        OutputDebugString(pszID);
        OutputDebugString("\n");
        return false;
    }

    bool    bSuccess = Load(hmmio);

    // We're done with the file, close it
    mmioClose(hmmio, 0);

    return bSuccess;
}
    
bool CWave::Load(HMMIO hmmio)
{
    MMRESULT    mr;
    MMCKINFO    mmckinfoParent;
    MMCKINFO    mmckinfoSubchunk;

    // Locate a 'RIFF' chunk with a 'WAVE' form type to make sure it's a WAVE file
    mmckinfoParent.fccType = mmioFOURCC('W', 'A', 'V', 'E');
    mr = mmioDescend(hmmio, &mmckinfoParent, 0, MMIO_FINDRIFF);
    if( mr )
    {
        pResMan->Log("ERROR: mmioDescend");
        mmioClose(hmmio, 0);
        return false;
    }
    
    //  Now, find the format chunk (form type 'fmt '). It should be
    //  a subchunk of the 'RIFF' parent chunk.
    mmckinfoSubchunk.ckid = mmioFOURCC('f', 'm', 't', ' ');
    mr = mmioDescend(hmmio, &mmckinfoSubchunk, &mmckinfoParent, MMIO_FINDCHUNK);
    if( mr )
    {
        pResMan->Log("ERROR: mmioDescend");
        mmioClose(hmmio, 0);
        return false;
    }
    
    // Get the size of the format chunk and allocate memory for it
    DWORD           nFormatSize = mmckinfoSubchunk.cksize;
    WAVEFORMATEX*   pFormat = (WAVEFORMATEX*)(new BYTE[nFormatSize]);
    if( !pFormat )
    {
        pResMan->Log("ERROR: new[] -- Out of memory");
        mmioClose(hmmio, 0);
        return false;
    }
    
    // Read the format chunk
    if( mmioRead(hmmio, (HPSTR)pFormat, nFormatSize) != (LONG)nFormatSize )
    {
        pResMan->Log("ERROR: mmioRead() -- Failed to read FMT chunk\n");
        delete[] pFormat;
        mmioClose(hmmio, 0);
        return false;
    }

	// Spat out some file infos...
    CString msg;
    msg.Format("wFormatTag = %lu",        (DWORD) pFormat->wFormatTag);
    pResMan->Log(msg);
	msg.Format("nChannels = %lu",         (DWORD) pFormat->nChannels );
    pResMan->Log(msg);
    msg.Format("nSamplesPerSec = %lu",    (DWORD) pFormat->nSamplesPerSec);
    pResMan->Log(msg);
    msg.Format("nAvgBytesPerSec = %lu",   (DWORD) pFormat->nAvgBytesPerSec);
    pResMan->Log(msg);
    msg.Format("nBlockAlign = %lu",       (DWORD) pFormat->nBlockAlign);
    pResMan->Log(msg);
    msg.Format("wBitsPerSample = %lu",    (DWORD) pFormat->wBitsPerSample);
    pResMan->Log(msg);
    msg.Format("cbSize = %lu",            (DWORD) pFormat->cbSize);
    pResMan->Log(msg);
    

    // Ascend out of the format subchunk
    mmioAscend(hmmio, &mmckinfoSubchunk, 0);
    
    // Find the data subchunk
    mmckinfoSubchunk.ckid = mmioFOURCC('d', 'a', 't', 'a');
    mr = mmioDescend(hmmio, &mmckinfoSubchunk, &mmckinfoParent, MMIO_FINDCHUNK);
    if( mr )
    {
        pResMan->Log("ERROR: mmioDescend");
        delete[] pFormat;
        mmioClose(hmmio, 0);
        return false;
    }
    
    //  Get the size of the data subchunk
    DWORD   nDataSize = mmckinfoSubchunk.cksize;
    if( !nDataSize )
    {
        pResMan->Log("ERROR: Data chunk actually has no data\n");
        delete[] pFormat;
        mmioClose(hmmio, 0);
        return false;
    }
    
    //TRACE1("Size of data is %lu\n", nDataSize);
    
    // Allocate memory for the waveform data
    HPSTR   pData = (HPSTR)(new BYTE[nDataSize]);
    if( !pData )
    {
        pResMan->Log("ERROR: new[] -- Out of memory\n");
        mmioClose(hmmio, 0);
        delete[] pFormat;
        return false;
    }
    
    // Read the waveform data subchunk
    if( mmioRead(hmmio, pData, nDataSize) != (LONG)nDataSize )
    {
        pResMan->Log("ERROR: mmioRead() -- Failed to read waveform data subchunk\n");
        delete[] pData;
        delete[] pFormat;
        mmioClose(hmmio, 0);
        return false;
    }
    
    // Update the object state
    m_pFormat = pFormat;
    m_nFormatSize = nFormatSize;
    m_nRecordedSize = nDataSize;
    m_pData = pData;
    m_bOwnData = true;

    return true;
}

bool CWave::Save(LPCTSTR pszFileName)
{
    // Make sure we've got some data
    if( !m_pData )
    {
        return false;
    }

    ASSERT(m_pFormat);
    ASSERT(m_nFormatSize);
    ASSERT(m_pData);

    HANDLE  hFile;
    DWORD   nBytesWritten;

    hFile = CreateFile(pszFileName, GENERIC_WRITE, 0, 0,
                       CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if( hFile == INVALID_HANDLE_VALUE )
    {
        pResMan->Log("CreateFile() -- Can't open file: ");
        pResMan->Log(pszFileName);
        pResMan->Log("");
        return false;
    }
    
    BYTE    rgbRiffChunk[] =        { 'R', 'I', 'F', 'F', 0, 0, 0, 0, 'W', 'A', 'V', 'E', };
    BYTE    rgbFormatChunkTag[] =   { 'f', 'm', 't', ' ', 0, 0, 0, 0, };
    BYTE    rgbDataChunkTag[] =     { 'd', 'a', 't', 'a', 0, 0, 0, 0, };

    // Write out the RIFF chunk
    *((DWORD*)&rgbRiffChunk[4]) = 4 + sizeof(rgbFormatChunkTag) +
                                  m_nFormatSize + sizeof(rgbDataChunkTag) +
                                  m_nRecordedSize;
    if( !WriteFile(hFile, rgbRiffChunk, sizeof(rgbRiffChunk), &nBytesWritten, 0) )
    {
        OutputDebugString("Can't write RIFF chunk\n");
        CloseHandle(hFile);
        return false;
    }

    // Write tag
    *((DWORD*)&rgbFormatChunkTag[4]) = m_nFormatSize;
    if( !WriteFile(hFile, rgbFormatChunkTag, sizeof(rgbFormatChunkTag), &nBytesWritten, 0) )
    {
        OutputDebugString("Can't write fmt chunk\n");
        CloseHandle(hFile);
        return false;
    }
    
    // Write out the canned format header
    if( !WriteFile(hFile, m_pFormat, m_nFormatSize, &nBytesWritten, 0) )
    {
        OutputDebugString("Can't write WAVEFORMATEX chunk\n");
        CloseHandle(hFile);
        return false;
    }
    
    // Write out the data chunk tag
    *((DWORD *)&rgbDataChunkTag[4]) = m_nRecordedSize;
    if( !WriteFile(hFile, rgbDataChunkTag, sizeof(rgbDataChunkTag), &nBytesWritten, 0) )
    {
        OutputDebugString("Can't write data chunk tag\n");
        CloseHandle(hFile);
        return false;
    }
    
    // Write out the data chunk
    if( !WriteFile(hFile, m_pData, m_nRecordedSize, &nBytesWritten, 0) )
    {
        OutputDebugString("Can't write data chunk\n");
        CloseHandle(hFile);
        return false;
    }

    // Close message file
    CloseHandle(hFile);
    return true;
}

void CALLBACK waveOutProc( HWAVEOUT hwo, UINT uMsg, DWORD dwInstance, DWORD dwParam1, DWORD dwParam2 )
{
	CWave* pWav=(CWave*)dwInstance;
	if (!pWav) return;
	switch (uMsg)
	{
	case WOM_DONE:
		// kill waveobject
		pWav->pResMan->Log("Wave finished -- harakiri");
		pWav->Destroy();
		break;
	}
}
 


bool CWave::Play(UINT nWaveOut, bool bLoop)
{
    // Make sure we've got some data
    if( !m_pData )
    {
        return false;
    }

    MMRESULT    mr;

    // Make sure we're stopped
    Stop();

    ASSERT(!m_hWaveOut);
    ASSERT(!m_pWaveHdr);
    ASSERT(m_pFormat);

    // make sure devices are installed
	int numdevs=waveOutGetNumDevs();

	if (numdevs == 0 )
	{
        pResMan->Log("ERROR: no wave-out devices installed!");
        return false;
	}	
	// check all output devices
	WAVEOUTCAPS wocp;
	CString msg;
	msg.Format("Number of wave-out devices: %d",numdevs);
    pResMan->Log(msg);
	for (int i=0; i<numdevs; i++)
	{
		waveOutGetDevCaps(i,&wocp,sizeof(wocp));
		msg=wocp.szPname;
        pResMan->Log(msg);
	}

	// Make sure a waveform output device supports this format
    
	mr = waveOutOpen(0, nWaveOut, m_pFormat, 0, 0L,
                     WAVE_FORMAT_QUERY | (nWaveOut == WAVE_MAPPER ? 0 : WAVE_MAPPED));
    if( mr )
    {
        pResMan->Log("ERROR: waveOutOpen");
        return false;
    }

    // Open a waveform output device
    HWAVEOUT    hWaveOut;
    DWORD       fdwOpen = CALLBACK_FUNCTION | (nWaveOut == WAVE_MAPPER ? 0 : WAVE_MAPPED);
    mr = waveOutOpen(&hWaveOut, nWaveOut, m_pFormat, (UINT)waveOutProc, (DWORD)this, fdwOpen);

    if( mr )
    {
        pResMan->Log("ERROR: waveOutOpen");
		if ( mr == MMSYSERR_ALLOCATED ) pResMan->Log("MMSYSERR_ALLOCATED");
		if ( mr == MMSYSERR_BADDEVICEID ) pResMan->Log("MMSYSERR_BADDEVICEID");
		if ( mr == MMSYSERR_NODRIVER ) pResMan->Log("MMSYSERR_NODRIVER");
		if ( mr == MMSYSERR_NOMEM ) pResMan->Log("MMSYSERR_NOMEM");
		if ( mr == WAVERR_BADFORMAT ) pResMan->Log("WAVERR_BADFORMAT");
		if ( mr == WAVERR_SYNC ) pResMan->Log("WAVERR_SYNC");

        return false;
    }
    
    // Set up WAVEHDR structure and prepare it to be written to wave device
    WAVEHDR*    pWaveHdr = new WAVEHDR;
    if( !pWaveHdr )
    {
        pResMan->Log("new[] -- Out of memory\n");
        Stop();
        return false;
    }

    pWaveHdr->lpData = m_pData;
    pWaveHdr->dwBufferLength = m_nRecordedSize;
    pWaveHdr->dwFlags = (bLoop ? WHDR_BEGINLOOP | WHDR_ENDLOOP : 0);
    pWaveHdr->dwLoops = (bLoop ? 0xffffffff : 0);
    
    mr = waveOutPrepareHeader(hWaveOut, pWaveHdr, sizeof(WAVEHDR));
    if( mr )
    {
        pResMan->Log("ERROR: waveOutPrepareHeader");
        Stop();
        return false;
    }
    
    // Then the data block can be sent to the output device
    mr = waveOutWrite(hWaveOut, pWaveHdr, sizeof(WAVEHDR));
    if( mr )
    {
        pResMan->Log("ERROR: waveOutWrite");
        Stop();
        return false;
    }

    // Cache results
    m_pWaveHdr = pWaveHdr;
    m_hWaveOut = hWaveOut;

    return true;
}

bool CWave::Record(UINT nWaveIn, UINT nSecs)
{
    // Make sure we're closed first
    Close();

    ASSERT(nSecs);
    ASSERT(!m_pData);
    ASSERT(!m_nRecordedSize);
    ASSERT(!m_nFormatSize);
    ASSERT(!m_pFormat);
    ASSERT(!m_pWaveHdr);
    ASSERT(!m_hWaveIn);

    MMRESULT        mr;
    WAVEFORMATEX*   pFormat = (WAVEFORMATEX*)(new BYTE[sizeof(WAVEFORMATEX)]);
    if( !pFormat )
    {
        pResMan->Log("new[] -- Out of memory\n");
        return false;
    }

    pFormat->wFormatTag = WAVE_FORMAT_PCM;  // Pulse Code Modulation
    pFormat->nChannels = 1;                 // Mono
    pFormat->nSamplesPerSec = 8000;         // 8.0 kHz
    pFormat->wBitsPerSample = 16;           // 16 bits/sample

    // PCM required calculations
    ASSERT(pFormat->wFormatTag == WAVE_FORMAT_PCM);
    pFormat->nBlockAlign = pFormat->nChannels * pFormat->wBitsPerSample/8;
    pFormat->nAvgBytesPerSec = pFormat->nSamplesPerSec * pFormat->nBlockAlign;

    // No user data
    pFormat->cbSize = 0;

    // Check support for format
    mr = waveInOpen(0, nWaveIn, pFormat, 0, 0,
                    WAVE_FORMAT_QUERY | (nWaveIn == WAVE_MAPPER ? 0 : WAVE_MAPPED));
    if( mr )
    {
        pResMan->Log("ERROR: waveInOpen");
        delete[] pFormat;
        return false;
    }
    
    // Open recorder
    HWAVEIN     hWaveIn;
    DWORD       fdwOpen = CALLBACK_WINDOW | (nWaveIn == WAVE_MAPPER ? 0 : WAVE_MAPPED);

    mr = waveInOpen(&hWaveIn, nWaveIn, pFormat, (DWORD)AfxGetMainWnd()->m_hWnd, 0, fdwOpen);
    if( mr )
    {
        pResMan->Log("ERROR: waveInOpen");
        delete[] pFormat;
        return false;
    }
    
    // Allocate message buffer
    WAVEHDR*    pWaveHdr = new WAVEHDR;
    if( !pWaveHdr )
    {
        pResMan->Log("ERROR: new[] -- Out of memory\n");
        delete[] pFormat;
        return false;
    }

    ZeroMemory(pWaveHdr, sizeof(WAVEHDR));

    DWORD   nDataSize = nSecs * pFormat->nSamplesPerSec * pFormat->wBitsPerSample/8;
    HPSTR   pData = (HPSTR)(new BYTE[nDataSize]);

    if( !pData )
    {
        pResMan->Log("ERROR: new[] -- Out of memory\n");
        delete pWaveHdr;
        delete[] pFormat;
        return false;
    }

    pWaveHdr->dwBufferLength = nDataSize;
    pWaveHdr->lpData = pData;

    mr = waveInPrepareHeader(hWaveIn, pWaveHdr, sizeof(WAVEHDR));
    if( mr )
    {
        pResMan->Log("ERROR: waveInPrepareHeader");
        delete[] pData;
        delete pWaveHdr;
        delete[] pFormat;
        return false;
    }
    
    // Pass down the buffer to record into
    mr = waveInAddBuffer(hWaveIn, pWaveHdr, sizeof(WAVEHDR));
    if( mr )
    {
        pResMan->Log("ERROR: waveInAddBuffer");
        delete[] pData;
        delete pWaveHdr;
        delete[] pFormat;
        return false;
    }
    
    // Start recording
    mr = waveInStart(hWaveIn);
    if( mr )
    {
        pResMan->Log("ERROR: waveInStart");
        delete[] pData;
        delete pWaveHdr;
        delete[] pFormat;
        return false;
    }

    // Cache results
    m_hWaveIn = hWaveIn;
    m_pData = pData;
    m_nRecordedSize = 0;
    m_nFormatSize = sizeof(WAVEFORMATEX);
    m_pFormat = pFormat;
    m_pWaveHdr = pWaveHdr;
    m_bOwnData = true;
    
    return true;
}

bool CWave::Stop()
{
    // Only stop if we're playing/recording
    if( m_pWaveHdr && !m_bStopping )
    {
        MMRESULT mr;
    
        // Important to avoid a manual Stop(),
        // followed by a stop notification,
        // followed by an automatic stop,
        // followed by a stop notification, etc.
        m_bStopping = true;

        if( m_hWaveOut )
        {
            mr = waveOutReset(m_hWaveOut);
            if ( mr != MMSYSERR_NOERROR ) pResMan->Log("ERROR: waveOutReset");

            mr = waveOutUnprepareHeader(m_hWaveOut, m_pWaveHdr, sizeof(WAVEHDR));
            if ( mr != MMSYSERR_NOERROR ) pResMan->Log("ERROR: waveOutUnprepareHeader");
            
            mr = waveOutClose(m_hWaveOut);
            if ( mr != MMSYSERR_NOERROR ) pResMan->Log("ERROR: waveOutClose");
            m_hWaveOut = 0;
        }
        else if( m_hWaveIn )
        {
            mr = waveInReset(m_hWaveIn);
            if ( mr != MMSYSERR_NOERROR ) pResMan->Log("ERROR: waveInReset");
        
            mr = waveInUnprepareHeader(m_hWaveIn, m_pWaveHdr, sizeof(WAVEHDR));
            if ( mr != MMSYSERR_NOERROR ) pResMan->Log("ERROR: waveInUnprepareHeader");
            
            // Cache recorded length
            m_nRecordedSize = m_pWaveHdr->dwBytesRecorded;
        
            mr = waveInClose(m_hWaveIn);
            if ( mr != MMSYSERR_NOERROR ) pResMan->Log("ERROR: waveInClose");
            m_hWaveIn = 0;
        }

        delete m_pWaveHdr;
        m_pWaveHdr = 0;
        m_bStopping = false;
    }

    return true;
}

bool CWave::Close()
{
    // Make sure we're stopped
    Stop();

	if (m_pFormat) delete[] m_pFormat;
    m_pFormat = 0;
    m_nFormatSize = 0;

    if( m_bOwnData ) delete[] m_pData;
    m_pData = 0;
    m_nRecordedSize = 0;
    m_bOwnData = false;

    return true;
}

int CWave::Destroy()
{
	destroyed=TRUE;
	return 0;
}