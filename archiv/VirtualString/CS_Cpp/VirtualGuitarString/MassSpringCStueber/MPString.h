// MPString.h: Schnittstelle für die Klasse MPString.
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MPSTRING_H__1F2361F8_6621_4E1A_947D_C9A83A539761__INCLUDED_)
#define AFX_MPSTRING_H__1F2361F8_6621_4E1A_947D_C9A83A539761__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


#include "MPMass.h"
#include "MPMass2D.h"

class MPString  
{
public:
	int m_exciterdim;						// Dimension (1=String 2=Plate)
	int m_exciterposition;					// Anschlagposition
	int m_ny;								// Anzahl Masseteilchen in Y-Reichtung
	int m_nx;								// Anzahl Masseteilchen in X-Reichtung
	double m_exiterforce;					// Anschlagstärke
	CPtrArray m_masses;						// Pointer-Array, das alle Instanzen der Massen speichert

	MPString();
	virtual ~MPString();

	MPMass* GetAt(int i );					// Für 1D-String: Rückgabe des Elements i
	MPMass2D* GetAt2D(int x, int y);		// Für 2D-Plate: Rückgabe des Elements (x,y)

	void CreateString(int n);				// String erzeugen
	void CreateRectPlate(int nx,int ny);	// Plate erzeugen
	void CreateUnweigtedString(int n);		// veraltet (den Elementen können leicht unterschiedliche Gewichte zugeordnet werden)

	void Reset();							// Bewegung stoppen
	void Pick();							// Ein einzelnes Element anregen
	void Sine(double f);					// Sinusförmige Auslenkung
	void Triangular(double to);				// Dreiecksförmige Auslenkung
	void Simulate( double dt);				// Simulationsschritt ausführen

};

#endif // !defined(AFX_MPSTRING_H__1F2361F8_6621_4E1A_947D_C9A83A539761__INCLUDED_)
