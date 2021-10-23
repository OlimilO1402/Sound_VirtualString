VERSION 5.00
Begin VB.Form FrmInput 
   BorderStyle     =   4  'Festes Werkzeugfenster
   Caption         =   "String-Parameter"
   ClientHeight    =   3510
   ClientLeft      =   6195
   ClientTop       =   2490
   ClientWidth     =   3690
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3510
   ScaleWidth      =   3690
   ShowInTaskbar   =   0   'False
   Begin VB.ComboBox CmbPickShape 
      Height          =   315
      Left            =   1680
      TabIndex        =   17
      Text            =   "Combo1"
      Top             =   480
      Width           =   1815
   End
   Begin VB.TextBox Text8 
      Height          =   285
      Left            =   1680
      TabIndex        =   7
      Text            =   "0"
      Top             =   3120
      Width           =   1575
   End
   Begin VB.TextBox Text7 
      Height          =   285
      Left            =   1680
      TabIndex        =   6
      Text            =   "0"
      Top             =   2760
      Width           =   1575
   End
   Begin VB.VScrollBar VScroll 
      Height          =   375
      Left            =   3240
      Min             =   -32768
      TabIndex        =   8
      Top             =   120
      Width           =   375
   End
   Begin VB.TextBox Text6 
      Height          =   285
      Left            =   1680
      TabIndex        =   5
      Text            =   "0"
      Top             =   2280
      Width           =   1575
   End
   Begin VB.TextBox Text5 
      Height          =   285
      Left            =   1680
      TabIndex        =   4
      Text            =   "0"
      Top             =   1920
      Width           =   1575
   End
   Begin VB.TextBox Text4 
      Height          =   285
      Left            =   1680
      TabIndex        =   3
      Text            =   "0"
      Top             =   1560
      Width           =   1575
   End
   Begin VB.TextBox Text3 
      Height          =   285
      Left            =   1680
      TabIndex        =   2
      Text            =   "0"
      Top             =   1200
      Width           =   1575
   End
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   1680
      TabIndex        =   1
      Text            =   "0"
      Top             =   840
      Width           =   1575
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   1680
      TabIndex        =   0
      Text            =   "0"
      Top             =   120
      Width           =   1575
   End
   Begin VB.Label Label9 
      Caption         =   "PickShape"
      Height          =   255
      Left            =   120
      TabIndex        =   18
      Top             =   480
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "Label8"
      Height          =   255
      Left            =   120
      TabIndex        =   16
      Top             =   3120
      Width           =   1455
   End
   Begin VB.Label Label7 
      Caption         =   "Label7"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   2760
      Width           =   1455
   End
   Begin VB.Label Label6 
      Caption         =   "Label6"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   2280
      Width           =   1455
   End
   Begin VB.Label Label5 
      Caption         =   "Label5"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   1920
      Width           =   1455
   End
   Begin VB.Label Label4 
      Caption         =   "Label4"
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   1560
      Width           =   1455
   End
   Begin VB.Label Label3 
      Caption         =   "Label3"
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   1200
      Width           =   1455
   End
   Begin VB.Label Label2 
      Caption         =   "Label2"
      Height          =   255
      Left            =   120
      TabIndex        =   10
      Top             =   840
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "Anzahl Elemente"
      Height          =   255
      Left            =   120
      TabIndex        =   9
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
Private mString  As VirtualString

Private Sub Form_Activate()
    'Text1_GotFocus
    FrmInput.VScroll.Visible = True
    Call SetVScroll(Me.VScroll)
End Sub

Private Sub Form_Deactivate()
    FrmInput.VScroll.Visible = False
End Sub

Private Sub Form_Load()
    CmbPickShape.AddItem "Hammer"
    CmbPickShape.AddItem "Triangle"
    CmbPickShape.AddItem "HammerTriangle"
    'Call SetVScroll(FrmInput.FrmIVScroll)
End Sub
Public Sub ShowModeless(frm As Form, obj As Object)
    'Load Me
    Call InitLabel
    Me.Show vbModeless, frm
    Set VirtualString = obj
