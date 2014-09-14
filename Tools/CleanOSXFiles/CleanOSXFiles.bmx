'fantomEngine CleanOSXFiles
'by Michael Hartlef
'email: contact@michaelhartlef.de
'License: MIT

Strict
'Incbin "htmlheader.txt"
'Import MaxGui.Drivers
'Import MaxGUI.ProxyGadgets

'***************************************************
'Graphics 640,480
?MacOS
Const tilde$ ="/"
?
?Win32
Const tilde$ ="\"
?
Const FILENAME$ = "CleanOSXFiles"
Const FILEVERSION$ = "1.01"
Const FILEURL$ = "http://www.fantomgl.com"

Const FileTypes$="monkey"
?Win32
Const FileTypeFilters$="Files:"+FileTypes$+";All Files:*"
?
?MacOS
Const FileTypeFilters$="Files:"+FileTypes$
?




'------------------------------------------------
Function CleanDir(dir$, flag:Int = False)
	Local currDir$ = dir$
	Local  files$[]
	Local file$
	ChangeDir(currDir$)
Print ("---------------------------------------------------------")
Print ("Scanning directory: "+currDir$+"     flag="+flag)
	files$ = LoadDir(currDir$)	
	
Print ("  Files in directory = "+Len(files$))
	For file$ = EachIn files$
		If FileType(file$)=1
'Print ("    file="+file$+"   type= "+FileType(file$))			
		Else
'Print ("    directory="+file$+"   type= "+FileType(file$))			
		EndIf
		If FileType(file$)=1 And ( Left(file$,1)="." Or flag = True)
Print ("      delete file= "+file$)
			DeleteFile(file$)	
		EndIf	
		If (FileType(file$)=2 And Right(Trim(file$),4)<>".app")
			If ( Left(file$,1)="." Or Right(Trim(file$),6)=".build" Or  Instr( Trim(file$),".build",1 )>1)
				CleanDir(currDir$ + file$ + tilde$, True)
			Else
				CleanDir(currDir$ + file$ + tilde$, flag)
			EndIf
			ChangeDir( currDir$ )
		EndIf
		If FileType(file$)=2  And ( Left(file$,1)="." Or flag = True Or Right(Trim(file$),6)=".build") Or Instr( Trim(file$),".build",1 )>1
Print ("      delete directory= "+file$)
			DeleteDir(file$, True)	
		EndIf
	Next
Print ("... finished scanning directory: "+currDir$)
End Function
	



'***************************************************
Function GetLastDir:String(path:String)
	Local f$ = ""
	If FileType(path) <> 0 Then
		f$ = LoadText(path)
	EndIf
	If Len(f$) < 2 Then f$ = AppDir + tilde$
	Return f$
End Function

'***************************************************
Function SaveLastDir(path:String, dir:String)
	SaveText(dir, path)
End Function


'***************************************************
AppTitle = FILENAME$



Local startDir_old$ = GetLastDir(FILENAME$+".ini")
Local startDir$ = RequestDir("Choose folder to clean...", startDir_old$)
If Len(startDir$) <= 1 Then End
startDir$ = startDir$ + tilde$
SaveLastDir(FILENAME$+".ini", startDir$)



Print ""
Print "--------------------------------------------------"
Print FILENAME$+" "+FILEVERSION$
Print "--------------------------------------------------"

Print "Cleaning folders... " + startDir$

CleanDir(startDir$, False)

Print "..finished cleaning folders " + startDir$

Notify "Cleaning done!"



 










