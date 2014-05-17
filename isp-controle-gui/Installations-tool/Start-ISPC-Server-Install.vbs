If RegExists("HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\FULL\") Then
	SkriptPfad = WScript.ScriptFullName
	SkriptPfad = Left(SkriptPfad, Len(SkriptPfad) - Len(WScript.ScriptName))
	SkriptPfad = Chr(34) & SkriptPfad 
	set wshell = CreateObject("Wscript.shell")
	wshell.run 	SkriptPfad & "Inst-ISPC-server.exe" & Chr(34)
Else
	a=Msgbox("Sie haben KEIN Net Framework 4.0 Full Installiert" & vbNewLine & _
	"somit kann das Programm nicht funktionieren!" & vbNewLine & _
	"Soll Net Framework 4.0 Full Installiert werde?",vbYesNo +  vbQuestion,"Wichtige Frage")
	If a = "6" Then
		SkriptPfad = WScript.ScriptFullName
		SkriptPfad = Left(SkriptPfad, Len(SkriptPfad) - Len(WScript.ScriptName))
		SkriptPfad = Chr(34) & SkriptPfad 
		set objShell = wscript.createObject("wscript.shell")
		nfw = ("cmd.exe /c " & SkriptPfad & "VPP\dotNetFx40_Full_setup.exe" & Chr(34) & " /passive /norestart")
		MsgBox(nfw)
		ObjShell.Run(nfw),1,true
		MsgBox("Net Framework 4.0 Full wurde Installiert")
		ObjShell.Run SkriptPfad & "Inst-ISPC-server.exe" & Chr(34)
	Else
		MsgBox "Ohne Net Framework 4.0 Full geht es nicht!!!",vbInformation,"Tut uns Leid"
		
	End If
End If
wscript.quit

Function RegExists(regPath)
    Dim wso, value, errString

    On Error Resume Next                     ' deactivate runtime errors
    RegExists = False                        ' set default=False
    Set wso = CreateObject("Wscript.Shell")
    If (Right(regPath, 1) <> "\") Then       ' check for Reg Value
        value = wso.RegRead(regPath)         ' try to read
        If (Err.Number=0) Then RegExists = True
    Else                                     ' check for Reg Key
        value = wso.RegRead("HKLM\Dummy\")   ' get the error description text
        errString = Replace(Err.Description, """HKLM\Dummy\"".", "" )
        value = wso.RegRead(regPath)         ' try to read
        If (Err.Number=0) Then               ' success?
            RegExists = True
        Else                                 ' or same description ?
            If Replace(Err.Description, """" & regPath & """.", "" ) <> errString Then
               RegExists = True
            End If
        End If
    End If

    Set wso = Nothing                        ' clean-up
    On Error Goto 0
End Function 