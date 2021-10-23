Attribute VB_Name = "ModConstructors"
Option Explicit

Public Function New_VirtualString(nCount As Long) As VirtualString
  Set New_VirtualString = New VirtualString
  Call New_VirtualString.NewC(nCount)
End Function
