#if !defined(AFX_EXCITERDLG_H__96A8D6B4_AF79_428D_BFDF_62E1325EFF61__INCLUDED_)
#define AFX_EXCITERDLG_H__96A8D6B4_AF79_428D_BFDF_62E1325EFF61__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// ExciterDlg.h : Header-Datei
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de

/////////////////////////////////////////////////////////////////////////////
// Dialogfeld CExciterDlg 

class CExciterDlg : public CDialog
{
// Konstruktion
public:
	CExciterDlg(CWnd* pParent = NULL);   // Standardkonstruktor

// Dialogfelddaten
	//{{AFX_DATA(CExciterDlg)
	enum { IDD = IDD_DIALOG2 };
	int		m_position;
	//}}AFX_DATA


// Überschreibungen
	// Vom Klassen-Assistenten generierte virtuelle Funktionsüberschreibungen
	//{{AFX_VIRTUAL(CExciterDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV-Unterstützung
	//}}AFX_VIRTUAL

// Implementierung
protected:

	// Generierte Nachrichtenzuordnungsfunktionen
	//{{AFX_MSG(CExciterDlg)
		// HINWEIS: Der Klassen-Assistent fügt hier Member-Funktionen ein
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ fügt unmittelbar vor der vorhergehenden Zeile zusätzliche Deklarationen ein.

#endif // AFX_EXCITERDLG_H__96A8D6B4_AF79_428D_BFDF_62E1325EFF61__INCLUDED_
