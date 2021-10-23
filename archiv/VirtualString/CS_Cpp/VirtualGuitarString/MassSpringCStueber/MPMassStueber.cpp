// MPMassStueber.cpp: Implementierung der Klasse MPMassStueber.
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "stdafx.h"
#include "MPMassStueber.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Konstruktion/Destruktion
//////////////////////////////////////////////////////////////////////

MPMassStueber::MPMassStueber()
{

}

MPMassStueber::~MPMassStueber()
{

}

void MPMassStueber::Move(double dt)
{
	m_posold[0]=m_pos[0];
	m_posold[1]=m_pos[1];
	m_posold[2]=m_pos[2];

	m_pos[0]=m_posnew[0];
	m_pos[1]=m_posnew[1];
	m_pos[2]=m_posnew[2];
}

void MPMassStueber::Recalc(double dt)
{
	if ( !m_prev || !m_next || !m_next->m_next || !m_prev->m_prev ) return;

	m_posnew[0]=m_b0*m_pos[0]+m_b1*(m_prev->m_pos[0]+m_next->m_pos[0]) +
			m_b2*(m_prev->m_prev->m_pos[0]+m_next->m_next->m_pos[0]) +
			m_b3*m_posold[0]+m_b4*(m_prev->m_posold[0]+m_next->m_posold[0] ) +
			m_b5*(m_prev->m_prev->m_posold[0]+m_next->m_next->m_posold[0] ) +
			m_b6*m_force[0];

	m_posnew[1]=m_b0*m_pos[1]+m_b1*(m_prev->m_pos[1]+m_next->m_pos[1]) +
			m_b2*(m_prev->m_prev->m_pos[1]+m_next->m_next->m_pos[1]) +
			m_b3*m_posold[1]+m_b4*(m_prev->m_posold[1]+m_next->m_posold[1] ) +
			m_b5*(m_prev->m_prev->m_posold[1]+m_next->m_next->m_posold[1] ) +
			m_b6*m_force[1];

	m_posnew[2]=m_b0*m_pos[2]+m_b1*(m_prev->m_pos[2]+m_next->m_pos[2]) +
			m_b2*(m_prev->m_prev->m_pos[2]+m_next->m_next->m_pos[2]) +
			m_b3*m_posold[2]+m_b4*(m_prev->m_posold[2]+m_next->m_posold[2] ) +
			m_b5*(m_prev->m_prev->m_posold[2]+m_next->m_next->m_posold[2] ) +
			m_b6*m_force[2];

}