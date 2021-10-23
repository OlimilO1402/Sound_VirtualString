VERSION 5.00
Begin VB.Form FrmMain 
   Caption         =   "VirtualString"
   ClientHeight    =   3975
   ClientLeft      =   225
   ClientTop       =   525
   ClientWidth     =   15510
   Icon            =   "FrmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3975
   ScaleWidth      =   15510
   StartUpPosition =   3  'Windows-Standard
   Begin VB.CommandButton BtnPlay 
      Caption         =   "Play"
      Height          =   360
      Left            =   12840
      TabIndex        =   13
      ToolTipText     =   "Plays the wav file once it is generated"
      Top             =   120
      Width           =   735
   End
   Begin VB.CommandButton BtnDir 
      Caption         =   "Dir"
      Height          =   360
      Left            =   12120
      TabIndex        =   12
      ToolTipText     =   "Openes the directory of the program and wav-file"
      Top             =   120
      Width           =   735
   End
   Begin VB.CommandButton BtnWave 
      Caption         =   "Wave"
      Height          =   360
      Left            =   11400
      TabIndex        =   11
      ToolTipText     =   "Saves a 4 second mono wave file 44.1kHz, mywave.wav in program directory"
      Top             =   120
      Width           =   735
   End
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   7680
      TabIndex        =   7
      Text            =   "1000"
      ToolTipText     =   "Sets the time in ms between every redraw. higher value = slower animation"
      Top             =   120
      Width           =   855
   End
   Begin VB.VScrollBar VScroll 
      Height          =   375
      Left            =   5760
      Min             =   -32767
      TabIndex        =   6
      Top             =   120
      Width           =   375
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   4920
      TabIndex        =   4
      Text            =   "1000"
      ToolTipText     =   "Sets the simulationssteps to calculate before every redraw. higher value = faster animation"
      Top             =   120
      Width           =   855
   End
   Begin VB.CommandButton BtnReset 
      Caption         =   "Reset"
      Height          =   360
      Left            =   2280
      TabIndex        =   3
      ToolTipText     =   "Reset all elements to 0"
      Top             =   120
      Width           =   1095
   End
   Begin VB.CommandButton BtnShowInput 
      Caption         =   "Parameter"
      Height          =   360
      Left            =   1200
      TabIndex        =   2
      ToolTipText     =   "Openes the parameter window"
      Top             =   120
      Width           =   1095
   End
   Begin VB.Timer Timer1 
      Left            =   1440
      Top             =   0
   End
   Begin VB.PictureBox PbDrawString 
      BackColor       =   &H00000040&
      ForeColor       =   &H00FF0000&
      Height          =   3375
      Left            =   120
      ScaleHeight     =   3315
      ScaleWidth      =   11235
      TabIndex        =   1
      Top             =   480
      Width           =   11295
   End
   Begin VB.CommandButton BtnPick 
      Caption         =   "Pick"
      Height          =   360
      Left            =   120
      TabIndex        =   0
      ToolTipText     =   "Picks the string and starts the simnulation"
      Top             =   120
      Width           =   1095
   End
   Begin VB.Label Label3 
      Caption         =   "Frequency [Hz]:"
      Height          =   255
      Left            =   9120
      TabIndex        =   10
      ToolTipText     =   "Measures the frequency"
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "Label2"
      Height          =   255
      Left            =   10320
      TabIndex        =   9
      ToolTipText     =   "Measures the frequency"
      Top             =   120
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "Animation [ms]:"
      Height          =   255
      Left            =   6360
      TabIndex        =   8
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label Label9 
      Caption         =   "Simulationsteps:"
      Height          =   255
      Left            =   3600
      TabIndex        =   5
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private WithEvents mString As VirtualString
Attribute mString.VB_VarHelpID = -1
Private mNSimulSteps As Long
Private mFileName    As String
Private Declare Function PlaySound Lib "winmm.dll" Alias "PlaySoundA" (ByVal lpszName As String, ByVal hModule As Long, ByVal dwFlags As Long) As Long

Private Sub Form_Activate()
    Me.VScroll.Visible = True
    Call SetVScroll(Me.VScroll)
    Text1_GotFocus
End Sub

Private Sub Form_Deactivate()
    Me.VScroll.Visible = False
End Sub

Private Sub Form_Load()
    mFileName = App.Path & "\mywave.wav"
    Set mString = New_VirtualString(32)
    Call mString.InitParams(0.1, 0.002, 0.00005, 0.005, 0)
    mString.PickShape = PSHammerTriangle
    mString.SampleFrequency = 41000 '96000 '48000
    Timer1.Interval = 25
    mNSimulSteps = 1
    Text1.Text = CStr(mNSimulSteps)
    Text2.Text = CStr(Timer1.Interval)
    PbDrawString.ScaleMode = vbPixels
    PbDrawString.ForeColor = vbBlue
    PbDrawString.BackColor = &H40&    'verydarkred
