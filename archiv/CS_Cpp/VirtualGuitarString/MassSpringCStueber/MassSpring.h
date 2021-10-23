// MassSpring.h : Haupt-Header-Datei für die Anwendung MASSSPRING
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//

#if !defined(AFX_MASSSPRING_H__45ED259D_5C79_42EE_8A60_5FE476AF5645__INCLUDED_)
#define AFX_MASSSPRING_H__45ED259D_5C79_42EE_8A60_5FE476AF5645__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // Hauptsymbole

/////////////////////////////////////////////////////////////////////////////
// CMassSpringApp:
// Siehe MassSpring.cpp für die Implementierung dieser Klasse
//

class CMassSpringApp : public CWinApp
{
public:
	CMassSpringApp();

// Überladungen
	// Vom Klassenassistenten generierte Überladungen virtueller Funktionen
	//{{AFX_VIRTUAL(CMassSpringApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementierung
	//{{AFX_MSG(CMassSpringApp)
	afx_msg void OnAppAbout();
		// HINWEIS - An dieser Stelle werden Member-Funktionen vom Klassen-Assistenten eingefügt und entfernt.
		//    Innerhalb dieser generierten Quelltextabschnitte NICHTS VERÄNDERN!
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ fügt unmittelbar vor der vorhergehenden Zeile zusätzliche Deklarationen ein.

#endif // !defined(AFX_MASSSPRING_H__45ED259D_5C79_42EE_8A60_5FE476AF5645__INCLUDED_)
