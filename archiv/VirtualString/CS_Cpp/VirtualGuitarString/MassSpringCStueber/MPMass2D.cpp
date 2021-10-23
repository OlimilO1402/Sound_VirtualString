// MPMass2D.cpp: Implementierung der Klasse MPMass2D.
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "stdafx.h"
#include "MPMass2D.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Konstruktion/Destruktion
//////////////////////////////////////////////////////////////////////

MPMass2D::MPMass2D()
{
	m_up=NULL;
	m_down=NULL;

	m_pos[0]=0;
	m_pos[1]=0;
	m_pos[2]=0;

	m_vel[0]=0;
	m_vel[1]=0;
	m_vel[2]=0;

	m_acc[0]=0;
	m_acc[1]=0;
	m_acc[2]=0;

}

MPMass2D::~MPMass2D()
{

}

void MPMass2D::Recalc(double dt)
{
	double fa[3];
	fa[0]=0; fa[1]=0; fa[2]=0;
	double fb[3];
	fb[0]=0; fb[1]=0; fb[2]=0;
	
	if ( m_next && m_prev) 
	{
		fa[0]=- 2* m_pos[0] + m_prev->m_pos[0] + m_next->m_pos[0];
		fa[1]=- 2* m_pos[1] + m_prev->m_pos[1] + m_next->m_pos[1];
		fa[2]=- 2* m_pos[2] + m_prev->m_pos[2] + m_next->m_pos[2];
	}
	if ( m_up && m_down )
	{
		fb[0]=- 2* m_pos[0] + m_down->m_pos[0] + m_up->m_pos[0];
		fb[1]=- 2* m_pos[1] + m_down->m_pos[1] + m_up->m_pos[1];
		fb[2]=- 2* m_pos[2] + m_down->m_pos[2] + m_up->m_pos[2];
	}

	m_acc[0]=m_tension*(fa[0]+fb[0]);
	m_acc[1]=m_tension*(fa[1]+fb[1]);
	m_acc[2]=m_tension*(fa[2]+fb[2]);

	// update velocity
	m_vel[0]+=m_acc[0];
	m_vel[1]+=m_acc[1];
	m_vel[2]+=m_acc[2];

	// frquency independent damping
	m_vel[0]-=m_vel[0]*m_damping_c1;
	m_vel[1]-=m_vel[1]*m_damping_c1;
	m_vel[2]-=m_vel[2]*m_damping_c1;

}

void MPMass2D::Move(double dt)
{
	m_pos[0]+=m_vel[0];
	m_pos[1]+=m_vel[1];
	m_pos[2]+=m_vel[2];
}
