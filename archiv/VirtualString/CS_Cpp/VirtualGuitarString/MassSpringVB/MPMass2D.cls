VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MPMass2D"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'static
'* Physikalische Parameter
Public Dispersion As Double 'Streuung ? Biegesteifigkeit EI
Public DampingC1  As Double 'Dämpferkonstante1
Public DampingC2  As Double 'Dämpferkonstante2
Public DampingC3  As Double 'Dämpferkonstante3
Public Tension    As Double 'Zugkraft
Public Mass       As Double 'Masse
Public B0 As Double 'Diese Modellparameter berechnen sich aus den
Public B1 As Double 'physikalischen Parametern
Public B2 As Double '(s. void CMassSpringDoc::UpdateBParameters() )
Public B3 As Double 'nur um Berechnungszeit zu sparen. Diese werden nur
Public B4 As Double 'bei Änderung eines Parameters neu berechnet.
Public B5 As Double '
Public B6 As Double '
Public Prev  As MPMass 'Vorgänger. (für 1D-String)
Public NNext As MPMass 'Nachfolger
'nur in 2D:
Public Up    As MPMass
Public Down  As MPMass
'  CPtrArray m_neighbors;        // Für Masseteilchen die mehr als zwei Nachbarn haben
Public Neighbors As Collection '
'Private Member
Private mForce(0 To 2) As Double
Private mPos(0 To 2) As Double 'aktuelle Position des Teilchens (t=T)
Private mPosold(0 To 2) As Double 'Zwischenspeicher für die alte Position (t=T-1)
Private mPosnew(0 To 2) As Double 'Zwischenspeicher für die neue Position (t=T+1)
Private mAcc(0 To 2) As Double
Private mVel(0 To 2) As Double

'  MPMass();
Private Sub Class_Initialize()
  Set Neighbors = New Collection
  Tension = 1
  DampingC1 = 0.0001
  DampingC2 = 0.0001
  DampingC3 = 0.0001
  Dispersion = 0.0001
  Mass = 1
End Sub
'  virtual ~MPMass();
Private Sub Class_Terminate()

End Sub

Public Property Get Force(Index As Long) As Double
  Force = mForce(Index)
End Property
'Public Property Let Force(Index As Long, DblVal As Double)
'  mForce(Index) = DblVal
'End Property

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
  mPos(0) = mPos(0) + mVel(0)
  mPos(1) = mPos(1) + mVel(1)
  mPos(2) = mPos(2) + mVel(2)
End Sub
Public Sub Recalc(dt As Double) ' // neue Position berechnen
Dim fa(0 To 2) As Double
Dim fb(0 To 2) As Double

  If (NNext And Prev) Then
    fa(0) = -2 * mPos(0) + Prev.Pos(0) + NNext.Pos(0)
    fa(1) = -2 * mPos(1) + Prev.Pos(1) + NNext.Pos(1)
    fa(2) = -2 * mPos(2) + Prev.Pos(2) + NNext.Pos(2)
  End If
  If (Up And Down) Then
    fb(0) = -2 * mPos(0) + Down.Pos(0) + Up.Pos(0)
    fb(1) = -2 * mPos(1) + Down.Pos(1) + Up.Pos(1)
    fb(2) = -2 * mPos(2) + Down.Pos(2) + Up.Pos(2)
  End If

  mAcc(0) = Tension * (fa(0) + fb(0))
  mAcc(1) = Tension * (fa(1) + fb(1))
  mAcc(2) = Tension * (fa(2) + fb(2))

  'update velocity
  mVel(0) = mVel(0) + mAcc(0)
  mVel(1) = mVel(1) + mAcc(1)
  mVel(2) = mVel(2) + mAcc(2)

  'frquency independent damping
  mVel(0) = mVel(0) - mVel(0) * DampingC1
  mVel(1) = mVel(1) - mVel(1) * DampingC1
  mVel(2) = mVel(2) - mVel(2) * DampingC1

End Sub



