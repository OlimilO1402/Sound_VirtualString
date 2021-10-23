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
Private mDispersion As Double 'Ausbreitungsgeschw.
Private mDampingC1  As Double 'Dämpferkonstante1
Private mDampingC2  As Double 'Dämpferkonstante2
Private mDampingC3  As Double 'Dämpferkonstante3
Private mTension    As Double 'Zugkraft
Private mMass       As Double 'Einzelmasse
Private mB0 As Double 'Diese Modellparameter berechnen sich aus den
Private mB1 As Double 'physikalischen Parametern
Private mB2 As Double '(s. InitParams() )
Private mB3 As Double 'nur um Berechnungszeit zu sparen. Diese werden nur
Private mB4 As Double 'bei Änderung eines Parameters neu berechnet.
Private mB5 As Double '
'Exciter 'Erreger
Private mExciterIx    As Long   'Anschlagposition
Private mExciterForce As Double 'Anschlagstärke
'Receiver 'Abnehmer (Tonabnehmer, PickUp)
Private mReceiverIx   As Long   'Abnehmerposition
Private mNx As Long 'Anzahl Masseteilchen in X-Richtung
Private Type TMass
    PosX    As Double '8 'Nur ein Index, könnte auch Long sein
    PosY    As Double '8 'aktuelle Position des Masseteilchens (t=t)
    PosYOld As Double '8 'Zwischenspeicher für die alte Position (t=t-dt)
    PosYNew As Double '8 'Zwischenspeicher für die neue Position (t=t+dt)
End Type     'Sum:  32
Private mMassArr() As TMass
Private mFrequency As Double
Private mSmplFrequ As Double
Private mStep      As Double 'Long
Private mOldRecVal As Double
Public Event Refresh()

Public Enum PickShape
    PSHammer = 1
    PSTriangle = 2
    PSHammerTriangle = 3
End Enum

Private mPickShape As PickShape

Private Sub Class_Initialize()
    mMass = 1
    Call InitParams(1, 0, 0.0001, 0.0001, 0.0001)
    mExciterIx = 3:  mExciterForce = 0.5
    mReceiverIx = 15
End Sub

Public Sub NewC(ByVal nCount As Long)
    Call SetLength(nCount)
    SetPosXIndex
End Sub
Public Sub NewCp(other As VirtualString)
    mDampingC1 = other.DampingC1
    mDampingC2 = other.DampingC2
    mDampingC3 = other.DampingC3
    mDispersion = other.Dispersion
    mTension = other.Tension
    mExciterIx = other.ExciterIx
    mFrequency = other.Frequency
    Me.Length = other.Length
    mPickShape = other.PickShape
    mReceiverIx = other.ReceiverIx
    mSmplFrequ = other.SampleFrequency
    'mMass = other.SingleMass
End Sub
Public Sub Reset()
    Call SetLength(mNx)
    mFrequency = 0
    mStep = 0
    mOldRecVal = 0
End Sub

Public Property Get Length() As Long
    Length = mNx
End Property
Public Property Let Length(ByVal value As Long)
    If value <> mNx Then Call SetLength(value, True)
End Property

Public Sub SetLength(ByVal nCount As Long, Optional BolPreserve As Boolean)
    If nCount < 5 Then nCount = 5
    mNx = nCount
    If BolPreserve Then
        ReDim Preserve mMassArr(0 To mNx - 1)
        mMassArr(mNx - 1).PosY = 0
        mMassArr(mNx - 1).PosYNew = 0
        mMassArr(mNx - 1).PosYOld = 0
    Else
        ReDim mMassArr(0 To mNx - 1)
    End If
    Call SetPosXIndex
    If mExciterIx > nCount - 1 Then mExciterIx = nCount \ 2
    If mReceiverIx > nCount - 1 Then mReceiverIx = nCount \ 2
    RaiseEvent Refresh
End Sub
Private Sub SetPosXIndex()
    Dim i As Long
    For i = 0 To mNx - 1
        mMassArr(i).PosX = CDbl(i) / CDbl(mNx)
    Next
End Sub
Public Sub InitParams(ByVal aT As Double, _
                      ByVal aEI As Double, _
                      ByVal aC1 As Double, _
                      ByVal aC2 As Double, _
                      ByVal aC3 As Double)
    mTension = aT
    mDispersion = aEI
    mDampingC1 = aC1
    mDampingC2 = aC2
    mDampingC3 = aC3
    CalcParams
