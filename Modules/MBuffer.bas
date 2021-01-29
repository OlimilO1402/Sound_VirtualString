Attribute VB_Name = "MBuffer"
Option Explicit
Public mString      As VirtualString
Public mTimepasser  As Long
Public mSoundSimuDt As Long
Public mBufferpos   As Long
Public mOutscale    As Long

Public Sub FillNextBuffer()
    Dim playcursor As Long: playcursor = 1000
    Call FillBufferCircular(mBufferpos, playcursor)
End Sub
Private Sub FillBufferCircular(SStart As Long, EEnd As Long) 'Zirkulär in den Buffer schreiben
    If (SStart < EEnd) Then
        Call FillBuffer(SStart, EEnd)
    ElseIf (SStart > EEnd) Then
        Call FillBuffer(0, EEnd)
    End If
End Sub
Private Sub FillBuffer(SStart As Long, EEnd As Long) 'Linear in den Buffer schreiben
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


