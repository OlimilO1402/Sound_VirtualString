// MassSpringDoc.cpp : Implementierung der Klasse CMassSpringDoc
// 2001, Christoph Stüber, cscs@cs.tu-berlin.de

#include "stdafx.h"
#include "MassSpring.h"

#include "MassSpringDoc.h"
#include "ReceiverDlg.h"
#include "ExciterDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMassSpringDoc

IMPLEMENT_DYNCREATE(CMassSpringDoc, CDocument)

BEGIN_MESSAGE_MAP(CMassSpringDoc, CDocument)
	//{{AFX_MSG_MAP(CMassSpringDoc)
	ON_COMMAND(ID_BUTTON32772, OnButton32772)
	ON_COMMAND(ID_BUTTON32776, OnButton32776)
	ON_COMMAND(ID_BUTTON32777, OnButton32777)
	ON_COMMAND(ID_PARAMETER_BIEGSAMESAITE, OnParameterBiegsamesaite)
	ON_COMMAND(ID_PARAMETER_STEIFERSTAB, OnParameterSteiferstab)
	ON_COMMAND(ID_PRESET_HOMOGENOUSSTRING, OnPresetHomogenousstring)
	ON_COMMAND(ID_PRESET_STRING, OnPresetString)
	ON_COMMAND(ID_PRESET_PLATE, OnPresetPlate)
	ON_COMMAND(ID_RECEIVER_SETPOSITION, OnReceiverSetposition)
	ON_COMMAND(ID_EXCITER_SETPOSITION, OnExciterSetposition)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMassSpringDoc Konstruktion/Destruktion

CMassSpringDoc::CMassSpringDoc()
{
	// ZU ERLEDIGEN: Hier Code für One-Time-Konstruktion einfügen
	m_sound=NULL;
	m_string=NULL;
	m_timepasser=0;
	m_sound_simu_dt=0;
}

CMassSpringDoc::~CMassSpringDoc()
{
	delete m_sound;
}

BOOL CMassSpringDoc::OnNewDocument()
{
	if (!CDocument::OnNewDocument())
		return FALSE;

	// ZU ERLEDIGEN: Hier Code zur Reinitialisierung einfügen
	// (SDI-Dokumente verwenden dieses Dokument)
	m_string=new MPString;
	m_string->CreateString(32);

	OnParameterBiegsamesaite();

	m_receiver=m_string->GetAt(15);
	m_receiverdim=1;
	m_outscale=1;
	

	return TRUE;
}



/////////////////////////////////////////////////////////////////////////////
// CMassSpringDoc Serialisierung

void CMassSpringDoc::Serialize(CArchive& ar)
{
	if (ar.IsStoring())
	{
		// ZU ERLEDIGEN: Hier Code zum Speichern einfügen
	}
	else
	{
		// ZU ERLEDIGEN: Hier Code zum Laden einfügen
	}
}

/////////////////////////////////////////////////////////////////////////////
// CMassSpringDoc Diagnose

#ifdef _DEBUG
void CMassSpringDoc::AssertValid() const
{
	CDocument::AssertValid();
}

void CMassSpringDoc::Dump(CDumpContext& dc) const
{
	CDocument::Dump(dc);
}
#endif //_DEBUG

/////////////////////////////////////////////////////////////////////////////
// CMassSpringDoc Befehle

void CMassSpringDoc::OnButton32772() 
{
	m_string->Pick();
}

void CMassSpringDoc::OnButton32773() 
{
	// TODO: Code für Befehlsbehandlungsroutine hier einfügen
	m_string->Triangular(0.25);	
}

void CMassSpringDoc::OnButton32775() 
{
	m_string->Sine(2);	
}

void CMassSpringDoc::OnButton32776() 
{
	// simulate to disk
	CFileDialog d(false);
	d.DoModal();
	CFile f;
	f.Open(d.GetPathName(), CFile::modeWrite | CFile::modeCreate);
	m_string->Pick;
	for ( long l=0; l<100000; l++)
	{
		m_string->Simulate(l);
		int b=GetReceiverSound();
		f.Write(&b,2);
	}
	f.Close();
}

void CMassSpringDoc::OnButton32777() 
{
	m_string->Reset();	
}

void CMassSpringDoc::FillBuffer(DWORD start, DWORD end)
{
	// fill a sound buffer from start to end asserting start<end

	LPVOID write1;
	DWORD length1;
	LPVOID write2;
	DWORD length2;
	DWORD playcursor,writecursor;
	HRESULT hr;
	// we lock the buffer and receive the write cursor from here on we can start writing the new data
	hr = m_sound->lpdsb[0]->Lock(0, m_sound->len[0], &write1, &length1,
														&write2, &length2, 0  );
	// we lost the buffer...
	if (hr == DSERR_BUFFERLOST)
	{
		m_sound->lpdsb[0]->Restore();

		hr = m_sound->lpdsb[0]->Lock(0, m_sound->len[0], &write1, &length1,
															&write2, &length2, 0 );
	}
	
	length1/=2;
	length2/=2;

	if ( start<length1)
	{
		if ( end <= length1 )
		{
			for ( DWORD i=start; i<end; i++)
			{
				SimuStep();
				((WORD*)write1)[i]=GetReceiverSound();
			}
		}
		else
		{
			for ( DWORD i=start; i<length1; i++)
			{
				SimuStep();
				((WORD*)write1)[i]=GetReceiverSound();
			}
			for ( i=0; i<end; i++)
			{
				SimuStep();
				((WORD*)write2)[i]=GetReceiverSound();
			}
		}
	} else
	{
		for ( DWORD i=start-length1; i<end-length1; i++)
		{
			SimuStep();
			((WORD*)write2)[i]=GetReceiverSound();
		}
	}

	hr = m_sound->lpdsb[0]->Unlock(write1, length1, write2, length2);

	if (hr != DS_OK)
	{
		exit(-1);
	}
}

