// MPMass.h: Schnittstelle für die Klasse MPMass.
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MPMASS_H__98B9C700_C079_494F_A858_A55E084F0FFD__INCLUDED_)
#define AFX_MPMASS_H__98B9C700_C079_494F_A858_A55E084F0FFD__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class MPMass;

// Klasse für ein "Masseteilichen"
// Bildet die Basisklasse für MPMass2D, MPMassKurz und MPMAssStueber

class MPMass  
{

public:
	virtual void Move( double dt);		// Teilchen bewegen (neue Position annehmen)
	virtual void Recalc(double dt);		// neue Position berechnen

public:
	static double m_dispersion;			// * Physikalische Parameter
	static double m_damping_c1;			// *
	static double m_damping_c2;			// *
	static double m_damping_c3;			// *
	static double m_tension;			// *
	double m_mass;						// *
	double m_force[3];					// *
	
	static double m_b0;					// * Diese Modellparameter berechnen sich aus den
	static double m_b1;					// * physikalischen Parametern
	static double m_b2;					// * (s. void CMassSpringDoc::UpdateBParameters() )
	static double m_b3;					// * nur um Berechnungszeit zu sparen. Diese werden nur
	static double m_b4;					// * bei Änderung eines Parameters neu berechnet.
	static double m_b5;					// *
	static double m_b6;					// *

	MPMass* m_prev;						// Vorgänger. (für 1D-String)
	MPMass* m_next;						// Nachfolger
	CPtrArray m_neighbors;				// Für Masseteilchen die mehr als zwei Nachbarn haben
	
	double m_pos[3];					// aktuelle Position des Teilchens (t=T)
	double m_posold[3];					// Zwischenspeicher für die alte Position (t=T-1)
	double m_posnew[3];					// Zwischenspeicher für die neue Position (t=T+1)
	MPMass();
	virtual ~MPMass();

};

#endif // !defined(AFX_MPMASS_H__98B9C700_C079_494F_A858_A55E084F0FFD__INCLUDED_)