End Sub
Private Sub CalcParams()
    mB0 = 2 - 2 * mTension - 6 * mDispersion - mDampingC1 - 2 * mDampingC2 - 6 * mDampingC3
    mB1 = mTension + 4 * mDispersion + mDampingC2 + 4 * mDampingC3
    mB2 = -mDispersion - mDampingC3
    mB3 = -1 + mDampingC1 + 2 * mDampingC2 + 6 * mDampingC3
    mB4 = -mDampingC2 - 4 * mDampingC3
    mB5 = mDampingC3
End Sub

'##############################' vv Public Properties vv '##############################'
Public Property Get Dispersion() As Double 'Steifigkeit der Saite
    Dispersion = mDispersion
End Property
Public Property Let Dispersion(value As Double)
    mDispersion = value
    CalcParams
End Property

Public Property Get DampingC1() As Double  'Dämpferkonstante1
    DampingC1 = mDampingC1
End Property
Public Property Let DampingC1(value As Double)
    mDampingC1 = value
    CalcParams
End Property

Public Property Get DampingC2() As Double  'Dämpferkonstante2
    DampingC2 = mDampingC2
End Property
Public Property Let DampingC2(value As Double)
    mDampingC2 = value
    CalcParams
End Property

Public Property Get DampingC3() As Double  'Dämpferkonstante3
    DampingC3 = mDampingC3
End Property
Public Property Let DampingC3(value As Double)
    mDampingC3 = value
    CalcParams
End Property

Public Property Get Tension() As Double    'Zugkraft in der Saite
    Tension = mTension
End Property
Public Property Let Tension(value As Double)
    mTension = value
    CalcParams
End Property

Public Property Get SingleMass() As Double 'Einzelmasse
    SingleMass = mMass
End Property
Public Property Let SingleMass(ByVal value As Double)
    mMass = value
End Property

Public Property Get ExciterIx() As Long   'Anschlagposition
    ExciterIx = mExciterIx
End Property
Public Property Let ExciterIx(value As Long)
    If CheckBounds(value) Then
        mExciterIx = value
        RaiseEvent Refresh
    End If
End Property
Public Property Get ReceiverIx() As Long  'Abnehmerposition
    ReceiverIx = mReceiverIx
End Property
Public Property Let ReceiverIx(value As Long)
    If CheckBounds(value) Then
        mReceiverIx = value
        RaiseEvent Refresh
    End If
End Property

Public Property Get PickShape() As PickShape
    PickShape = mPickShape
End Property
Public Property Let PickShape(ByVal value As PickShape)
    mPickShape = value
End Property

Public Property Get SampleFrequency() As Double
    SampleFrequency = mSmplFrequ
End Property

Public Property Let SampleFrequency(ByVal value As Double)
    mSmplFrequ = value
End Property

'##############################' ^^ Public Properties ^^ '##############################'

Private Function CheckBounds(ByVal value As Double) As Boolean
    CheckBounds = (1 <= value) And (value < UBound(mMassArr))
End Function
'Private mExciterForce As Double 'Anschlagstärke
Public Function GetReceiverPos() As Double
    Dim p As Long:  p = UBound(mMassArr)
    If p >= mReceiverIx Then
        GetReceiverPos = mMassArr(mReceiverIx).PosY
    Else
        GetReceiverPos = mMassArr(p / 2).PosY
    End If
End Function
'Private mExciterForce As Double 'Anschlagstärke
Public Function GetReceiverPos2() As Double
    Dim p As Long:  p = UBound(mMassArr)
    If p >= mReceiverIx Then
        GetReceiverPos2 = mMassArr(p - mReceiverIx).PosY
    Else
        GetReceiverPos2 = mMassArr(p / 2).PosY
    End If
End Function

Public Sub Pick()
    If (mPickShape And PSTriangle) Then
        PickTriangle
    End If
    If (mPickShape And PSHammer) Then
        PickHammer
    End If
End Sub
Private Sub PickHammer()
    'eine aufgezwungene Verformung
    'Ein einzelnes Element anregen
    With mMassArr(mExciterIx)
        .PosY = .PosY + mExciterForce * 0.5 * IIf(.PosY = 0, 1, Sgn(.PosY))
    End With
