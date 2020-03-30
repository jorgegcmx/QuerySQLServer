Sub Botón4_Haga_clic_en()
    Dim con As New ADODB.Connection
    Dim com As New ADODB.Command
    Dim rs As ADODB.Recordset ' Este se usa solo para lectura
    
 
    
    Dim CadConexion As String 'Cadena de conexión
   
    
    'Cadena de conexión
    Dim Servidor As String
    Dim Usuario As String
    Dim Contrasena As String
    Dim BaseDatos As String
    
    Servidor = "192.1.1.218"
    Usuario = "master"
    Contrasena = ""
    BaseDatos = "AGQSLAPP"
    
    CadConexion = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=" & Usuario & ";Pwd=" & Contrasena & ";Initial Catalog=" & BaseDatos & ";Data Source=" & Servidor
    
    
    Set con = New ADODB.Connection
    Set rs = New ADODB.Recordset
    Set com = New ADODB.Command
    
    con.Open (CadConexion) 'Debe estar definida en fuentes de datos
    
    
    If con.State = 1 Then
        com.ActiveConnection = con
        com.CommandType = adCmdText
    Else
        MsgBox "No se pudo conectar a base de datos"
        End
    End If
    
    
    
    'variables de campos fecha
    Dim inicio As String
    Dim fin As String
    
    inicio = Cells(3, 2)
    fin = Cells(4, 2)
  
    
    If inicio = "" And fin = "" Then
    MsgBox "Error campos de fechas vacios", vbCritical, "Informe"
    
    Else
    
    ' Supongo que la consulta sería en el mismo formato que en MySQL
    com.CommandText = "exec sp_reporte_1132 '" & inicio & "','" & fin & "'"
    ' Ejecutas
    com.Execute
    ' Cierras la conexión
    con.Close
        
    'ACTUALIZAMOS CADA HOJA DEL ARCHIVO
    Dim pt As PivotTable

         Dim ws As Worksheet

           For Each ws In ActiveWorkbook.Worksheets

            For Each pt In ws.PivotTables

           pt.RefreshTable

          Next pt

      Next ws
     MsgBox "El Rango de fechas se ha Actualizado correctamente", vbInformation, "AVISO"
    End If
    
End Sub


Sub cmdEjecutarScript()
    Dim CMDStoredProc As ADODB.Command
    Dim CnnConexion As ADODB.Connection
    Dim RcsDatos As ADODB.Recordset
    
    Dim CadConexion As String 'Cadena de conexión
    Dim Row As Integer
    Dim RecordsAffected As Long
    
     'Cadena de conexión
    Dim Servidor As String
    Dim Usuario As String
    Dim Contrasena As String
    Dim BaseDatos As String
    
    Servidor = "192.1.1.218"
    Usuario = "master"
    Contrasena = ""
    BaseDatos = "AGQSLAPP"
    
    CadConexion = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID=" & Usuario & ";Pwd=" & Contrasena & ";Initial Catalog=" & BaseDatos & ";Data Source=" & Servidor
    
    Set CnnConexion = New ADODB.Connection
    Set RcsDatos = New ADODB.Recordset
    Set CMDStoredProc = New ADODB.Command
    
    'Establecemos comunicación con nuestro servidor SQL Server
    Call CnnConexion.Open(CadConexion)
    
    'Enlazamos nuestros objetos y definimos el procedimiento almacenado a ejecutar
    CMDStoredProc.CommandType = adCmdText
    Set CMDStoredProc.ActiveConnection = CnnConexion
    CMDStoredProc.CommandText = "SELECT * FROM Empleados"
    
    'Creamos el parámetro del procedimiento almacenado
    Call CMDStoredProc.Parameters.Append(CMDStoredProc.CreateParameter("PV_OPCION", DataTypeEnum.adChar, ParameterDirectionEnum.adParamInput, 10))
    
    'Ejecutamos de Script
    Set RcsDatos = CMDStoredProc.Execute(RecordsAffected, , ExecuteOptionEnum.adAsyncFetch)
    
    'Recorremos el Recordset resultante para asignarlo a la celda en Excel
    Row = 1
    Do While Not RcsDatos.EOF
        Cells(Row, 2).Value = RcsDatos.Fields(0).Value
        Row = Row + 1
        RcsDatos.MoveNext
    Loop
End Sub
