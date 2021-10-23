// MPMass2D.h: Schnittstelle für die Klasse MPMass2D.
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MPMASS2D_H__F4583555_3BEE_4A1E_AA50_B508BB9AF64E__INCLUDED_)
#define AFX_MPMASS2D_H__F4583555_3BEE_4A1E_AA50_B508BB9AF64E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "MPMass.h"

class MPMass2D : public MPMass  
{
public:
	void Move( double dt);
	double m_acc[3];
	double m_vel[3];
	void Recalc(double dt);
	MPMass2D();
	virtual ~MPMass2D();

	MPMass* m_up;
	MPMass* m_down;
};

#endif // !defined(AFX_MPMASS2D_H__F4583555_3BEE_4A1E_AA50_B508BB9AF64E__INCLUDED_)
