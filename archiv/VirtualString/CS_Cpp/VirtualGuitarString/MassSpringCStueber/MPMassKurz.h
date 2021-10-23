// MPMassKurz.h: Schnittstelle für die Klasse MPMassKurz.
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MPMASSKURZ_H__A54ACFCA_3F50_49C2_B1BA_82EA06280988__INCLUDED_)
#define AFX_MPMASSKURZ_H__A54ACFCA_3F50_49C2_B1BA_82EA06280988__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "MPMass.h"

class MPMassKurz : public MPMass  
{
public:
	void Move( double dt);
	void Recalc(double dt);
	MPMassKurz();
	virtual ~MPMassKurz();

};

#endif // !defined(AFX_MPMASSKURZ_H__A54ACFCA_3F50_49C2_B1BA_82EA06280988__INCLUDED_)
