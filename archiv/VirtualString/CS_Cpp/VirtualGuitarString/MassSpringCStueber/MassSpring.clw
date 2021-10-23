; CLW-Datei enthält Informationen für den MFC-Klassen-Assistenten

[General Info]
Version=1
LastClass=CMassSpringView
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "MassSpring.h"
LastPage=0

ClassCount=8
Class1=CMassSpringApp
Class2=CMassSpringDoc
Class3=CMassSpringView
Class4=CMainFrame

ResourceCount=5
Resource1=IDD_PARAMETER
Class5=CAboutDlg
Resource2=IDD_ABOUTBOX
Class6=CParameterDlg
Resource3=IDD_DIALOG1
Class7=CReceiverDlg
Resource4=IDR_MAINFRAME
Class8=CExciterDlg
Resource5=IDD_DIALOG2

[CLS:CMassSpringApp]
Type=0
HeaderFile=MassSpring.h
ImplementationFile=MassSpring.cpp
Filter=N

[CLS:CMassSpringDoc]
Type=0
HeaderFile=MassSpringDoc.h
ImplementationFile=MassSpringDoc.cpp
Filter=N
BaseClass=CDocument
VirtualFilter=DC
LastObject=ID_EXCITER_SETPOSITION

[CLS:CMassSpringView]
Type=0
HeaderFile=MassSpringView.h
ImplementationFile=MassSpringView.cpp
Filter=C
BaseClass=CView
VirtualFilter=VWC
LastObject=ID_BUTTON32771


[CLS:CMainFrame]
Type=0
HeaderFile=MainFrm.h
ImplementationFile=MainFrm.cpp
Filter=T
LastObject=ID_BUTTON32785
BaseClass=CFrameWnd
VirtualFilter=fWC




[CLS:CAboutDlg]
Type=0
HeaderFile=MassSpring.cpp
ImplementationFile=MassSpring.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[MNU:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_NEW
Command2=ID_APP_EXIT
Command3=ID_PRESET_HOMOGENOUSSTRING
Command4=ID_PRESET_STRING
Command5=ID_PRESET_PLATE
Command6=ID_RECEIVER_SETPOSITION
Command7=ID_EXCITER_SETPOSITION
Command8=ID_PARAMETER_BIEGSAMESAITE
Command9=ID_PARAMETER_STEIFERSTAB
Command10=ID_APP_ABOUT
CommandCount=10

[ACL:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_NEW
Command2=ID_FILE_OPEN
Command3=ID_FILE_SAVE
Command4=ID_FILE_PRINT
Command5=ID_EDIT_UNDO
Command6=ID_EDIT_CUT
Command7=ID_EDIT_COPY
Command8=ID_EDIT_PASTE
Command9=ID_EDIT_UNDO
Command10=ID_EDIT_CUT
Command11=ID_EDIT_COPY
Command12=ID_EDIT_PASTE
Command13=ID_NEXT_PANE
Command14=ID_PREV_PANE
CommandCount=14

[TB:IDR_MAINFRAME]
Type=1
Class=CMainFrame
Command1=ID_FILE_NEW
Command2=ID_BUTTON32771
Command3=ID_BUTTON32785
Command4=ID_BUTTON32772
Command5=ID_BUTTON32777
Command6=ID_BUTTON32776
CommandCount=6

[DLG:IDD_PARAMETER]
Type=1
Class=CParameterDlg
ControlCount=16
Control1=IDC_SLIDER1,msctls_trackbar32,1342242840
Control2=IDC_SLIDER2,msctls_trackbar32,1342242840
Control3=IDC_STATIC,static,1342308352
Control4=IDC_STATIC,static,1342308352
Control5=IDC_STATIC,static,1342308352
Control6=IDC_SLIDER3,msctls_trackbar32,1342242840
Control7=IDC_STATIC,static,1342308352
Control8=IDC_STATIC,static,1342308352
Control9=IDC_STATIC,static,1342308352
Control10=IDC_SLIDER4,msctls_trackbar32,1342242840
Control11=IDC_SLIDER5,msctls_trackbar32,1342242840
Control12=IDC_SLIDER6,msctls_trackbar32,1342242840
Control13=IDC_STATIC,static,1342308352
Control14=IDC_SLIDER7,msctls_trackbar32,1342242840
Control15=IDC_STATIC,static,1342308352
Control16=IDC_SLIDER8,msctls_trackbar32,1342242840

[CLS:CParameterDlg]
Type=0
HeaderFile=ParameterDlg.h
ImplementationFile=ParameterDlg.cpp
BaseClass=CDialog
Filter=D
LastObject=IDC_SLIDER8
VirtualFilter=dWC

[DLG:IDD_DIALOG1]
Type=1
Class=CReceiverDlg
ControlCount=3
Control1=IDOK,button,1342242817
Control2=IDC_EDIT1,edit,1350631552
Control3=IDC_STATIC,static,1342308352

[CLS:CReceiverDlg]
Type=0
HeaderFile=ReceiverDlg.h
ImplementationFile=ReceiverDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=CReceiverDlg

[DLG:IDD_DIALOG2]
Type=1
Class=CExciterDlg
ControlCount=3
Control1=IDOK,button,1342242817
Control2=IDC_EDIT1,edit,1350631552
Control3=IDC_STATIC,static,1342308352

[CLS:CExciterDlg]
Type=0
HeaderFile=ExciterDlg.h
ImplementationFile=ExciterDlg.cpp
BaseClass=CDialog
Filter=D
VirtualFilter=dWC
LastObject=IDC_EDIT1

