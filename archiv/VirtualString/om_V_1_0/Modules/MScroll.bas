Attribute VB_Name = "MScroll"
Option Explicit
Private mVScroll      As VScrollBar
Private mCurTB        As TextBox
Private mObj          As Object
Private mPropName     As String
Private mCurInkrement As Double
Private mMinVal       As Double
Private mMaxVal       As Double
Private mOldScrollVal As Double

Public Sub SetVScroll(scroll As VScrollBar)
    Set mVScroll = scroll
End Sub
Public Function SetProperty(aTB As TextBox, aObj As Object, aProperty As String, ByVal inkrval As Double, ByVal minval As Double, ByVal maxval As Double) As TextBox
    Set mCurTB = aTB
    Set mObj = aObj
    mPropName = aProperty
    mCurInkrement = inkrval
    mMinVal = minval
    mMaxVal = maxval
    Dim L As Single: L = mCurTB.Left + mCurTB.Width
    Dim T As Single: T = mCurTB.Top - (mVScroll.Height - mCurTB.Height) / 2
    Call mVScroll.Move(L, T)
    If IsNumeric(mCurTB.Text) Then
        mOldScrollVal = mVScroll.value
    End If
    Set SetProperty = mCurTB
End Function
Public Sub Scroll_Change()
    Dim v As Double: v = Validate
    v = v + IIf(IsUpScroll, mCurInkrement, -mCurInkrement)
    Call CallByName(mObj, mPropName, VbLet, CLng(v))
    mCurTB.Text = CStr(v)
    mCurTB.SetFocus
End Sub
Public Function Validate() As Double
    If mCurTB Is Nothing Then Exit Function
    Dim s As String: s = mCurTB.Text
    Dim m As String: m = "Please give a valid number"
    If IsNumeric(s) Then
        Dim v As Double: v = CDbl(s)
        If IsInRange(v) Then
            Validate = v
            Exit Function
        Else
            If IsBelow(v) Then Validate = mMinVal
            If IsAbove(v) Then Validate = mMaxVal
            m = m & " between " & CStr(mMinVal) & " and " & CStr(mMaxVal)
        End If
    End If
    MsgBox m
End Function
Function IsAbove(ByVal v As Double) As Boolean
    IsAbove = (mMaxVal <= v)
End Function
Function IsBelow(ByVal v As Double) As Boolean
    IsBelow = (v <= mMinVal)
End Function
Function IsInRange(ByVal v As Double) As Boolean
    IsInRange = (mMinVal <= v) And (v <= mMaxVal)
End Function

Private Function IsUpScroll() As Boolean
    'the other way around
    IsUpScroll = mVScroll.value < mOldScrollVal
    mOldScrollVal = mVScroll.value
End Function

