// ReceiverDlg.cpp: Implementierungsdatei
// 2001, Christoph St�ber, cscs@cs.tu-berlin.de


#include "stdafx.h"
#include "MassSpring.h"
#include "ReceiverDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// Dialogfeld CReceiverDlg 


CReceiverDlg::CReceiverDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CReceiverDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CReceiverDlg)
	m_position = 0;
	//}}AFX_DATA_INIT
}


void CReceiverDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CReceiverDlg)
	DDX_Text(pDX, IDC_EDIT1, m_position);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CReceiverDlg, CDialog)
	//{{AFX_MSG_MAP(CReceiverDlg)
		// HINWEIS: Der Klassen-Assistent f�gt hier Zuordnungsmakros f�r Nachrichten ein
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// Behandlungsroutinen f�r Nachrichten CReceiverDlg 
