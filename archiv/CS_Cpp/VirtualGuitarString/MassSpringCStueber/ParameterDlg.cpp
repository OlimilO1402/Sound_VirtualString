// ParameterDlg.cpp: Implementierungsdatei
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de


#include "stdafx.h"
#include "MassSpringView.h"
#include "MassSpring.h"
#include "MainFrm.h"
#include "ParameterDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// Dialogfeld CParameterDlg 


CParameterDlg::CParameterDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CParameterDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CParameterDlg)
	//}}AFX_DATA_INIT
}


void CParameterDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CParameterDlg)
	DDX_Control(pDX, IDC_SLIDER8, m_force);
	DDX_Control(pDX, IDC_SLIDER7, m_outscale);
	DDX_Control(pDX, IDC_SLIDER6, m_dispersion);
	DDX_Control(pDX, IDC_SLIDER5, m_damping_c3);
	DDX_Control(pDX, IDC_SLIDER4, m_damping_c2);
	DDX_Control(pDX, IDC_SLIDER3, m_updatesteps);
	DDX_Control(pDX, IDC_SLIDER2, m_damping_c1);
	DDX_Control(pDX, IDC_SLIDER1, m_tension);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CParameterDlg, CDialog)
	//{{AFX_MSG_MAP(CParameterDlg)
	ON_WM_HSCROLL()
	ON_WM_CREATE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// Behandlungsroutinen für Nachrichten CParameterDlg 

void CParameterDlg::OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar) 
{
	((CMassSpringView*)(((CMainFrame*)GetParent()))->GetActiveView())->ParameterChange(pScrollBar);
	CDialog::OnHScroll(nSBCode, nPos, pScrollBar);
}


void CParameterDlg::Init()
{
	m_tension.SetRangeMin(0);
	m_tension.SetRangeMax(1000);
	m_tension.SetWindowText("force");

	m_damping_c1.SetRangeMin(0);
	m_damping_c1.SetRangeMax(1000);
	m_damping_c1.SetWindowText("damping_c1");

	m_damping_c2.SetRangeMin(0);
	m_damping_c2.SetRangeMax(1000);
	m_damping_c2.SetWindowText("damping_c2");

	m_damping_c3.SetRangeMin(0);
	m_damping_c3.SetRangeMax(1000);
	m_damping_c3.SetWindowText("damping_c3");

	m_dispersion.SetRangeMin(0);
	m_dispersion.SetRangeMax(1000);
	m_dispersion.SetWindowText("dispersion");

	m_outscale.SetRangeMin(0);
	m_outscale.SetRangeMax(1000);
	m_outscale.SetWindowText("outscale");

	m_force.SetRangeMin(0);
	m_force.SetRangeMax(1000);
	m_force.SetWindowText("exiterforce");

	m_updatesteps.SetRangeMin(1);
	m_updatesteps.SetRangeMax(1000);
	m_updatesteps.SetWindowText("updatesteps");

}
