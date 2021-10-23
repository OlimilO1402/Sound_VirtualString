// MassSpringView.h : Schnittstelle der Klasse CMassSpringView
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//
/////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_MASSSPRINGVIEW_H__A31A01E1_E553_481B_B5A8_CB2B8E66A8AA__INCLUDED_)
#define AFX_MASSSPRINGVIEW_H__A31A01E1_E553_481B_B5A8_CB2B8E66A8AA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CMassSpringDoc;

class CMassSpringView : public CView
{
protected: // Nur aus Serialisierung erzeugen
	CMassSpringView();
	DECLARE_DYNCREATE(CMassSpringView)

// Attribute
public:
	CMassSpringDoc* GetDocument();

// Operationen
public:

// Überladungen
	// Vom Klassenassistenten generierte Überladungen virtueller Funktionen
	//{{AFX_VIRTUAL(CMassSpringView)
	public:
	virtual void OnDraw(CDC* pDC);  // überladen zum Zeichnen dieser Ansicht
	virtual BOOL PreCreateWindow(CREATESTRUCT& cs);
	protected:
	virtual BOOL OnPreparePrinting(CPrintInfo* pInfo);
	virtual void OnBeginPrinting(CDC* pDC, CPrintInfo* pInfo);
	virtual void OnEndPrinting(CDC* pDC, CPrintInfo* pInfo);
	//}}AFX_VIRTUAL

// Implementierung
public:
	int m_updatesteps;
	void ParameterChange(CScrollBar* pScrollBar);
	virtual ~CMassSpringView();
#ifdef _DEBUG
	virtual void AssertValid() const;
	virtual void Dump(CDumpContext& dc) const;
#endif

protected:

// Generierte Message-Map-Funktionen
protected:
	//{{AFX_MSG(CMassSpringView)
	afx_msg void OnButton32771();
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnReleasedcaptureSlider1(NMHDR* pNMHDR, LRESULT* pResult);
	afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	afx_msg void OnButton32785();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

#ifndef _DEBUG  // Testversion in MassSpringView.cpp
inline CMassSpringDoc* CMassSpringView::GetDocument()
   { return (CMassSpringDoc*)m_pDocument; }
#endif

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ fügt unmittelbar vor der vorhergehenden Zeile zusätzliche Deklarationen ein.

#endif // !defined(AFX_MASSSPRINGVIEW_H__A31A01E1_E553_481B_B5A8_CB2B8E66A8AA__INCLUDED_)
