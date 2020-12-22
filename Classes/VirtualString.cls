VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VirtualString"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private mDispersion As Double 'Streuung
Private mDampingC1  As Double 'Dämpferkonstante1
Private mDampingC2  As Double 'Dämpferkonstante2
Private mDampingC3  As Double 'Dämpferkonstante3
Private mTension    As Double 'Zugkraft
Private mMass       As Double 'Einzelmasse
Private mB0 As Double 'Diese Modellparameter berechnen sich aus den
Private mB1 As Double 'physikalischen Parametern
Private mB2 As Double '
Private mB3 As Double 'nur um Berechnungszeit zu sparen. Diese werden nur
Private mB4 As Double 'bei Änderung eines Parameters neu berechnet.
Private mB5 As Double '
Private mB6 As Double '
'Exciter 'Erreger
Private mExciterDim   As Long 'Dimension (1=String 2=Plate)
Private mExciterIx    As Long   'Anschlagposition
Private mExciterForce As Double 'Anschlagstärke
'Receiver 'Abnehmer (Tonabnehmer, PickUp)
Private mReceiverDim  As Long
Private mReceiverIx   As Long

Private mNx As Long 'Anzahl Masseteilchen in X-Richtung

Private Type TMass
    Force(0 To 2)  As Double '24
    Pos(0 To 2)    As Double '24 'aktuelle Position des Teilchens
    PosOld(0 To 2) As Double '24 'Zwischenspeicher für die alte Position (t=T-1)
    PosNew(0 To 2) As Double '24 'Zwischenspeicher für die neue Position (t=T+1)
End Type             'Sum:  96
Private mMassArr() As TMass

Private Sub Class_Initialize()
    mMass = 1
    Call InitParams(1, 0, 0.0001, 0.0001, 0.0001)
    mExciterDim = 1:  mExciterIx = 3:  mExciterForce = 0.5
    mReceiverDim = 1: mReceiverIx = 15
End Sub

Public Sub NewC(nCount As Long)
    Call SetLength(nCount)
End Sub
Public Sub Reset()
    Call SetLength(mNx)
End Sub
Public Sub SetLength(nCount As Long)
    mNx = nCount
    ReDim mMassArr(0 To mNx - 1)
    Dim i As Long
    For i = 0 To mNx - 1
        mMassArr(i).Pos(0) = CDbl(i) / CDbl(mNx)
    Next
End Sub
Public Sub InitParams(aT As Double, aEI As Double, aC0 As Double, aC1 As Double, aC2 As Double)
    'B0-B6 Parameter neu berechnen
    mDispersion = aEI
    mDampingC1 = aC0
    mDampingC2 = aC1
    mDampingC3 = aC2
    mTension = aT
    
    mB0 = 2 - 2 * aT - 6 * aEI - aC0 - 2 * aC1 - 6 * aC2
    mB1 = aT + 4 * aEI + aC1 + 4 * aC2
    mB2 = -aEI - aC2
    mB3 = -1 + aC0 + 2 * aC1 + 6 * aC2
    mB4 = -aC1 - 4 * aC2
    mB5 = aC2
    mB6 = 0 '???
End Sub
Public Sub Pick() 'Ein einzelnes Element anregen
    With mMassArr(mExciterIx)
        .Pos(mExciterDim) = .Pos(mExciterDim) + mExciterForce * 0.5
    End With
End Sub
Public Function GetReceiverPos() As Double
    GetReceiverPos = mMassArr(mReceiverIx).Pos(mReceiverDim)
End Function
Public Sub Move()  'Teilchen bewegen (neue Position annehmen)
    Dim i As Long
    For i = 0 To UBound(mMassArr)
        With mMassArr(i)
            .PosOld(1) = .Pos(1)
            .Pos(1) = .PosNew(1)
        End With
    Next
End Sub
Public Sub Simulate(dt As Double)  'Simulationsschritt ausführen
    Call Recalc
    Call Move
End Sub

Public Sub Recalc()
    Dim i As Long, n As Long: n = UBound(mMassArr)
    i = 1
    mMassArr(i).PosNew(1) = _
             mB0 * (mMassArr(i).Pos(1)) + _
             mB1 * (mMassArr(i - 1).Pos(1) + mMassArr(i + 1).Pos(1)) + _
             mB2 * (mMassArr(i + 2).Pos(1)) + _
             mB3 * (mMassArr(i).PosOld(1)) + _
             mB4 * (mMassArr(i - 1).PosOld(1) + mMassArr(i + 1).PosOld(1)) + _
             mB5 * (mMassArr(i + 2).PosOld(1)) + _
             mB6 * (mMassArr(i).Force(1))
    For i = 2 To n - 2
      'With mMassArr(i)
        mMassArr(i).PosNew(1) = _
               mB0 * (mMassArr(i).Pos(1)) + _
               mB1 * (mMassArr(i - 1).Pos(1) + mMassArr(i + 1).Pos(1)) + _
               mB2 * (mMassArr(i - 2).Pos(1) + mMassArr(i + 2).Pos(1)) + _
               mB3 * (mMassArr(i).PosOld(1)) + _
               mB4 * (mMassArr(i - 1).PosOld(1) + mMassArr(i + 1).PosOld(1)) + _
               mB5 * (mMassArr(i - 2).PosOld(1) + mMassArr(i + 2).PosOld(1)) + _
               mB6 * (mMassArr(i).Force(1))
      'End With
    Next
    i = n - 1
    mMassArr(i).PosNew(1) = _
             mB0 * (mMassArr(i).Pos(1)) + _
             mB1 * (mMassArr(i - 1).Pos(1) + mMassArr(i + 1).Pos(1)) + _
             mB2 * (mMassArr(i - 2).Pos(1)) + _
             mB3 * (mMassArr(i).PosOld(1)) + _
             mB4 * (mMassArr(i - 1).PosOld(1) + mMassArr(i + 1).PosOld(1)) + _
             mB5 * (mMassArr(i - 2).PosOld(1)) + _
             mB6 * (mMassArr(i).Force(1))
End Sub
Public Sub Draw(aPB As PictureBox)
    Dim i As Long
    'Dim x As Long, y As Long
    Dim d As Double: d = 5 'der Durchmesser der Saite
    Dim x1 As Double: x1 = 8
    Dim y1 As Double: y1 = (aPB.ScaleHeight / 1) \ 2 - d / 2
    Dim yscale As Double: yscale = 2 ' 1 '0.5
    Dim dx As Double: dx = ((aPB.ScaleWidth / 1) - 2 * x1) / mNx
    Dim W As Double: W = (aPB.ScaleWidth / 1) - 2 * x1
    Dim H As Double: H = y1
    aPB.Cls
    For i = 0 To mNx - 1
        With mMassArr(i)
            aPB.Line (x1 + .Pos(0) * W - .Pos(2) * dx, _
                      y1 + .Pos(1) * yscale * H - .Pos(2) * d)- _
                     (x1 + dx + .Pos(0) * W + .Pos(2) * dx, _
                      y1 + d + .Pos(1) * yscale * H + .Pos(2) * d), , B
        End With
    Next
End Sub