End Sub
Private Sub InitLabel()
    Label1.Caption = "Anzahl Elemente:"
    Label2.Caption = "Zugkraft:"
    Label3.Caption = "Dispersion:"
    Label4.Caption = "Dämpferkonstante1:"
    Label5.Caption = "Dämpferkonstante2:"
    Label6.Caption = "Dämpferkonstante3:"
    Label7.Caption = "Exciterindex:"
    Label8.Caption = "Receiverindex:"
    Label9.Caption = "PickShape:"
End Sub
Public Property Set VirtualString(aVS As VirtualString)
    Set mString = aVS
    UpdateTxt
End Property
Private Sub UpdateTxt()
    Text1.Text = CStr(mString.Length)
    Text2.Text = CStr(mString.Tension)
    Text3.Text = CStr(mString.Dispersion)
    Text4.Text = CStr(mString.DampingC1)
    Text5.Text = CStr(mString.DampingC2)
    Text6.Text = CStr(mString.DampingC3)
    Text7.Text = CStr(mString.ExciterIx)
    Text8.Text = CStr(mString.ReceiverIx)
    CmbPickShape.ListIndex = mString.PickShape - 1
End Sub

Private Sub Text1_GotFocus()
    Call SetProperty(Text1, mString, "Length", 1, 5, 1000)
End Sub
Private Sub Text1_LostFocus()
    mString.Length = Validate
    Text1.Text = CStr(mString.Length)
End Sub

Private Sub CmbPickShape_Change()
'no
End Sub
Private Sub CmbPickShape_Click()
    mString.PickShape = CmbPickShape.ListIndex + 1
End Sub

Private Sub Text2_GotFocus()
    Call SetProperty(Text2, mString, "Tension", 0.001, 0, 1000)
End Sub
Private Sub Text2_LostFocus()
    mString.Tension = Validate
    Text2.Text = CStr(mString.Tension)
End Sub

Private Sub Text3_GotFocus()
    Call SetProperty(Text3, mString, "Dispersion", 0.00001, 0, 1000)
End Sub
Private Sub Text3_LostFocus()
    mString.Dispersion = Validate
    Text3.Text = CStr(mString.Dispersion)
End Sub

Private Sub Text4_GotFocus()
    Call SetProperty(Text4, mString, "DampingC1", 0.0000001, 0, 1000)
End Sub
Private Sub Text4_LostFocus()
    mString.DampingC1 = Validate
    Text4.Text = CStr(mString.DampingC1)
End Sub

Private Sub Text5_GotFocus()
    Call SetProperty(Text5, mString, "DampingC2", 0.00001, 0, 1000)
End Sub
Private Sub Text5_LostFocus()
    mString.DampingC2 = Validate
    Text5.Text = CStr(mString.DampingC2)
End Sub

Private Sub Text6_GotFocus()
    Call SetProperty(Text6, mString, "DampingC3", 0.00000001, 0, 1000)
End Sub
Private Sub Text6_LostFocus()
    mString.DampingC3 = Validate
    Text6.Text = CStr(mString.DampingC3)
End Sub

Private Sub Text7_GotFocus()
    Call SetProperty(Text7, mString, "ExciterIx", 1, 0, 1000)
End Sub
Private Sub Text7_LostFocus()
    mString.ExciterIx = CLng(Validate)
    Text7.Text = CStr(mString.ExciterIx)
End Sub

Private Sub Text8_GotFocus()
    Call SetProperty(Text8, mString, "ReceiverIx", 1, 0, 1000)
End Sub
Private Sub Text8_LostFocus()
    mString.ReceiverIx = CLng(Validate)
    Text8.Text = CStr(mString.ReceiverIx)
End Sub

'Private Sub Text9_GotFocus()
'    Call SetProperty(Text9, mString, "SingleMass", 0.001, 0, 1000)
'End Sub
'Private Sub Text9_LostFocus()
'    mString.SingleMass = CLng(Validate)
'    Text8.Text = CStr(mString.ReceiverIx)
'End Sub

Private Sub VScroll_Change()
    Call Scroll_Change
End Sub