End Sub
Private Sub Form_Resize()
    Dim brdr As Single: brdr = 8 * Screen.TwipsPerPixelX
    Dim L As Single: L = brdr
    Dim T As Single: T = PbDrawString.Top
    Dim W As Single: W = Me.ScaleWidth - L - brdr
    Dim h As Single: h = Me.ScaleHeight - T - brdr
    If W > 0 And h > 0 Then Call PbDrawString.Move(L, T, W, h)
End Sub

Private Sub BtnPick_MouseDown(Button As Integer, Shift As Integer, X As Single, y As Single)
    Timer1.Enabled = False
    Call mString.Pick 'Hammer
    PbDrawString.Refresh
End Sub
Private Sub BtnPick_MouseUp(Button As Integer, Shift As Integer, X As Single, y As Single)
    Timer1.Enabled = True
End Sub

Private Sub BtnShowInput_Click()
    Call FrmInput.ShowModeless(Me, mString)
End Sub

Private Sub BtnReset_Click()
    mString.Reset
End Sub


Private Sub mString_Refresh()
    Call PbDrawString.Refresh
End Sub

Private Sub PbDrawString_Paint()
    Call mString.Draw(PbDrawString)
End Sub

Private Sub Timer1_Timer()
    Dim i As Long
    For i = 1 To mNSimulSteps
        Call mString.Simulate
    Next
    Call PbDrawString.Refresh
    Label2.Caption = CStr(Format(mString.Frequency, "0.0"))
End Sub

Public Property Get SimulationSteps() As Long
    SimulationSteps = mNSimulSteps
End Property
Public Property Let SimulationSteps(ByVal value As Long)
    mNSimulSteps = value
End Property
Private Sub Text1_GotFocus()
    Call SetProperty(Text1, Me, "SimulationSteps", 1, 1, 44100)
End Sub
Private Sub Text1_LostFocus()
    mNSimulSteps = CLng(Validate)
    Text1.Text = CStr(mNSimulSteps)
End Sub

Public Property Get AnimationSpeed() As Long
    AnimationSpeed = Timer1.Interval
End Property
Public Property Let AnimationSpeed(ByVal value As Long)
    Timer1.Interval = value
End Property
Private Sub Text2_GotFocus()
    Call SetProperty(Text2, Me, "AnimationSpeed", 1, 0, 1000)
End Sub

Private Sub Text2_LostFocus()
    Timer1.Interval = CLng(Validate)
    Text2.Text = CStr(Timer1.Interval)
End Sub

Private Sub VScroll_Change()
    Call Scroll_Change
End Sub

Private Sub BtnWave_Click()
    Call mString.WriteToWaveFile(mFileName, 4)
End Sub

Private Sub BtnDir_Click()
    Shell "explorer.exe" & " " & App.Path, vbNormalFocus
End Sub

Private Sub BtnPlay_Click()
    If Dir(mFileName) <> "" Then
        PlaySound mFileName, 0, 0
    End If
End Sub

'SPS:     44100
'
'Frequ:     174-175 Hz (F) (NylonString Guitar)
'Length:    100
'Tension:     0,609
'Dispersion:  0,002
'DamperC1:    0,00005
'DamperC2:    0,005
'DamperC3:    0
'ExciterIx:  16
'ReceiverIx:  6
'
'Frequ:     220 Hz (A) (SteelString-Guitar)
'Length:     32
'Tension:     0,096
'Dispersion:  0,002
'DamperC1:    0,000048
'DamperC2:    0,00016
'DamperC3:    0,0000002
'ExciterIx:  16
'ReceiverIx:  6
'
'Frequ:     261 Hz (C) (SteelString-Guitar)
'Length:     26
'Tension:     0,088
'Dispersion:  0,0026
'DamperC1:    0,000052
'DamperC2:    0,000026
'DamperC3:    0,00000026
'ExciterIx:   2
'ReceiverIx:  6

'http://www.csounds.com/jmc/Articles/Pm/PhM.html
'http://141.84.217.141/phymod
'http://www.markwhite.com/vsp/phymod.html
'http://homepages.fh-regensburg.de/~elektrogitarre/pdfs/kap1.pdf
'http://www.inventionen.de/Studio/Referate/physmodel/index.html
'https://ccrma.stanford.edu/~jos/waveguide/

