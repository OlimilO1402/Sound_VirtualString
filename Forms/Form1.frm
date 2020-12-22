VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3135
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4695
   LinkTopic       =   "Form1"
   ScaleHeight     =   3135
   ScaleWidth      =   4695
   StartUpPosition =   3  'Windows-Standard
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Left            =   1560
      Top             =   0
   End
   Begin VB.PictureBox PbDrawString 
      Height          =   2415
      Left            =   120
      ScaleHeight     =   2355
      ScaleWidth      =   4395
      TabIndex        =   1
      Top             =   600
      Width           =   4455
   End
   Begin VB.CommandButton BtnPick 
      Caption         =   "Pick"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1335
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Set mString = MNew.VirtualString(32)
    Call mString.InitParams(0.1, 0.001, 0.00005, 0.005, 0)
    mOutscale = 1
    PbDrawString.ScaleMode = 3 'vbPixels
    PbDrawString.ForeColor = vbBlue
    PbDrawString.BackColor = &H40&       'White
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
    'Call KillTimer
End Sub

Private Sub BtnPick_Click()
    'Call SetTimer(40)
    Timer1.Interval = 40
    Timer1.Enabled = Not Timer1.Enabled
    Call mString.Pick
End Sub

Private Sub PbDrawString_Paint()
    Call mString.Draw(PbDrawString)
End Sub

Private Sub Timer1_Timer()
    Call MBuffer.FillNextBuffer
    Call PbDrawString.Refresh
End Sub
