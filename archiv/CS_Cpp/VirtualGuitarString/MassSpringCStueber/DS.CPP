/******************************************************************************
File: 		 ds.x
Tab stops:	 every 2 columns
Project:	 Developer's Guide to DirectX 4
Written:	 96/03/13 by Keith Weiner
Purpose:	 Contains the code for the DS class
History:	 96/03/13 KW Started
******************************************************************************/


#include "stdafx.h"
#include <windows.h>

#include "mmsystem.h"
#include "dsound.h"

#include "ds.h"



void DIRSOUND::FillBuffer(WORD channel)
{
	LPVOID write1;
	DWORD length1;
	LPVOID write2;
	DWORD length2;
	HRESULT hr;

	hr = lpdsb[channel]->Lock(0, len[channel], &write1, &length1,
														&write2, &length2, 0);

	if (hr == DSERR_BUFFERLOST)
	{
		lpdsb[channel]->Restore();

		hr = lpdsb[channel]->Lock(0, len[channel], &write1, &length1,
															&write2, &length2, 0);
	}

	if (hr != DS_OK)
	{
		exit(-1);
	}

	CopyMemory(write1, sound[channel], length1);

	if (write2 != NULL)
	{
		CopyMemory(write2, sound[channel] + length1, length2);
	}

	hr = lpdsb[channel]->Unlock(write1, length1, write2, length2);

	if (hr != DS_OK)
	{
		exit(-1);
	}
}


void DIRSOUND::DestroyBuffer(WORD channel)
{
	DWORD hr;

	hr = lpdsb[channel]->Release();

	if (hr != DS_OK)
	{
		exit(-1);
	}

	lpdsb[channel] = NULL;
}


void DIRSOUND::CreateBuffer(WORD channel)
{
	DSBUFFERDESC dsbdesc;
	PCMWAVEFORMAT pcmwf;
	HRESULT hr;

	memset(&pcmwf, 0, sizeof(PCMWAVEFORMAT));
	pcmwf.wf.wFormatTag 		 = WAVE_FORMAT_PCM;
	pcmwf.wf.nChannels			 = ds_CHANSPERSAMPLE;
	pcmwf.wf.nSamplesPerSec  = ds_SAMPLERATE;
	pcmwf.wf.nBlockAlign		 = ds_CHANSPERSAMPLE * ds_BITSPERSAMPLE / 8;
	pcmwf.wf.nAvgBytesPerSec = pcmwf.wf.nSamplesPerSec * pcmwf.wf.nBlockAlign;
	pcmwf.wBitsPerSample		 = ds_BITSPERSAMPLE;

	memset(&dsbdesc, 0, sizeof(DSBUFFERDESC));
	dsbdesc.dwSize				= sizeof(DSBUFFERDESC);
	dsbdesc.dwFlags 			= DSBCAPS_CTRLDEFAULT;
	dsbdesc.dwBufferBytes = len[channel];
	dsbdesc.lpwfxFormat 	= (LPWAVEFORMATEX)&pcmwf;

	hr = lpdirsnd->CreateSoundBuffer(&dsbdesc, &lpdsb[channel], NULL);

	if (hr != DS_OK)
	{
		exit(-1);
	}
}


WORD DIRSOUND::AllocChannel(void)
{
	WORD x;

	for (x=0;x<ds_NUMCHANNELS;x++)
	{
		if (lpdsb[x] == NULL)
		{
			break;
		}
	}

	if (x == ds_NUMCHANNELS)
	{
		exit(-1); 		//no channels are available
	}

	return (x);
}


void DIRSOUND::Stop(WORD channel)
{
	lpdsb[channel]->Stop();
}


void DIRSOUND::Start(WORD channel, BOOL looping)
{
	HRESULT hr;

	hr = lpdsb[channel]->Play(0, 0, looping == TRUE ? DSBPLAY_LOOPING : 0);

	if (hr != DS_OK)
	{
		exit(-1);
	}
}


