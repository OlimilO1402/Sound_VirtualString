// MPString.cpp: Implementierung der Klasse MPString.
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "stdafx.h"
#include "MPString.h"
#include "MPMass2d.h"
#include "MPMassStueber.h"
#include "MPMassKurz.h"

#include <math.h>

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Konstruktion/Destruktion
//////////////////////////////////////////////////////////////////////

MPString::MPString()
{
	m_nx=0;
	m_ny=0;
	m_exiterforce=0.5;
	m_exciterposition=3;
	m_exciterdim=1;
}

MPString::~MPString()
{

}

MPMass* MPString::GetAt(int i)
{
	return (MPMass*)m_masses.GetAt(i);
}

void MPString::CreateString(int n)
{
	m_nx=n;
	m_ny=1;
	m_masses.RemoveAll();
	// create first element
	MPMass* f=new MPMassKurz;
	f->m_mass=1;
	f->m_tension=1;
	f->m_prev=NULL;
	f->m_pos[0]=0;
	f->m_pos[1]=0;
	f->m_pos[2]=0;
	m_masses.Add(f);

	for ( int x=1; x<n; x++)
	{
		f->m_next=new MPMassKurz;
		f->m_next->m_prev=f;
		f=f->m_next;

		f->m_mass=1;
		f->m_tension=1;
		f->m_pos[0]=float(x)/float(n);
		f->m_pos[1]=0;
		f->m_pos[2]=0;
		m_masses.Add(f);
	}
	f->m_next=NULL;

}

void MPString::Simulate(double dt)
{
	for ( int i=0; i<m_masses.GetSize()-1; i++)
	{
		GetAt(i)->Recalc(dt);
	}
	for ( i=0; i<m_masses.GetSize()-1; i++)
	{
		GetAt(i)->Move(dt);
	}
}

void MPString::Triangular(double to)
{
	double m=m_exiterforce/GetAt(to*m_masses.GetSize())->m_pos[0];
	for ( int i=1; i<to*m_masses.GetSize(); i++)
	{
		GetAt(i)->m_pos[1]+=m*GetAt(i)->m_pos[0];
	}
	m=-m_exiterforce/(GetAt(m_masses.GetSize()-1)->m_pos[0]-GetAt(to*m_masses.GetSize())->m_pos[0]);
	for ( i=to*m_masses.GetSize(); i<m_masses.GetSize()-1; i++)
	{
		GetAt(i)->m_pos[1]+=GetAt(to*m_masses.GetSize())->m_pos[1]+m*(-GetAt(to*m_masses.GetSize())->m_pos[0]+GetAt(i)->m_pos[0]);
	}
}

void MPString::Sine(double f)
{
	double pi=3.141592;
	for ( int i=1; i<m_masses.GetSize()-1; i++)
	{
		GetAt(i)->m_pos[1]+=m_exiterforce*sin( GetAt(i)->m_pos[0]*2*pi*f);
	}
}

void MPString::Reset()
{
	for ( int i=0; i<m_masses.GetSize(); i++)
	{
		GetAt(i)->m_pos[m_exciterdim]=0;
	}	
}

void MPString::CreateUnweigtedString(int n)
{
	m_nx=n;
	m_ny=1;
	m_masses.RemoveAll();
	// create first element
	MPMass* f=new MPMass;
	f->m_mass=1;
	f->m_tension=1;
	m_masses.Add(f);

	for ( int x=1; x<n; x++)
	{
		f->m_next=new MPMass;
		f->m_next->m_prev=f;
		f=f->m_next;

		f->m_mass=0.5+(x%4)*0.5;
		f->m_pos[0]=float(x)/float(n);
		m_masses.Add(f);
	}
	f->m_next=NULL;

}

void MPString::CreateRectPlate(int nx, int ny)
{
	m_masses.RemoveAll();
	m_nx=nx; m_ny=ny;

	m_exciterdim=2;
	// create first element

	// create the masses
	for ( int y=0; y<ny; y++)
	{
		for ( int x=0; x<nx; x++)
		{
			MPMass2D* f=new MPMass2D;
			f->m_mass=1;
			f->m_tension=1;
			f->m_pos[0]=float(x)/float(nx);
			f->m_pos[1]=float(y)/float(ny);
			m_masses.Add(f);
		}
	}
	// link them
	for (  y=0; y<ny; y++)
	{
		for ( int x=0; x<nx; x++)
		{
			MPMass2D* f=GetAt2D(x,y);
			if ( y>0 ) f->m_up=GetAt2D(x,y-1);
			if ( x>0 ) f->m_prev=GetAt2D(x-1,y);
			if ( x<nx-1 ) f->m_next=GetAt2D(x+1,y);
			if ( y<ny-1 ) f->m_down=GetAt2D(x,y+1);
		}
	}
}

MPMass2D* MPString::GetAt2D(int x, int y)
{
	return (MPMass2D*)GetAt(x+y*m_nx);
}

void MPString::Pick()
{
	GetAt(m_exciterposition)->m_pos[m_exciterdim]+=m_exiterforce*0.5;
}
