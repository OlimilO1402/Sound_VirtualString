VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "IMPMass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Property Get Prev() As IMPMass
End Property
Public Property Set Prev(RHS As IMPMass)
End Property

Public Property Get NNext() As IMPMass
End Property
Public Property Set NNext(RHS As IMPMass)
End Property

Public Property Get Pos(Index As Long) As Double
End Property
Public Property Let Pos(Index As Long, DblVal As Double)
End Property

Public Sub Move(dt As Double)  ' // Teilchen bewegen (neue Position annehmen)
End Sub
Public Sub Recalc(dt As Double) ' // neue Position berechnen
End Sub

