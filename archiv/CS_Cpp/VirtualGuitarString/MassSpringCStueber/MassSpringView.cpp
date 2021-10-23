// MassSpringView.cpp : Implementierung der Klasse CMassSpringView
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de

#include "stdafx.h"
#include "MassSpring.h"

#include "MassSpringDoc.h"
#include "MassSpringView.h"
#include <math.h>

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMassSpringView

IMPLEMENT_DYNCREATE(CMassSpringView, CView)

BEGIN_MESSAGE_MAP(CMassSpringView, CView)
	//{{AFX_MSG_MAP(CMassSpringView)
	ON_COMMAND(ID_BUTTON32771, OnButton32771)
	ON_WM_TIMER()
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_SLIDER1, OnReleasedcaptureSlider1)
	ON_WM_HSCROLL()
	ON_COMMAND(ID_BUTTON32785, OnButton32785)
	//}}AFX_MSG_MAP
	// Standard-Druckbefehle
	ON_COMMAND(ID_FILE_PRINT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_DIRECT, CView::OnFilePrint)
	ON_COMMAND(ID_FILE_PRINT_PREVIEW, CView::OnFilePrintPreview)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMassSpringView Konstruktion/Destruktion

CMassSpringView::CMassSpringView()
{
	// ZU ERLEDIGEN: Hier Code zur Konstruktion einfügen,

}

CMassSpringView::~CMassSpringView()
{
}

BOOL CMassSpringView::PreCreateWindow(CREATESTRUCT& cs)
{
	// ZU ERLEDIGEN: Ändern Sie hier die Fensterklasse oder das Erscheinungsbild, indem Sie
	//  CREATESTRUCT cs modifizieren.

	return CView::PreCreateWindow(cs);
}

/////////////////////////////////////////////////////////////////////////////
// CMassSpringView Zeichnen

void CMassSpringView::OnDraw(CDC* pDC)
{
	CMassSpringDoc* pDoc = GetDocument();
	ASSERT_VALID(pDoc);
	// ZU ERLEDIGEN: Hier Code zum Zeichnen der ursprünglichen Daten hinzufügen

	double yscale=0.5;

	for ( int y=0; y<pDoc->m_string->m_ny; y++)
	{
		for ( int x=0; x<pDoc->m_string->m_nx; x++)
		{
			pDC->Rectangle(100+pDoc->m_string->GetAt2D(x,y)->m_pos[0]*650-pDoc->m_string->GetAt2D(x,y)->m_pos[2]*30,
						   100+pDoc->m_string->GetAt2D(x,y)->m_pos[1]*yscale*450-pDoc->m_string->GetAt2D(x,y)->m_pos[2]*30,
						   120+pDoc->m_string->GetAt2D(x,y)->m_pos[0]*650+pDoc->m_string->GetAt2D(x,y)->m_pos[2]*30,
						   120+pDoc->m_string->GetAt2D(x,y)->m_pos[1]*yscale*450+pDoc->m_string->GetAt2D(x,y)->m_pos[2]*30);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////
// CMassSpringView Drucken

BOOL CMassSpringView::OnPreparePrinting(CPrintInfo* pInfo)
{
	// Standardvorbereitung
	return DoPreparePrinting(pInfo);
}

void CMassSpringView::OnBeginPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// ZU ERLEDIGEN: Zusätzliche Initialisierung vor dem Drucken hier einfügen
}

void CMassSpringView::OnEndPrinting(CDC* /*pDC*/, CPrintInfo* /*pInfo*/)
{
	// ZU ERLEDIGEN: Hier Bereinigungsarbeiten nach dem Drucken einfügen
}

/////////////////////////////////////////////////////////////////////////////
// CMassSpringView Diagnose

#ifdef _DEBUG
void CMassSpringView::AssertValid() const
{
	CView::AssertValid();
}

void CMassSpringView::Dump(CDumpContext& dc) const
{
	CView::Dump(dc);
}

CMassSpringDoc* CMassSpringView::GetDocument() // Die endgültige (nicht zur Fehlersuche kompilierte) Version ist Inline
{
	ASSERT(m_pDocument->IsKindOf(RUNTIME_CLASS(CMassSpringDoc)));
	return (CMassSpringDoc*)m_pDocument;
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CMassSpringView Nachrichten-Handler

void CMassSpringView::OnButton32771() 
{
	GetDocument()->InitSound();
	SetTimer(1,40,NULL);
}

void CMassSpringView::OnTimer(UINT nIDEvent) 
{
	// automatic timed picking
	if ( nIDEvent==2)
	{
		return;
	}

	GetDocument()->FillNextBuffer();

	Invalidate(TRUE);
	CView::OnTimer(nIDEvent);
}

void CMassSpringView::OnReleasedcaptureSlider1(NMHDR* pNMHDR, LRESULT* pResult) 
{
	*pResult = 0;
}

void CMassSpringView::OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar) 
{
	CView::OnHScroll(nSBCode, nPos, pScrollBar);
}

void CMassSpringView::ParameterChange(CScrollBar *pScrollBar)
{
	CSliderCtrl* slb=(CSliderCtrl*)pScrollBar;
	CString name;
	char txt[10000];
	slb->GetWindowText(txt,10000);
	name=txt;
	double value=float(slb->GetPos())/float(1000);
	if ( name=="force")
	{
		GetDocument()->m_string->GetAt(0)->m_tension=value*0.25;
	}
	if ( name=="damping_c1")
	{
		GetDocument()->m_string->GetAt(0)->m_damping_c1=value*0.005;
	}
	if ( name=="damping_c2")
	{
		GetDocument()->m_string->GetAt(0)->m_damping_c2=value*0.1;
	}
	if ( name=="damping_c3")
	{
		GetDocument()->m_string->GetAt(0)->m_damping_c3=value*0.01;
	}
	if ( name=="dispersion")
	{
		GetDocument()->m_string->GetAt(0)->m_dispersion=value*0.22;
	}
	if ( name=="outscale")
	{
		GetDocument()->m_outscale=value;
	}
	if ( name=="updatesteps")
	{
		GetDocument()->m_sound_simu_dt=value*1000;
	}
	if ( name=="exiterforce")
	{
		GetDocument()->m_string->m_exiterforce=value;
	}
	GetDocument()->UpdateBParameters();
}

void CMassSpringView::OnButton32785() 
{
	KillTimer(1);	
}
