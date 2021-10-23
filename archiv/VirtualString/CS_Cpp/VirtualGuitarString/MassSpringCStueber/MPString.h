// MPString.h: Schnittstelle f�r die Klasse MPString.
// 2001, Christoph St�ber, cscs@cs.tu-berlin.de
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
	double m_exiterforce;					// Anschlagst�rke
	CPtrArray m_masses;						// Pointer-Array, das alle Instanzen der Massen speichert

	MPString();
	virtual ~MPString();

	MPMass* GetAt(int i );					// F�r 1D-String: R�ckgabe des Elements i
	MPMass2D* GetAt2D(int x, int y);		// F�r 2D-Plate: R�ckgabe des Elements (x,y)

	void CreateString(int n);				// String erzeugen
	void CreateRectPlate(int nx,int ny);	// Plate erzeugen
	void CreateUnweigtedString(int n);		// veraltet (den Elementen k�nnen leicht unterschiedliche Gewichte zugeordnet werden)

	void Reset();							// Bewegung stoppen
	void Pick();							// Ein einzelnes Element anregen
	void Sine(double f);					// Sinusf�rmige Auslenkung
	void Triangular(double to);				// Dreiecksf�rmige Auslenkung
	void Simulate( double dt);				// Simulationsschritt ausf�hren

};

#endif // !defined(AFX_MPSTRING_H__1F2361F8_6621_4E1A_947D_C9A83A539761__INCLUDED_)
