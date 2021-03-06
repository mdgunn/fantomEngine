'fantomEngine Patcher for Ted's command index
'by Michael Hartlef
'mail: contact@michaelhartlef.de
'License: MIT

Strict

?MacOS
Const tilde$ ="/"
?
?Win32
Const tilde$ ="\"
?
Const FILENAME$ = "Patcher"
Const FILEVERSION$ = "1.0"
Const FILEURL$ = "http://www.fantomgl.com"

Const FileTypes$=".txt"
Const FileTypeFilters$="Files:"+FileTypes$


Global _patcher:_tPatcher

'------------------------------------------------
Type _tPatcher
	Field indexList:TList
	Field index$=""
	'------------------------------------------------
   	Method AddToIndex(c$, p$)
		ListAddLast(Self.indexList, c$ + ":" + p$ )
	End Method
	'------------------------------------------------
   	Method Start(rp$, tf$, ff$)
		Local lc%=0
		Local tedI$ =""
		Local nt$=""
		If FileType(StripExt(tf$)+"_original.txt") <> 0 Then
			Print("Loading TED's original index file instead at:   " + StripExt(tf$)+"_original.txt")
			tedI$ = LoadText(StripExt(tf$)+"_original.txt")
		Else
			tedI$ = LoadText(tf$)
			SaveText(tedI$, StripExt(tf$)+"_original.txt")
		EndIf
		Local feI$ = LoadText(ff$)
		

		Local lines$[] = feI$.Split("~n")
		
		For Local l = 1 To Len(lines)
			If Len(lines[l-1])>1 Then 
				ListAddLast(Self.indexList,lines[l-1] )
			EndIf
		Next
		
		'Create new index file
		For Local _index$ = EachIn Self.indexList
			Local i$[] = _index$.Split(":")
			lc=lc+1
			_patcher.index$ = _patcher.index$ + i$[0]
			_patcher.index $ = _patcher.index$ + ":" + rp$ + i$[1]
			If lc <  Len(lines) Then 
				_patcher.index$ = _patcher.index$ + "~n"
			EndIf
		Next
		nt$=tedI$+"~n"+index$
		SaveText(nt$,ExtractDir(tf$)+tilde$+"index.txt")
	
	End Method
	'------------------------------------------------
   	Method New()
		indexList = New TList
	End Method
	'------------------------------------------------
   	Method Create:_tPatcher()
		_patcher = Self
		Return Self
	End Method
	
End Type


Function GetRelativePath$(strRoot$, strFile$)
    Local i%, NewTreeStart%, sRel$
	Local RootCount%, RootCount2%, FileCount%
	Local buffa$
	Local Root$
	Local ssFile$

    If Left(strRoot, 3) <> Left(strFile, 3) Then
        Return strFile
    End If
	buffa$ = ""
	i= 1
	While i <= Len(strRoot$)
		If Mid(strFile$,i,1)=tilde$ Then
			RootCount=i
		EndIf
		If Mid(strRoot$,i,1)<>Mid(strFile$,i,1) Then
			buffa$ = Left(strRoot$, RootCount)
			Exit
		End If
		i=i+1
	Wend

	buffa$ = ""
	i = rootCount + 1

	While i <=Len(strRoot$)
		If Mid(strRoot $,i,1)=tilde$ Then
			'Print "---"+Mid(strRoot $,RootCount+1,i-RootCount)+"---"
			FileCount% = FileCount% + 1
		EndIf
		i=i+1
	Wend

	For i= 1 To FileCount
		buffa = buffa + ".." + tilde$
	Next
	buffa = buffa + Right(strFile$,Len(strFile$)-rootcount)

	Return buffa

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



Local tedDir_old$ = GetLastDir(FILENAME$+"_TED.ini")
Local fteDir_old$ = GetLastDir(FILENAME$+"_fE.ini")
Local TedIndex$ = RequestFile("Choose TED's index.txt file…","Text Files:txt",False, tedDir_old$)
Local fantomIndex$ = RequestFile("Choose fantomEngine's index.txt file…","Text Files:txt",False, fteDir_old$)

If Len(TedIndex$) <= 1 Or Len(fantomIndex $) <= 1 Then End
SaveLastDir(FILENAME$+"_TED.ini", TedIndex$)
SaveLastDir(FILENAME$+"_FE.ini", fantomIndex $)

Print ""
Print "--------------------------------------------------"
Print FILENAME$+" "+FILEVERSION$
Print "--------------------------------------------------"

Print "Patching " + TedIndex$ + ".."

Global patcher:_tPatcher = New _tPatcher.Create()
patcher.Start(GetRelativePath(ExtractDir(TedIndex$)+tilde$,ExtractDir(fantomIndex$)+tilde$), TedIndex$, fantomIndex$)

Print "..finished patching " + TedIndex$ 
Print (GetRelativePath(ExtractDir(TedIndex$)+tilde$,ExtractDir(fantomIndex$)+tilde$))


 