End Sub
Private Sub PickTriangle()
    'eine aufgezwungene Verformung
    'die Verformung auf alle Elemente
    'unter Annahme eines dreieckförmigen Verlaufs
    'real wäre Biegelinie bei Einzellast an mExciterIx
    Dim i As Long, n As Long
    Dim yMax As Double
    'mExciterForce = -mExciterForce
    yMax = mMassArr(mExciterIx).PosY + mExciterForce * 0.05
    mMassArr(mExciterIx).PosY = yMax
    n = mExciterIx - 1
    For i = 0 To n
        With mMassArr(i)
            .PosY = yMax * i / mExciterIx
        End With
    Next
    n = (UBound(mMassArr)) ' / 2)
    For i = mExciterIx + 1 To n
        With mMassArr(i)
            .PosY = yMax - yMax * ((i - mExciterIx) / (n - mExciterIx))
        End With
    Next
    For i = n To UBound(mMassArr)
        With mMassArr(i)
            .PosY = 0 'yMax - yMax * ((i - mExciterIx) / (UBound(mMassArr) - mExciterIx))
        End With
    Next
End Sub
'Public Sub PickHammerAndTriangle()
'    Me.PickTriangle
'    Me.PickHammer
'End Sub
Public Sub Recalc()
    Dim i As Long, n As Long: n = UBound(mMassArr)
    On Error Resume Next
    i = 1
    mMassArr(i).PosYNew = _
             mB0 * (mMassArr(i).PosY) + _
             mB1 * (mMassArr(i - 1).PosY + mMassArr(i + 1).PosY) + _
             mB2 * (mMassArr(i + 2).PosY) + _
             mB3 * (mMassArr(i).PosYOld) + _
             mB4 * (mMassArr(i - 1).PosYOld + mMassArr(i + 1).PosYOld) + _
             mB5 * (mMassArr(i + 2).PosYOld)
    For i = 2 To n - 2
        mMassArr(i).PosYNew = _
               mB0 * (mMassArr(i).PosY) + _
               mB1 * (mMassArr(i - 1).PosY + mMassArr(i + 1).PosY) + _
               mB2 * (mMassArr(i - 2).PosY + mMassArr(i + 2).PosY) + _
               mB3 * (mMassArr(i).PosYOld) + _
               mB4 * (mMassArr(i - 1).PosYOld + mMassArr(i + 1).PosYOld) + _
               mB5 * (mMassArr(i - 2).PosYOld + mMassArr(i + 2).PosYOld)
    Next
    i = n - 1
    mMassArr(i).PosYNew = _
             mB0 * (mMassArr(i).PosY) + _
             mB1 * (mMassArr(i - 1).PosY + mMassArr(i + 1).PosY) + _
             mB2 * (mMassArr(i - 2).PosY) + _
             mB3 * (mMassArr(i).PosYOld) + _
             mB4 * (mMassArr(i - 1).PosYOld + mMassArr(i + 1).PosYOld) + _
             mB5 * (mMassArr(i - 2).PosYOld)
End Sub
Public Sub Move()  ' // Teilchen bewegen (neue Position annehmen)
    Dim i As Long
    For i = 0 To UBound(mMassArr)
        With mMassArr(i)
            .PosYOld = .PosY
            .PosY = .PosYNew
        End With
    Next
End Sub
Public Sub Simulate()  'Simulationsschritt ausführen
    Call Recalc
    Call Move
    Call CalcFrequency
End Sub

'Private Function IsThroughNulldown() As Boolean
'    'returns true if receiver does a zero breakthrough from top down
'    'liefert ob ein Nulldurchgang des Receivers von oben nach unten erfolgte
'End Function
Private Sub CalcFrequency()
    Dim r As Double: r = Me.GetReceiverPos
    'Dim IsThroughNulldown As Boolean
    On Error Resume Next
    'Static start As Boolean
    If mOldRecVal <> r Then
        'es geht nach unten wieso eigentlich?
        'If (mOldRecVal > 0) And (0 > r) Then
        'es geht nach oben
        If (mOldRecVal < 0) And (0 < r) Then
            Dim s As Double: s = Abs(r) + Abs(mOldRecVal)
            
            Dim s1 As Double: s1 = Abs(mOldRecVal) / s
            
            mStep = mStep + s1
            'Debug.Print s1
            mFrequency = mSmplFrequ / mStep
            'Debug.Print mFrequency
            
            Dim s0 As Double: s0 = Abs(r) / s
            mStep = s0
            'Debug.Print s0
            'Debug.Print ""
        Else
            mStep = mStep + 1#
        End If
    End If
    mOldRecVal = r
