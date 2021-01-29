Attribute VB_Name = "MNew"
Option Explicit
'Private Declare Function KillTim Lib "user32.dll" Alias "KillTimer" (ByVal hWnd As Long, ByVal nIDEvent As Long) As Long
'Private Declare Function SetTim Lib "user32.dll" Alias "SetTimer" (ByVal hWnd As Long, ByVal nIDEvent As Long, ByVal uElapse As Long, ByVal lpTimerFunc As Long) As Long
'Private mTimID As Long
'Private mTimEnabled As Boolean
'
'Public Sub SetTimer(nElapseTime)
'    If mTimEnabled Then Exit Sub
'    mTimID = SetTim(0&, 0&, nElapseTime, AddressOf OnTimer)
'    mTimEnabled = True
'End Sub
'
'Public Sub KillTimer()
'    Call KillTim(0&, mTimID)
'    mTimEnabled = False
'End Sub
'
'Private Sub OnTimer(ByVal IElapsedMS As Long)
'    Call MBuffer.FillNextBuffer
'    Call Form1.PbDrawString.Refresh
'End Sub

'ModConstructors
Public Function VirtualString(nCount As Long) As VirtualString
    Set VirtualString = New VirtualString: VirtualString.NewC nCount
End Function
