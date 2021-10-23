// MPMass.cpp: Implementierung der Klasse MPMass.
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "stdafx.h"
#include "MPMass.h"
#include <math.h>

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Konstruktion/Destruktion
//////////////////////////////////////////////////////////////////////
double MPMass::m_tension=1;
double MPMass::m_damping_c1=0.0001;
double MPMass::m_damping_c2=0.0001;
double MPMass::m_damping_c3=0.0001;
double MPMass::m_dispersion=0.0001;

double MPMass::m_b0=0;
double MPMass::m_b1=0;
double MPMass::m_b2=0;
double MPMass::m_b3=0;
double MPMass::m_b4=0;
double MPMass::m_b5=0;
double MPMass::m_b6=0;

MPMass::MPMass()
{
	m_pos[0]=0;
	m_pos[1]=0;
	m_pos[2]=0;

	m_posold[0]=0;
	m_posold[1]=0;
	m_posold[2]=0;

	m_posnew[0]=0;
	m_posnew[1]=0;
	m_posnew[2]=0;

	m_tension=1;
	m_mass=1;

	m_next=NULL;
	m_prev=NULL;
	
	m_force[0]=0;
	m_force[1]=0;
	m_force[2]=0;


}

MPMass::~MPMass()
{

}

void MPMass::Recalc(double dt)
{
}

void MPMass::Move(double dt)
{
}

