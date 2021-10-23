#if !defined(AFX_PARAMETERDLG_H__DAB4F91F_779A_4EA0_AF52_19EDFB6DFE57__INCLUDED_)
#define AFX_PARAMETERDLG_H__DAB4F91F_779A_4EA0_AF52_19EDFB6DFE57__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// ParameterDlg.h : Header-Datei
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//
/////////////////////////////////////////////////////////////////////////////
// Dialogfeld CParameterDlg 

#include "MassSpringView.h"

class CParameterDlg : public CDialog
{
// Konstruktion
public:
	void Init();
	CMassSpringView* m_view;
	CParameterDlg(CWnd* pParent = NULL);   // Standardkonstruktor

// Dialogfelddaten
	//{{AFX_DATA(CParameterDlg)
	enum { IDD = IDD_PARAMETER };
	CSliderCtrl	m_force;
	CSliderCtrl	m_outscale;
	CSliderCtrl	m_dispersion;
	CSliderCtrl	m_damping_c3;
	CSliderCtrl	m_damping_c2;
	CSliderCtrl	m_updatesteps;
	CSliderCtrl	m_damping_c1;
	CSliderCtrl	m_tension;
	//}}AFX_DATA


// Überschreibungen
	// Vom Klassen-Assistenten generierte virtuelle Funktionsüberschreibungen
	//{{AFX_VIRTUAL(CParameterDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV-Unterstützung
	//}}AFX_VIRTUAL

// Implementierung
protected:

	// Generierte Nachrichtenzuordnungsfunktionen
	//{{AFX_MSG(CParameterDlg)
	afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ fügt unmittelbar vor der vorhergehenden Zeile zusätzliche Deklarationen ein.

#endif // AFX_PARAMETERDLG_H__DAB4F91F_779A_4EA0_AF52_19EDFB6DFE57__INCLUDED_
