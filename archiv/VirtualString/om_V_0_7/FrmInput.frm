VERSION 5.00
Begin VB.Form FrmInput 
   Caption         =   "InputParams"
   ClientHeight    =   2970
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   3780
   LinkTopic       =   "Form2"
   ScaleHeight     =   2970
   ScaleWidth      =   3780
   StartUpPosition =   3  'Windows-Standard
   Begin VB.VScrollBar VScroll 
      Height          =   255
      Left            =   3240
      Min             =   -32768
      TabIndex        =   6
      Top             =   120
      Width           =   375
   End
   Begin VB.TextBox Text6 
      Height          =   285
      Left            =   1680
      TabIndex        =   5
      Text            =   "Text6"
      Top             =   1920
      Width           =   1575
   End
   Begin VB.TextBox Text5 
      Height          =   285
      Left            =   1680
      TabIndex        =   4
      Text            =   "Text5"
      Top             =   1560
      Width           =   1575
   End
   Begin VB.TextBox Text4 
      Height          =   285
      Left            =   1680
      TabIndex        =   3
      Text            =   "Text4"
      Top             =   1200
      Width           =   1575
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Left            =   1680
      TabIndex        =   2
      Text            =   "Text3"
      Top             =   840
      Width           =   1575
   End
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   1680
      TabIndex        =   1
      Text            =   "Text2"
      Top             =   480
      Width           =   1575
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   1680
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   120
      Width           =   1575
   End
   Begin VB.Label Label2 
      Caption         =   "Label2"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   480
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "Anzahl Elemente"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   1455
   End
End
Attribute VB_Name = "FrmInput"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mCurTB As TextBox
Private mOldVal As Double
Private mVS As VirtualString

Private Sub Form_Load()
  Set mCurTB = Text1
End Sub

Public Property Set VirtualString(aVS As VirtualString)
  Set mVS = aVS
  Text1.Text = CStr(mVS.Length)
  Text2.Text = CStr(mVS.Dispersion)
  Text3.Text = CStr(mVS.Tension)
  Text4.Text = CStr(mVS.DampingC1)
  Text5.Text = CStr(mVS.DampingC2)
  Text6.Text = CStr(mVS.DampingC3)
End Property

Private Sub Text1_Change()
  Call mVS.SetLength(CDbl(Text1.Text))
End Sub

Private Sub Text1_Click()
  Call SetCurTB(Text1)
End Sub
Private Sub Text2_Click()
  Call SetCurTB(Text2)
End Sub
Private Sub Text3_Click()
  Call SetCurTB(Text3)
End Sub
Private Sub Text4_Click()
  Call SetCurTB(Text4)
End Sub
Private Sub Text5_Click()
  Call SetCurTB(Text5)
End Sub
Private Sub Text6_Click()
  Call SetCurTB(Text6)
End Sub
Private Sub SetCurTB(aTB As TextBox)
Dim L As Single, T As Single, W As Single, H As Single
  Set mCurTB = aTB
  L = mCurTB.Left + mCurTB.Width
  T = mCurTB.Top: W = VScroll.Width: H = VScroll.Height
  If W > 0 And H > 0 Then Call VScroll.Move(L, T) ', W, H)
End Sub

Private Sub VScroll_Change()
  Dim s As String: s = mCurTB.Text
  Dim v As Double
  If IsNumeric(s) Then
    v = CDbl(s)
    If IsUpScroll(VScroll) Then
      v = v - 1
    Else
      v = v + 1
    End If
    mCurTB.Text = CStr(v)
  End If
End Sub
Private Sub UpdateVirtualStringParams()
  Call mVS.InitParams(CDbl(Text2.Text), _
                      CDbl(Text3.Text), _
                      CDbl(Text4.Text), _
                      CDbl(Text5.Text), _
                      CDbl(Text6.Text))
End Sub
Private Function IsUpScroll(aVS As VScrollBar) As Boolean
  If aVS.Value > mOldVal Then IsUpScroll = True
  mOldVal = aVS.Value
End Function

