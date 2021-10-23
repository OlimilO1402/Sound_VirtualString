#if !defined(AFX_RECEIVERDLG_H__63C314CE_8494_424E_930E_D6049FD46E19__INCLUDED_)
#define AFX_RECEIVERDLG_H__63C314CE_8494_424E_930E_D6049FD46E19__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// ReceiverDlg.h : Header-Datei
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//

/////////////////////////////////////////////////////////////////////////////
// Dialogfeld CReceiverDlg 

class CReceiverDlg : public CDialog
{
// Konstruktion
public:
	CReceiverDlg(CWnd* pParent = NULL);   // Standardkonstruktor

// Dialogfelddaten
	//{{AFX_DATA(CReceiverDlg)
	enum { IDD = IDD_DIALOG1 };
	int		m_position;
	//}}AFX_DATA


// Überschreibungen
	// Vom Klassen-Assistenten generierte virtuelle Funktionsüberschreibungen
	//{{AFX_VIRTUAL(CReceiverDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV-Unterstützung
	//}}AFX_VIRTUAL

// Implementierung
protected:

	// Generierte Nachrichtenzuordnungsfunktionen
	//{{AFX_MSG(CReceiverDlg)
		// HINWEIS: Der Klassen-Assistent fügt hier Member-Funktionen ein
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ fügt unmittelbar vor der vorhergehenden Zeile zusätzliche Deklarationen ein.

#endif // AFX_RECEIVERDLG_H__63C314CE_8494_424E_930E_D6049FD46E19__INCLUDED_
