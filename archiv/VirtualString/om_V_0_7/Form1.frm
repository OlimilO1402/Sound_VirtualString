VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows-Standard
   Begin VB.Timer Timer1 
      Left            =   2040
      Top             =   0
   End
   Begin VB.CommandButton BtnShowInput 
      Caption         =   "Show Input"
      Height          =   375
      Left            =   840
      TabIndex        =   2
      Top             =   120
      Width           =   1095
   End
   Begin VB.PictureBox PbDrawString 
      BackColor       =   &H00000040&
      ForeColor       =   &H00FF0000&
      Height          =   2535
      Left            =   120
      ScaleHeight     =   2475
      ScaleWidth      =   4395
      TabIndex        =   1
      Top             =   480
      Width           =   4455
   End
   Begin VB.CommandButton BtnPick 
      Caption         =   "Pick"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   735
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private WithEvents mString As VirtualString
Attribute mString.VB_VarHelpID = -1
Private mTimepasser As Long
Private mSoundSimuDt As Long
Private mBufferpos As Long
Private mOutscale As Long

Private Sub BtnShowInput_Click()
  Call FrmInput.Show(0, Me)
  Set FrmInput.VirtualString = mString
End Sub

Private Sub Form_Load()
  Set mString = New_VirtualString(32)
  Call mString.InitParams(0.1, 0.002, 0.00005, 0.005, 0)
  mOutscale = 1
  PbDrawString.ScaleMode = 3 'vbPixels
  PbDrawString.ForeColor = vbBlue
  PbDrawString.BackColor = &H40&       'White
End Sub
Private Sub Form_Resize()
Dim L As Single, T As Single, W As Single, H As Single
Dim brdr As Single: brdr = 8 * Screen.TwipsPerPixelX
  L = brdr: T = PbDrawString.Top
  W = Me.ScaleWidth - L - brdr
  H = Me.ScaleHeight - T - brdr
  If W > 0 And H > 0 Then Call PbDrawString.Move(L, T, W, H)
End Sub
Private Sub Form_Unload(Cancel As Integer)
  'Call KillTimer
  Timer1.Enabled = False
End Sub


Private Sub BtnPick_Click()
  'Call SetTimer(40)
  Timer1.Interval = 25
  Timer1.Enabled = True
  Call mString.Pick
End Sub

Public Sub FillNextBuffer()
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
    'Call FillBuffer(SStart, mSoundbuffersize)
    Call FillBuffer(0, EEnd)
  End If
End Sub
Private Sub FillBuffer(SStart As Long, EEnd As Long) 'Linear in den Buffer schreiben
  'fill a sound buffer from start to end asserting start<end
  Dim i As Long
  For i = SStart To EEnd - 1
    Call SimuStep
    GetReceiverSound
  Next
End Sub
Private Sub SimuStep() 'Simulationsschritt durchführen
  If (mTimepasser > mSoundSimuDt) Then
    Call mString.Simulate(1)
    mTimepasser = 0
  End If
  mTimepasser = mTimepasser + 1
End Sub
Private Function GetReceiverSound() As Long 'Amplitude am Abnehmer
  If (mString.GetReceiverPos * mOutscale > 1) Then
    Call mString.Reset
  End If
  GetReceiverSound = mString.GetReceiverPos * mOutscale * 32767
End Function

Private Sub mString_Refresh()
  Call PbDrawString_Paint
End Sub

Private Sub PbDrawString_Paint()
  Call mString.Draw(PbDrawString)
End Sub

Private Sub Timer1_Timer()
    Call FillNextBuffer
    Call PbDrawString.Refresh
End Sub
