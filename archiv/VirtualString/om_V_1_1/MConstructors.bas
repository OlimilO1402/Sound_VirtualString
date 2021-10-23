Attribute VB_Name = "ModConstructors"
Option Explicit

Public Function New_VirtualString(nCount As Long) As VirtualString
    Set New_VirtualString = New VirtualString
    Call New_VirtualString.NewC(nCount)
End Function

Public Function New_VirtualStringC(other As VirtualString) As VirtualString
    Set New_VirtualStringC = New VirtualString
    Call New_VirtualStringC.NewCp(other)
End Function

