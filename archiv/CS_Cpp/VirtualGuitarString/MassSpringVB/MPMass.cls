VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MPMass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'dient hauptsächlich als abstrakte Klasse
'static
'* Physikalische Parameter
Public Mass  As Double 'Masse
Public Prev  As MPMass 'Vorgänger. (für 1D-String)
Public NNext As MPMass 'Nachfolger
'  CPtrArray m_neighbors;        // Für Masseteilchen die mehr als zwei Nachbarn haben
Private mForce(0 To 2)  As Double
Private mPos(0 To 2)    As Double    'aktuelle Position des Teilchens (t=T)
Private mPosold(0 To 2) As Double 'Zwischenspeicher für die alte Position (t=T-1)
Private mPosnew(0 To 2) As Double 'Zwischenspeicher für die neue Position (t=T+1)
  
'  MPMass();
Private Sub Class_Initialize()
'  Tension = 1
'  DampingC1 = 0.0001
'  DampingC2 = 0.0001
'  DampingC3 = 0.0001
'  Dispersion = 0.0001
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

End Sub
Public Sub Recalc(dt As Double) ' // neue Position berechnen

End Sub


