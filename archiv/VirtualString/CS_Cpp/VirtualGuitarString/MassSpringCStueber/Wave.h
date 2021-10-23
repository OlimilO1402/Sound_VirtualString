// Wave.h: Schnittstelle für die Klasse CWave.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_WAVE_H__E6060B6C_CB68_45D1_A137_77DB377BD199__INCLUDED_)
#define AFX_WAVE_H__E6060B6C_CB68_45D1_A137_77DB377BD199__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#include <mmsystem.h>
#include "ResMan.h"

class CWave  
{
public:
	int Destroy();
	BOOL destroyed;
	CResMan* pResMan;
	LONG intID;
	CWave(LONG id,CResMan * pRM);
	virtual ~CWave();

    // Load from a resource
    bool    Load(HINSTANCE hinst, UINT nID);
    bool    Load(HINSTANCE hinst, LPCTSTR pszID);

    // Load and save to/from a file
    bool    Load(LPCSTR pszFileName);
    bool    Save(LPCSTR pszFileName);

    // Sends OnWaveOutXxx() to sink as progress
    bool    Play(UINT nWaveOut, bool bLoop = false);

    // Sends OnWaveInXxx() to sink as progress
    bool    Record(UINT nWaveIn, UINT nSecs);

    bool    Stop();
    bool    Close();

protected:
    WAVEHDR*        m_pWaveHdr;
    HPSTR           m_pData;
    DWORD           m_nRecordedSize;
    WAVEFORMATEX*   m_pFormat;
    DWORD           m_nFormatSize;
    HWAVEIN         m_hWaveIn;
    HWAVEOUT        m_hWaveOut;
    bool            m_bStopping;
    bool            m_bOwnData;

    bool    Load(HMMIO hmmio);
};

#endif // !defined(AFX_WAVE_H__E6060B6C_CB68_45D1_A137_77DB377BD199__INCLUDED_)


