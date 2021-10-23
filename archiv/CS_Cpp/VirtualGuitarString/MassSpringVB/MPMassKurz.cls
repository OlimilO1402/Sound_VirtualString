VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MPMassKurz"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'Implements IMPMass
Public Mass       As Double      'Masse
Public MPString As MPString
Public Prev  As MPMassKurz 'Vorgänger. (für 1D-String)
Public NNext As MPMassKurz 'Nachfolger
'  CPtrArray m_neighbors;        // Für Masseteilchen die mehr als zwei Nachbarn haben
Private mForce(0 To 2)  As Double
Private mPos(0 To 2)    As Double    'aktuelle Position des Teilchens (t=T)
Private mPosold(0 To 2) As Double 'Zwischenspeicher für die alte Position (t=T-1)
Private mPosnew(0 To 2) As Double 'Zwischenspeicher für die neue Position (t=T+1)
  
'  MPMass();
Private Sub Class_Initialize()
  Mass = 1
End Sub
'  virtual ~MPMass();
Private Sub Class_Terminate()

End Sub

Public Property Get Force(Index As Long) As Double
  Force = mForce(Index)
End Property
Public Property Let Force(Index As Long, DblVal As Double)
  mForce(Index) = DblVal
End Property

Public Property Get Pos(Index As Long) As Double
  Pos = mPos(Index)
End Property
Public Property Let Pos(Index As Long, DblVal As Double)
  mPos(Index) = DblVal
End Property

Public Property Get PosOld(Index As Long) As Double
  PosOld = mPosold(Index)
End Property
Public Property Let PosOld(Index As Long, DblVal As Double)
  mPosold(Index) = DblVal
End Property

Public Property Get PosNew(Index As Long) As Double
  PosNew = mPosnew(Index)
End Property
Public Property Let PosNew(Index As Long, DblVal As Double)
  mPosnew(Index) = DblVal
End Property

Public Sub Move(dt As Double)  ' // Teilchen bewegen (neue Position annehmen)
  mPosold(1) = mPos(1)
  mPos(1) = mPosnew(1)
End Sub
Public Sub Recalc(dt As Double) ' // neue Position berechnen
'Berechnen der neuen Position eines Teilchens nach einem Zeitschritt
'mit dem Modell von Michael Kurz
'Es werden jeweils zwei Vorgänger und Nachfolger benötigt, um
'die 1. bzw. 2. Ableitung zu approximieren
  If (IsNotNothing(NNext) And IsNotNothing(Prev)) Then
    If (IsNotNothing(NNext.NNext) And IsNotNothing(Prev.Prev)) Then
    mPosnew(1) = MPString.B0 * (mPos(1)) + _
                 MPString.B1 * (Prev.Pos(1) + NNext.Pos(1)) + _
                 MPString.B2 * (Prev.Prev.Pos(1) + NNext.NNext.Pos(1)) + _
                 MPString.B3 * (mPosold(1)) + _
                 MPString.B4 * (Prev.PosOld(1) + NNext.PosOld(1)) + _
                 MPString.B5 * (Prev.Prev.PosOld(1) + NNext.NNext.PosOld(1)) + _
                 MPString.B6 * (mForce(1))
    'm_posnew[1]= m_b0 * m_pos[1] +
    '             m_b1 * (m_prev->m_pos[1] + m_next->m_pos[1]) +
    '             m_b2 * (m_prev->m_prev->m_pos[1] + m_next->m_next->m_pos[1]) +
    '             m_b3 * m_posold[1]+
    '             m_b4 * (m_prev->m_posold[1] + m_next->m_posold[1]) +
    '             m_b5 * (m_prev->m_prev->m_posold[1] + m_next->m_next->m_posold[1]) +
    '             m_b6 * m_force[1];
    End If
  End If
End Sub
Private Function IsNotNothing(aObj As Object) As Boolean
  If Not aObj Is Nothing Then IsNotNothing = True
End Function
'##############################' Implements IMPMass '##############################'
'Private Property Get IMPMass_Pos(Index As Long) As Double
'  IMPMass_Pos = Pos(Index)
'End Property
'Private Property Let IMPMass_Pos(Index As Long, RHS As Double)
'  Pos(Index) = RHS
'End Property
'
'Private Property Get IMPMass_Prev() As IMPMass
'  Set IMPMass_Prev = Prev
'End Property
'Private Property Set IMPMass_Prev(RHS As IMPMass)
'  Set Prev = RHS
'End Property
'Private Property Get IMPMass_NNext() As IMPMass
'  Set IMPMass_NNext = NNext
'End Property
'Private Property Set IMPMass_NNext(RHS As IMPMass)
'  Set NNext = RHS
'End Property
'
'Private Sub IMPMass_Move(dt As Double)
'  Call Move(dt)
'End Sub
'Private Sub IMPMass_Recalc(dt As Double)
'  Call Recalc(dt)
'End Sub
