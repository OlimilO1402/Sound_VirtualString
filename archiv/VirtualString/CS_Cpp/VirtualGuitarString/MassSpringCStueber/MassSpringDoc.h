// MassSpringDoc.h : Schnittstelle der Klasse CMassSpringDoc
// 2001, Christoph St�ber, cscs@cs.tu-berlin.de
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_MASSSPRINGDOC_H__1A320CD9_7500_4F28_A5E0_6B1FAD3CB113__INCLUDED_)
#define AFX_MASSSPRINGDOC_H__1A320CD9_7500_4F28_A5E0_6B1FAD3CB113__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


#include "MPString.h"
#include "DS.H"	// Hinzugef�gt von der Klassenansicht

class CMassSpringDoc : public CDocument
{
protected: // Nur aus Serialisierung erzeugen
	CMassSpringDoc();
	DECLARE_DYNCREATE(CMassSpringDoc)

// Attribute
public:

// Operationen
public:

// �berladungen
	// Vom Klassenassistenten generierte �berladungen virtueller Funktionen
	//{{AFX_VIRTUAL(CMassSpringDoc)
	public:
	virtual BOOL OnNewDocument();
	virtual void Serialize(CArchive& ar);
	//}}AFX_VIRTUAL

// Implementierung
public:
	double m_timepasser;
	double m_outscale;				// Skalierungsfaktor f�r Amplitude "Lautst�rke"
	int m_receiverdim;				// Dimension des Tonabnehmers (1 f�r String, 2 f�r Plate)
	WORD m_soundbuffersize;			// * F�r DirectSound
	WORD m_bufferpos;				// *
	DIRSOUND *m_sound;				// *
	double m_sound_simu_dt;			//
	MPMass* m_receiver;				// Pointer auf das Masseteilchen, an dem der Ton abgenommen wird
	MPString* m_string;				// Das String/Plate Objekt

	virtual ~CMassSpringDoc();

	void SimuStep();				// Simulationsschritt durchf�hren
	void UpdateBParameters();		// B0-B6 Parameter neu berechnen
	WORD GetReceiverSound();		// Amplitude am Abnehmer
	void InitSound();				// Initialisieren von DirectSound
	void FillNextBuffer();			// DirectSound Buffer auff�llen
	void FillBufferCircular(DWORD start,DWORD end); // Zirkul�r in den Buffer schreiben
	void FillBuffer(DWORD start,DWORD end);		// Linear in den Buffer schreiben
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generierte Message-Map-Funktionen
protected:
	//{{AFX_MSG(CMassSpringDoc)
	afx_msg void OnButton32772();
	afx_msg void OnButton32773();
	afx_msg void OnButton32775();
	afx_msg void OnButton32776();
	afx_msg void OnButton32777();
	afx_msg void OnParameterBiegsamesaite();
	afx_msg void OnParameterSteiferstab();
	afx_msg void OnPresetHomogenousstring();
	afx_msg void OnPresetString();
	afx_msg void OnPresetPlate();
	afx_msg void OnReceiverSetposition();
	afx_msg void OnExciterSetposition();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ f�gt unmittelbar vor der vorhergehenden Zeile zus�tzliche Deklarationen ein.

#endif // !defined(AFX_MASSSPRINGDOC_H__1A320CD9_7500_4F28_A5E0_6B1FAD3CB113__INCLUDED_)
