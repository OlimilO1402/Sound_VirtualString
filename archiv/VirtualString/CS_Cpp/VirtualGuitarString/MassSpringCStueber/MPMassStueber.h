// MPMassStueber.h: Schnittstelle für die Klasse MPMassStueber.
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MPMASSSTUEBER_H__7B93087D_3EAF_4509_9278_C0BE3B8E34EB__INCLUDED_)
#define AFX_MPMASSSTUEBER_H__7B93087D_3EAF_4509_9278_C0BE3B8E34EB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "MPMass.h"

class MPMassStueber : public MPMass  
{
public:
	void Recalc( double dt );
	void Move(double dt);
	MPMassStueber();
	virtual ~MPMassStueber();

};

#endif // !defined(AFX_MPMASSSTUEBER_H__7B93087D_3EAF_4509_9278_C0BE3B8E34EB__INCLUDED_)
