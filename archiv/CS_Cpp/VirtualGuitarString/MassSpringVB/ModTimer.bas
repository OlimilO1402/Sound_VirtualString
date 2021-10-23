Attribute VB_Name = "ModTimer"
Option Explicit
Private Declare Function KillTim Lib "user32.dll" Alias "KillTimer" (ByVal hWnd As Long, ByVal nIDEvent As Long) As Long
Private Declare Function SetTim Lib "user32.dll" Alias "SetTimer" (ByVal hWnd As Long, ByVal nIDEvent As Long, ByVal uElapse As Long, ByVal lpTimerFunc As Long) As Long
Private mTimID As Long

Public Sub SetTimer(nElapseTime)
  mTimID = SetTim(0&, 0&, nElapseTime, AddressOf OnTimer)
  'Call Form1.FillNextBuffer
  'Call Form1.PbDrawString.Refresh

End Sub
Public Sub KillTimer()
  Call KillTim(0&, mTimID)
End Sub

Private Sub OnTimer(ByVal IElapsedMS As Long)
  Call Form1.FillNextBuffer
  Call Form1.PbDrawString.Refresh
End Sub
