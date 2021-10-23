VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6135
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   11070
   LinkTopic       =   "Form1"
   ScaleHeight     =   6135
   ScaleWidth      =   11070
   StartUpPosition =   3  'Windows-Standard
   Begin VB.CommandButton BtnSaveWave 
      Caption         =   "*.wav speichern"
      Height          =   375
      Left            =   7320
      TabIndex        =   10
      Top             =   600
      Width           =   1695
   End
   Begin VB.CommandButton BtnSine 
      Caption         =   "Sinus"
      Height          =   375
      Left            =   6120
      TabIndex        =   8
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton BtnTriangular 
      Caption         =   "Dreieck"
      Height          =   375
      Left            =   4920
      TabIndex        =   7
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton BtnReset 
      Caption         =   "Reset"
      Height          =   375
      Left            =   3720
      TabIndex        =   9
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton BtnPick 
      Caption         =   "Pick"
      Height          =   375
      Left            =   2520
      TabIndex        =   6
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton BtnStop 
      Caption         =   "Stop"
      Height          =   375
      Left            =   1320
      TabIndex        =   12
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton BtnInit 
      Caption         =   "Init"
      Height          =   375
      Left            =   120
      TabIndex        =   11
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton BtnExciterSetPosition 
      Caption         =   "Exciter Position"
      Height          =   375
      Left            =   7320
      TabIndex        =   5
      Top             =   120
      Width           =   1695
   End
   Begin VB.PictureBox PbDrawString 
      BackColor       =   &H00FFFFFF&
      Height          =   4935
      Left            =   120
      ScaleHeight     =   325
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   605
      TabIndex        =   4
      Top             =   1080
      Width           =   9135
   End
   Begin VB.CommandButton BtnReceiverSetPosition 
      Caption         =   "Receiver Position"
      Height          =   375
      Left            =   5520
      TabIndex        =   3
      Top             =   120
      Width           =   1815
   End
   Begin VB.CommandButton BtnSteiferStab 
      Caption         =   "Steifer Stab"
      Height          =   375
      Left            =   3720
      TabIndex        =   1
      Top             =   120
      Width           =   1815
   End
   Begin VB.CommandButton BtnBiegsameSaite 
      Caption         =   "Biegsame Saite"
      Height          =   375
      Left            =   1920
      TabIndex        =   0
      Top             =   120
      Width           =   1815
   End
   Begin VB.CommandButton BtnPresetHomogString 
      Caption         =   "Homogen String"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   1815
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mTimepasser  As Double
Private mOutscale    As Double 'Skalierungsfaktor für Amplitude "Lautstärke"
Private mReceiverdim As Long 'Dimension des Tonabnehmers (1 für String, 2 für Plate)
Private mReceiverPos As Long 'Position (=Index) des Tonabnehmers
Private mSoundbuffersize As Long '* Für DirectSound
Private mBufferpos As Long '*
Private mSound As DIRSOUND
Private mSoundSimuDt As Double
Private mReceiver    As MPMassKurz 'Pointer auf das Masseteilchen, an dem der Ton abgenommen wird
Private mString      As MPString 'Das String/Plate Objekt


Private Sub Form_Load()
  Set mString = New MPString
  Call mString.CreateString(32)
  
  Call OnParameterBiegsameSaite
  mReceiverPos = 15
  Set mReceiver = mString.GetAt(mReceiverPos)
  mReceiverdim = 1
  mOutscale = 1
End Sub
Private Sub BtnInit_Click()
  Call InitSound
  Call SetTimer(40)
  'Call Form1.FillNextBuffer
  'Call Form1.PbDrawString.Refresh
  'Call mString.Pick

End Sub
Private Sub BtnStop_Click()
  Call KillTimer
End Sub
Private Sub BtnReset_Click()
  Call mString.Reset
End Sub
Private Sub BtnPresetHomogString_Click()
  Call OnPresetHomogenousString
End Sub
Private Sub BtnBiegsameSaite_Click()
  Call OnParameterBiegsameSaite
End Sub
Private Sub BtnSteiferStab_Click()
  Call OnParameterSteiferStab
End Sub
Private Sub BtnReceiverSetPosition_Click()
  Call OnReceiverSetPosition
End Sub
Private Sub BtnExciterSetPosition_Click()
  Call OnExciterSetposition
End Sub
Private Sub BtnPick_Click()
  Call mString.Pick
End Sub
Private Sub BtnTriangular_Click()
  Call mString.Triangular(0.25)
End Sub
Private Sub BtnSine_Click()
  Call mString.Sine(2)
