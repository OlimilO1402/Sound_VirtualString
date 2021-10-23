// ExciterDlg.cpp: Implementierungsdatei
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de

#include "stdafx.h"
#include "MassSpring.h"
#include "ExciterDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// Dialogfeld CExciterDlg 


CExciterDlg::CExciterDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExciterDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CExciterDlg)
	m_position = 0;
	//}}AFX_DATA_INIT
}


void CExciterDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CExciterDlg)
	DDX_Text(pDX, IDC_EDIT1, m_position);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CExciterDlg, CDialog)
	//{{AFX_MSG_MAP(CExciterDlg)
		// HINWEIS: Der Klassen-Assistent fügt hier Zuordnungsmakros für Nachrichten ein
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// Behandlungsroutinen für Nachrichten CExciterDlg 
