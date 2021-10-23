VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MPString"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public Dispersion As Double 'Streuung
Public DampingC1  As Double 'Dämpferkonstante1
Public DampingC2  As Double 'Dämpferkonstante2
Public DampingC3  As Double 'Dämpferkonstante3
Public Tension    As Double 'Zugkraft
Public B0 As Double 'Diese Modellparameter berechnen sich aus den
Public B1 As Double 'physikalischen Parametern
Public B2 As Double '(s. void CMassSpringDoc::UpdateBParameters() )
Public B3 As Double 'nur um Berechnungszeit zu sparen. Diese werden nur
Public B4 As Double 'bei Änderung eines Parameters neu berechnet.
Public B5 As Double '
Public B6 As Double '
Public Exciterdim As Long 'Dimension (1=String 2=Plate)
Public Exciterposition As Long 'Anschlagposition
Public Ny As Long 'Anzahl Masseteilchen in Y-Reichtung
Public Nx As Long 'Anzahl Masseteilchen in X-Reichtung
Public Exciterforce As Double 'Anschlagstärke
'  CPtrArray m_masses;           // Pointer-Array, das alle Instanzen der Massen speichert
Public Masses As Collection
'  MPString();
'  virtual ~MPString();

Private Sub Class_Initialize()
  Set Masses = New Collection
  'Nx = 0
  'Ny = 0
  Exciterforce = 0.5
  Exciterposition = 3
  Exciterdim = 1

  Dispersion = 0.0001
  DampingC1 = 0.0001
  DampingC2 = 0.0001
  DampingC3 = 0.0001
  Tension = 1

End Sub
Private Sub Class_Terminate()
  Set Masses = Nothing
End Sub

Public Function GetAt(i As Long) As MPMassKurz 'Für 1D-String: Rückgabe des Elements i
  Set GetAt = Masses.Item(i + 1)
End Function
Public Function GetAt2D(x As Long, y As Long) As MPMass2D 'Für 2D-Plate: Rückgabe des Elements (x,y)
  Set GetAt2D = GetAt(x + y * Nx)
End Function

Public Sub CreateString(n As Long) 'String erzeugen
  Nx = n
  Ny = 1
  Set Masses = New Collection
  'create first element
  Dim f As New MPMassKurz
  Set f.MPString = Me
  f.Mass = 1
  'f.Tension = 1
  
  Call Masses.Add(f)
  Dim x As Long
  For x = 1 To n - 1
  '°_O_0_o
    Set f.NNext = New MPMassKurz
    Set f.MPString = Me
    Set f.NNext.Prev = f
    Set f = f.NNext

    f.Mass = 1
    'f.Tension = 1
    f.Pos(0) = CDbl(x) / CDbl(n)
    'f.Pos(1) = 0
    'f.Pos(2) = 0
    Call Masses.Add(f)
  Next
  Set f.NNext = Nothing

End Sub
Public Sub CreateRectPlate(NNx As Long, NNy As Long) 'Platte erzeugen
  Set Masses = New Collection
  Nx = NNx: Ny = NNy

  Exciterdim = 2
  '// create first element

  '// create the masses
  Dim f As MPMass2D
  Dim y As Long, x As Long
  For y = 0 To Ny - 1
    For x = 0 To Nx - 1
      Set f = New MPMass2D
      f.Mass = 1
      f.Tension = 1
      f.Pos(0) = CDbl(x) / CDbl(Nx)
      f.Pos(1) = CDbl(y) / CDbl(Ny)
      Call Masses.Add(f)
    Next
  Next
  'link them
  For y = 0 To Ny - 1
    For x = 0 To Nx - 1
      Set f = GetAt2D(x, y)
      If (y > 0) Then Set f.Up = GetAt2D(x, y - 1)
      If (x > 0) Then Set f.Prev = GetAt2D(x - 1, y)
      If (x < Nx - 1) Then Set f.NNext = GetAt2D(x + 1, y)
      If (y < Ny - 1) Then Set f.Down = GetAt2D(x, y + 1)
    Next
  Next
End Sub
'Public Sub CreateUnweigtedString(int n)'veraltet (den Elementen können leicht unterschiedliche Gewichte zugeordnet werden)

Public Sub Reset() 'Bewegung stoppen
  Dim i As Long: For i = 0 To Masses.Count - 1
    GetAt(i).Pos(Exciterdim) = 0
  Next
End Sub
Public Sub Pick() 'Ein einzelnes Element anregen
  GetAt(Exciterposition).Pos(Exciterdim) = GetAt(Exciterposition).Pos(Exciterdim) + Exciterforce * 0.5
End Sub
Public Sub Sine(f As Double) 'Sinusförmige Auslenkung
  Const pi As Double = 3.14159265
  Dim i As Long
  For i = 1 To Masses.Count() - 1
    GetAt(i).Pos(1) = GetAt(i).Pos(1) + GetAt(i).Pos(1) + Exciterforce * Sin(GetAt(i).Pos(0) * 2 * pi * f)
  Next
End Sub
Public Sub Triangular(dto As Double) 'Dreiecksförmige Auslenkung
  Dim m As Double: m = Exciterforce / GetAt(dto * Masses.Count).Pos(0)
  Dim i As Long
  For i = 1 To dto * Masses.Count - 1
    GetAt(i).Pos(1) = GetAt(i).Pos(1) + m * GetAt(i).Pos(0)
  Next
  m = -Exciterforce / (GetAt(Masses.Count - 1).Pos(0) - GetAt(dto * Masses.Count).Pos(0))
  For i = dto * Masses.Count To Masses.Count - 1
    GetAt(i).Pos(1) = GetAt(i).Pos(1) + GetAt(dto * Masses.Count).Pos(1) + m * (-GetAt(dto * Masses.Count).Pos(0) + GetAt(i).Pos(0))
  Next
End Sub
Public Sub Simulate(dt As Double)  'Simulationsschritt ausführen
Dim i As Long
  For i = 0 To Masses.Count - 1
    Call GetAt(i).Recalc(dt)
  Next
  For i = 0 To Masses.Count - 1
    Call GetAt(i).Move(dt)
  Next
End Sub