void CMassSpringDoc::FillBufferCircular(DWORD start, DWORD end)
{
	if ( start < end )
	{
		FillBuffer(start,end);
	} else if ( start > end)
	{
		FillBuffer(start,m_soundbuffersize);
		FillBuffer(0,end);
	}
}


void CMassSpringDoc::FillNextBuffer()
{
	DWORD playcursor;
	m_sound->lpdsb[0]->GetCurrentPosition(&playcursor,NULL);
	playcursor/=2;
	FillBufferCircular(m_bufferpos,playcursor);
	m_bufferpos=playcursor;
}

void CMassSpringDoc::InitSound()
{
	if ( m_sound ) return;
	m_soundbuffersize=2000;
	m_sound = new DIRSOUND(AfxGetApp()->m_pMainWnd->m_hWnd);
	m_sound->sound[0]=(BYTE*)malloc(m_soundbuffersize*sizeof(WORD));
	m_sound->len[0]=m_soundbuffersize*sizeof(WORD);
	m_sound->CreateBuffer(0);
	m_sound->FillBuffer(0);
	m_sound->Start(0,true);
	m_bufferpos=0;
}


WORD CMassSpringDoc::GetReceiverSound()
{
	if (m_receiver->m_pos[m_receiverdim]*m_outscale>1)
	{
		m_string->Reset();
	}
	return m_receiver->m_pos[m_receiverdim]*m_outscale*32767;
}

void CMassSpringDoc::OnParameterBiegsamesaite() 
{
	m_string->Reset();
	m_string->GetAt(0)->m_damping_c1=0.00005;
	m_string->GetAt(0)->m_damping_c2=0.005;
	m_string->GetAt(0)->m_damping_c3=0;
	m_string->GetAt(0)->m_tension=0.1;
	m_string->GetAt(0)->m_dispersion=0;
	UpdateBParameters();
}

void CMassSpringDoc::OnParameterSteiferstab() 
{
	m_string->Reset();
	m_string->GetAt(0)->m_damping_c1=0.00005;
	m_string->GetAt(0)->m_damping_c2=0.005;
	m_string->GetAt(0)->m_damping_c3=0;
	m_string->GetAt(0)->m_tension=0;
	m_string->GetAt(0)->m_dispersion=0.22;
	UpdateBParameters();
}

void CMassSpringDoc::OnPresetHomogenousstring() 
{
	if ( m_string ) delete m_string;
	m_string=new MPString;
	m_string->CreateString(32);
	m_receiver=m_string->GetAt(15);
	m_receiverdim=1;
	m_outscale=1;
	
}

void CMassSpringDoc::OnPresetString() 
{
	if ( m_string ) delete m_string;

	m_string=new MPString;
	m_string->CreateUnweigtedString(32);
	m_receiver=m_string->GetAt(15);
	m_receiverdim=1;
	m_outscale=1;	
}

void CMassSpringDoc::OnPresetPlate() 
{
	if ( m_string ) delete m_string;

	m_string=new MPString;
	m_string->CreateRectPlate(6,6);
	m_receiver=m_string->GetAt(15);
	m_receiverdim=2;
	m_outscale=1;		
}

void CMassSpringDoc::UpdateBParameters()
{

	double aT=m_string->GetAt(0)->m_tension;
	double aEI=m_string->GetAt(0)->m_dispersion;
	double aC0=m_string->GetAt(0)->m_damping_c1;
	double aC1=m_string->GetAt(0)->m_damping_c2;
	double aC2=m_string->GetAt(0)->m_damping_c3;

	m_string->GetAt(0)->m_b0=2-2*aT-6*aEI-aC0-2*aC1-6*aC2;
	m_string->GetAt(0)->m_b1=aT+4*aEI+aC1+4*aC2;
	m_string->GetAt(0)->m_b2=-aEI-aC2;
	m_string->GetAt(0)->m_b3=-1+aC0+2*aC1+6*aC2;
	m_string->GetAt(0)->m_b4=-aC1-4*aC2;
	m_string->GetAt(0)->m_b5=aC2;
	m_string->GetAt(0)->m_b6=0;

}

void CMassSpringDoc::SimuStep()
{
	if ( m_timepasser > m_sound_simu_dt )
	{
		m_string->Simulate(1);
		m_timepasser=0;
	}
	m_timepasser+=1;
}

void CMassSpringDoc::OnReceiverSetposition() 
{
	CReceiverDlg dlg;
	dlg.m_position=0;
	dlg.DoModal();
	m_receiver=m_string->GetAt(dlg.m_position);
}

void CMassSpringDoc::OnExciterSetposition() 
{
	CExciterDlg dlg;
	dlg.m_position=0;
	dlg.DoModal();
	m_string->m_exciterposition=dlg.m_position;
	
}