End Sub
Public Property Get Frequency() As Double
    Frequency = mFrequency
End Property

Public Sub Draw(aPB As PictureBox)
    Dim d  As Double:  d = 5# 'der Durchmesser der Saite
    Dim x1 As Double: x1 = 8
    Dim y1 As Double: y1 = (aPB.ScaleHeight) \ 2 - d / 2
    Dim ys As Double: ys = 1 ' 1 '0.5
    Dim dx As Double: dx = ((aPB.ScaleWidth) - 2 * x1) / mNx
    Dim W  As Double:  W = (aPB.ScaleWidth) - 2 * x1
    Dim h  As Double:  h = y1
    aPB.Cls
    Dim i As Long
    aPB.ForeColor = vbBlue
    On Error Resume Next
    For i = 0 To mNx - 1
        With mMassArr(i)
            aPB.Line (x1 + .PosX * W, _
                      y1 + .PosY * ys * h)- _
                     (x1 + dx + .PosX * W, _
                      y1 + d + .PosY * ys * h), , B
        End With
    Next
    
    i = mExciterIx    'Anschlagposition
    With mMassArr(i)
        aPB.ForeColor = vbYellow
        aPB.Line (x1 + .PosX * W, _
                  y1 + .PosY * ys * h)- _
                 (x1 + dx + .PosX * W, _
                  y1 + d + .PosY * ys * h), , B
    End With
    i = mReceiverIx   'Abnehmerposition
    With mMassArr(i)
        aPB.ForeColor = vbRed
        aPB.Line (x1 + .PosX * W, _
                  y1 + .PosY * ys * h)- _
                 (x1 + dx + .PosX * W, _
                  y1 + d + .PosY * ys * h), , B
    End With
End Sub
Function Max(v1 As Double, v2 As Double) As Double
    If v1 > v2 Then Max = v1 Else Max = v2
End Function
Private Function GetMaxReceiver() As Double
    Dim i As Long
    'Call Me.PickHammer
    'Call Me.PickTriangle
    Call Me.Pick
    For i = 0 To mSmplFrequ - 1
        Simulate
        GetMaxReceiver = Max(GetMaxReceiver, Abs(GetReceiverPos))
    Next
    Call Me.Reset
End Function

Public Sub WriteToWaveFile(aFileName As String, ByVal secs As Long)
    Dim scfact As Double: scfact = 32767 / GetMaxReceiver
    'Debug.Print scfact
    Dim FNr As Integer: FNr = FreeFile
Try: On Error GoTo Catch
    Open aFileName For Binary As FNr
    Dim n As Long: n = CLng(mSmplFrequ * secs) - 1
    Dim lh As Long, ih As Integer
    Dim bps As Integer: bps = 16
    Dim chn As Integer: chn = 2
    Dim ba As Integer:  ba = chn * bps / 8
    lh = &H46464952:      Put FNr, , lh '"RIFF"
    lh = n * 2 + 36:      Put FNr, , lh 'filelength-4 in bytes
    lh = &H45564157:      Put FNr, , lh '"WAVE"
    lh = &H20746D66:      Put FNr, , lh '"fmt "
    lh = 16:              Put FNr, , lh 'length of WAVE-format in bytes
    ih = 1:               Put FNr, , ih 'FormatTag = 1 PCM
    ih = chn:             Put FNr, , ih 'nChannels = 1 mono
    lh = mSmplFrequ:      Put FNr, , lh 'SPS = 44.1 kHz Samples Per Second
    lh = mSmplFrequ * ba: Put FNr, , lh 'AvgByPS = SPS * nchannels * bitspersample / 8
    ih = ba:              Put FNr, , ih 'BlockAlign = nChannels * bitspersample / 8
    ih = bps:             Put FNr, , ih 'BitsPerSample = 16
    'ih = 0:              Put FNr, , ih '2 padbytes
    lh = &H61746164:      Put FNr, , lh '"data"
    lh = n * 2 * chn:     Put FNr, , lh 'datalength in bytes
    Dim i As Long, y As Integer
    'Call Me.PickHammer
    'Call Me.PickTriangle
    Call Me.Pick
    For i = 0 To n
        'If i = 1000 Then Me.PickHammer
        y = scfact * GetReceiverPos
        Put FNr, , y
        y = scfact * GetReceiverPos2
        Put FNr, , y
        Simulate
    Next
    Call Me.Reset
    'Exit Sub
Catch:
    Close FNr
End Sub
