// MPMassKurz.cpp: Implementierung der Klasse MPMassKurz.
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "stdafx.h"
#include "MPMassKurz.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Konstruktion/Destruktion
//////////////////////////////////////////////////////////////////////

MPMassKurz::MPMassKurz()
{

}

MPMassKurz::~MPMassKurz()
{

}

// Berechnen der neuen Position eines Teilchens nach einem Zeitschritt
// mit dem Modell von Michael Kurz
void MPMassKurz::Recalc(double dt)
{
	// Es werden jeweils zwei Vorgänger und Nachfolger benötigt, um
	// die 1. bzw. 2. Ableitung zu approximieren
	if ( m_next && m_prev && m_next->m_next && m_prev->m_prev )
	{
		m_posnew[1]= m_b0 * m_pos[1] + 
			         m_b1 * (m_prev->m_pos[1] + m_next->m_pos[1]) +
				     m_b2 * (m_prev->m_prev->m_pos[1] + m_next->m_next->m_pos[1]) +
				     m_b3 * m_posold[1] + 
					 m_b4 * (m_prev->m_posold[1] + m_next->m_posold[1]) +
				     m_b5 * (m_prev->m_prev->m_posold[1] + m_next->m_next->m_posold[1]) +
				     m_b6 * m_force[1];
	}
}

// Neue Position annehmen
void MPMassKurz::Move(double dt)
{
	m_posold[1]=m_pos[1];
	m_pos[1]=m_posnew[1];
}
