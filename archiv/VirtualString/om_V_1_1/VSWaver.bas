Attribute VB_Name = "VSWaver"
Option Explicit
Private m_VS() As VirtualString
Private m_Count As Long
Private m_SampleFrequ As Long

Public Sub AddVS(aVS As VirtualString)
    ReDim Preserve mVS(0 To Count)
    Set mVS(Count) = aVS
    Count = Count + 1
End Sub

Public Sub Pick()
    Dim i As Long
    If Count > 0 Then
        For i = 0 To UBound(mVS)
            mVS(i).Pick
        Next
    End If
End Sub

public sub WriteToWav(