void DIRSOUND::UnLoadWave(WORD channel)
{
	DestroyBuffer(channel);

	if (sound[channel] != NULL)
	{
		delete sound[channel];
	}
}


WORD DIRSOUND::LoadWave(char *filename)
{
	HMMIO 			 hmfr;
	MMCKINFO		 parent, child;
	WAVEFORMATEX wfmtx;
	WORD				 channel;

	parent.ckid 				= (FOURCC)0;
	parent.cksize 			= 0;
	parent.fccType			= (FOURCC)0;
	parent.dwDataOffset = 0;
	parent.dwFlags			= 0;

	child = parent;

	hmfr = mmioOpen(filename, NULL, MMIO_READ | MMIO_ALLOCBUF);

	if (hmfr == NULL)
	{
		exit(-1); 	//can't open file
	}

	/* descend into the RIFF */
	parent.fccType = mmioFOURCC('W', 'A', 'V', 'E');

	if (mmioDescend(hmfr, &parent, NULL, MMIO_FINDRIFF))
	{
		mmioClose(hmfr, 0);

		exit(-1); 	//not a WAVE file
	}

	/* descend to the WAVEfmt */
	child.ckid = mmioFOURCC('f', 'm', 't', ' ');

	if (mmioDescend(hmfr, &child, &parent, 0))
	{
		mmioClose(hmfr, 0);

		exit(-1); 	//WAVE file has no fmt chunk
	}

	/* read the WAVEFMT from the wave file */
	if (mmioRead(hmfr, (char*)&wfmtx, sizeof(wfmtx)) != sizeof(wfmtx))
	{
		mmioClose(hmfr, 0);

		exit(-1); 	//unable to read fmt chunk
	}

	/* We only handle PCM format WAVEs */
	if (wfmtx.wFormatTag != WAVE_FORMAT_PCM)
	{
		mmioClose(hmfr, 0);

		exit(-1); 	//WAVE file is not PCM format
	}

	if (mmioAscend(hmfr, &child, 0))
	{
		mmioClose(hmfr, 0);

		exit(-1); 	//unable to ascend
	}

	/* descend to the data chunk */
	child.ckid = mmioFOURCC('d', 'a', 't', 'a');

	if (mmioDescend(hmfr, &child, &parent, MMIO_FINDCHUNK))
	{
		mmioClose(hmfr, 0);

		exit(-1); 	//WAVE file has no data chunk
	}

	channel = AllocChannel();

	sound[channel] = new BYTE[child.cksize];
	len[channel]	 = child.cksize;

	if (sound[channel] == NULL)
	{
		exit(-1);
	}

	/* read the wave data */
	if ((DWORD)mmioRead(hmfr, (char *)sound[channel], child.cksize) !=
			child.cksize)
	{
		mmioClose(hmfr, 0);

		exit(-1); 	//unable to read data chunk
	}

	mmioClose(hmfr, 0);

	CreateBuffer(channel);
	FillBuffer(channel);

	return (channel);
}


DIRSOUND::~DIRSOUND()
{
	WORD x;

	for (x=0;x<ds_NUMCHANNELS;x++)
	{
		if (lpdsb[x] != NULL)
		{
			DestroyBuffer(x);

			if (sound[x] != NULL)
			{
				delete sound[x];
			}
		}
	}

	(void)lpdirsnd->Release();		//nothing to do if this causes an error...
}


DIRSOUND::DIRSOUND(HWND hwnd)
{
	DWORD ret;
	WORD x;

	for (x=0;x<ds_NUMCHANNELS;x++)
	{
		lpdsb[x] = NULL;
	}

	ret = DirectSoundCreate(NULL, &lpdirsnd, NULL);

	if (ret != DS_OK)
	{
		exit(-1);
	}

	ret = lpdirsnd->SetCooperativeLevel(hwnd, DSSCL_NORMAL);

	if (ret != DS_OK)
	{
		exit(-1);
	}
}