End Sub
Private Sub BtnSaveWave_Click()
  'simulate to disk
  'CFileDialog d(false);
  'd.DoModal();
  'CFile f;
  Dim FNm As String, FNr As Integer: FNr = FreeFile
  FNm = InputBox("Geben Sie einen Dateinamen an: ")
  If Len(FNm) Then
    Open FNm For Binary Access Write As FNr
    Dim i As Long, b As Integer
    For i = 0 To 100000 - 1
      Call mString.Simulate(1)
      b = GetReceiverSound
      Put FNr, , b
    Next
    Close FNr
  End If
  'f.Open(d.GetPathName(), CFile::modeWrite | CFile::modeCreate);
  'for ( long l=0; l<100000; l++)
  '{
  '  m_string->Simulate(1);
  '  int b=GetReceiverSound();
  '  f.Write(&b,2);
  '}
  'f.Close();
End Sub


Private Sub OnParameterSteiferStab()
  mString.Reset
  mString.DampingC1 = 0.00005
  mString.DampingC2 = 0.005
  mString.DampingC3 = 0
  mString.Tension = 0.1
  mString.Dispersion = 0.22
  UpdateBParameters
End Sub
Private Sub OnParameterBiegsameSaite()
  mString.Reset
  mString.DampingC1 = 0.00005
  mString.DampingC2 = 0.005
  mString.DampingC3 = 0
  mString.Tension = 0.1
  mString.Dispersion = 0
  UpdateBParameters
End Sub
Private Sub OnPresetHomogenousString()
  Set mString = New MPString
  Call mString.CreateString(32)
  mReceiver = mString.GetAt(mReceiverPos)
  mReceiverdim = 1
  mOutscale = 1
End Sub
Private Sub OnPresetPlate()
  Set mString = New MPString
  Call mString.CreateRectPlate(6, 6)
  mReceiver = mString.GetAt(mReceiverPos)
  mReceiverdim = 2
  mOutscale = 1
End Sub

Private Sub UpdateBParameters() 'B0-B6 Parameter neu berechnen

  Dim aT As Double: aT = mString.Tension
  Dim aEI As Double: aEI = mString.Dispersion
  Dim aC0 As Double: aC0 = mString.DampingC1
  Dim aC1 As Double: aC1 = mString.DampingC2
  Dim aC2 As Double: aC2 = mString.DampingC3

  mString.B0 = 2 - 2 * aT - 6 * aEI - aC0 - 2 * aC1 - 6 * aC2
  mString.B1 = aT + 4 * aEI + aC1 + 4 * aC2
  mString.B2 = -aEI - aC2
  mString.B3 = -1 + aC0 + 2 * aC1 + 6 * aC2
  mString.B4 = -aC1 - 4 * aC2
  mString.B5 = aC2
  mString.B6 = 0

End Sub

Private Sub SimuStep() 'Simulationsschritt durchführen
  If (mTimepasser > mSoundSimuDt) Then
    Call mString.Simulate(1)
    mTimepasser = 0
  End If
  mTimepasser = mTimepasser + 1
End Sub
Private Sub OnReceiverSetPosition()
Dim r As Long: r = InputBoxPosition(mReceiverPos, "Receivers")
  If r > -1 Then mReceiverPos = r
  Set mReceiver = mString.GetAt(mReceiverPos)
End Sub
Private Sub OnExciterSetposition()
Dim e As Long: e = InputBoxPosition(mString.Exciterposition, "Exciters")
  If e > -1 Then mString.Exciterposition = e
End Sub
Private Function InputBoxPosition(p As Long, StrVal As String) As Long
  Dim Pos As Long, StrPos As String
  InputBoxPosition = -1
  StrPos = InputBox("Geben Sie die Position des " & StrVal & " ein:", , CStr(mReceiverPos))
  If Len(StrPos) Then
    If IsNumeric(StrPos) Then
      Pos = CLng(StrPos)
    'jetzt noch Grenzen überprüfen
      If 0 <= Pos And Pos < mString.Masses.Count Then
        InputBoxPosition = Pos
      End If
    End If
  End If
End Function

Private Function GetReceiverSound() As Long 'Amplitude am Abnehmer
  If (mReceiver.Pos(mReceiverdim) * mOutscale > 1) Then
    Call mString.Reset
  End If
  GetReceiverSound = mReceiver.Pos(mReceiverdim) * mOutscale * 32767
End Function
Private Sub InitSound() 'Initialisieren von DirectSound
'  If (mSound) Then Exit Sub
'  mSoundbuffersize = 2000
'  mSound = New DIRSOUND 'AfxGetApp()->m_pMainWnd->m_hWnd);
'  mSound.sound(0) = malloc(mSoundbuffersize * LenB(mSoundbuffersize)) '(BYTE*)
'  mSound.Len(0) = mSoundbuffersize * LenB(mSoundbuffersize)
'  Call mSound.CreateBuffer(0)
'  Call mSound.FillBuffer(0)
'  Call mSound.start(0, True)
'  mBufferpos = 0

End Sub
Public Sub FillNextBuffer() 'DirectSound Buffer auffüllen
  Dim playcursor As Long: playcursor = 1000
  'Call mSound.GetCurrentPosition(playcursor, 0&)
  'playcursor = playcursor / 2
  Call FillBufferCircular(mBufferpos, playcursor)
  'mBufferpos = playcursor
End Sub
Private Sub FillBufferCircular(SStart As Long, EEnd As Long) 'Zirkulär in den Buffer schreiben
  If (SStart < EEnd) Then
    Call FillBuffer(SStart, EEnd)
  ElseIf (SStart > EEnd) Then
    Call FillBuffer(SStart, mSoundbuffersize)
    Call FillBuffer(0, EEnd)
  End If
End Sub
Private Sub FillBuffer(SStart As Long, EEnd As Long) 'Linear in den Buffer schreiben
  'fill a sound buffer from start to end asserting start<end
  Dim write1 As Long
  Dim length1 As Long
  Dim write2 As Long
  Dim length2 As Long
  Dim playcursor As Long, writecursor As Long
  Dim hr As Long
  'we lock the buffer and receive the write cursor from here on we can start writing the new data
  'hr = mSound.BufferLock(0, mSound.Length, write1, length1, write2, length2, 0)
  '// we lost the buffer...
  'If (hr = DSERR_BUFFERLOST) Then
    'Call mSound.BufferRestore
    'hr = mSound.BufferLock(0, mSound.Length, write1, length1, write2, length2, 0)
  'End If
  
  length1 = length1 / 2
  length2 = length2 / 2

  Dim i As Long
  If (SStart < length1) Then
    If (EEnd <= length1) Then
      For i = SStart To EEnd - 1
        Call SimuStep
        'clng(write1)(i)=GetReceiverSound()
        GetReceiverSound
      Next
    Else
      For i = SStart To length1 - 1
        Call SimuStep
        '((WORD*)write1)[i]=GetReceiverSound
        GetReceiverSound
      Next
      For i = 0 To EEnd - 1
        Call SimuStep
        '((WORD*)write2)[i]=GetReceiverSound();
        GetReceiverSound
      Next
    End If
  Else
    For i = SStart - length1 To EEnd - length1 - 1
      Call SimuStep
      'clng(write2)(i)=GetReceiverSound
      GetReceiverSound
    Next
  End If

  'hr = mSound.BufferUnlock(write1, length1, write2, length2)

  'If (hr <> DS_OK) Then
  '  Exit Sub '(-1)
  'End If
End Sub

Private Sub OnDraw(aPB As PictureBox)
  '  CMassSpringDoc* pDoc = GetDocument();
  'ASSERT_VALID(pDoc);
  '// ZU ERLEDIGEN: Hier Code zum Zeichnen der ursprünglichen Daten hinzufügen

  Dim yscale As Double: yscale = 0.5
  Dim x As Long, y As Long
  
  For y = 0 To mString.Ny - 1
    For x = 0 To mString.Nx - 1
      With mString.GetAt(x) ', y)
        aPB.Line (100 + .Pos(0) * 650 - .Pos(2) * 30, _
                  100 + .Pos(1) * yscale * 450 - .Pos(2) * 30)- _
                 (120 + .Pos(0) * 650 + .Pos(2) * 30, _
                  120 + .Pos(1) * yscale * 450 + .Pos(2) * 30), , B
'      With mString.GetAt2D(x, y)
'        aPB.Line (100 + .Pos(0) * 650 - .Pos(2) * 30, _
'                  100 + .Pos(1) * yscale * 450 - .Pos(2) * 30)- _
'                 (120 + .Pos(0) * 650 + .Pos(2) * 30, _
'                  120 + .Pos(1) * yscale * 450 + .Pos(2) * 30), , B
      End With
    Next
  Next
End Sub

Private Sub Form_Paint()
  PbDrawString.Refresh
End Sub

Private Sub Form_Resize()
Dim L As Single, T As Single, W As Single, H As Single
Dim brdr As Single: brdr = 8 * 15
  L = brdr: T = PbDrawString.Top
  W = Me.ScaleWidth - L - brdr
  H = Me.ScaleHeight - T - brdr
  If W > 0 And H > 0 Then Call PbDrawString.Move(L, T, W, H)
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Call KillTimer
End Sub

Private Sub PbDrawString_Paint()
  Call OnDraw(PbDrawString)
End Sub
