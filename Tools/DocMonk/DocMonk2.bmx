'fantomEngine Documentator
'by Michael Hartlef
'email: contact@michaelhartlef.de
'License: MIT

Strict
Incbin "htmlheader.txt"
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
Const FILENAME$ = "DocMonk"
Const FILEVERSION$ = "2.1"
Const FILEURL$ = "http://www.fantomgl.com"

Const FileTypes$="monkey"
?Win32
Const FileTypeFilters$="Files:"+FileTypes$+";All Files:*"
?
?MacOS
Const FileTypeFilters$="Files:"+FileTypes$
?

Global _id:Int=0
Global _CurrSummery$=""
Global _CurrChange$=""
Global _CurrSeeAlso$=""
Global _doc:_tDocu

'------------------------------------------------
Type _tField
	Field name$
	Field summery$=""
	Field change$=""
	Field seeAlso$=""
	Field text$
	Field _type$
	Field value$
	Field id:Int
	Field link:TLink
	'------------------------------------------------
	Method Compare:Int(withObject:Object)
		Local other:_tField= _tField(withObject)
		If Not other Then Return Super.Compare(withObject)
		If (Self.name$) > (other.name$) Then Return 1
		If (Self.name$) < (other.name$)  Then Return -1
		Return 0
	End Method
	'------------------------------------------------
   	Method New()
		Self.id = _GetID()
	End Method
	'------------------------------------------------
   	Method Create: _tField(t:String)
		text$ = t	
		summery$ = _GetSummery()
		change$ = _GetChange()
		Return Self
	End Method
	'------------------------------------------------
   	Method Parse()
DebugLog ("...parsing field definition... " + text$)
	Local l$ = Right(text$,Len(text$)-5)    'Remove FIELD
		' Determine the name and the return type
		Local fp$[] = l$.Split(":")
		name$ = fp$[0].Trim()
		_type$ ="none"
		If Len(fp$) = 2 Then
			_type$ = fp[1]
			' Determine value
			Local pos:Int = _type$.Find("=")
			If pos > 0 Then
				value = Right(_type$,Len(_type$)-pos-1).Trim()
				_type$ = Left(_type$,pos).Trim()
			EndIf
		EndIf
'DebugLog ("___field name="+name$+"   type="+_type$+"   value="+value$)

	End Method	
	
End Type

'------------------------------------------------
Type _tImport
	Field name$
	Field summery$=""
	Field change$=""
	Field seeAlso$=""
	Field text$
	Field id:Int
	Field link:TLink
	'------------------------------------------------
	Method Compare:Int(withObject:Object)
		Local other:_tImport= _tImport(withObject)
		If Not other Then Return Super.Compare(withObject)
		If (Self.name$) > (other.name$) Then Return 1
		If (Self.name$) < (other.name$)  Then Return -1
		Return 0
	End Method
	'------------------------------------------------
   	Method New()
		Self.id = _GetID()
	End Method
	'------------------------------------------------
   	Method Create: _tImport(t:String)
		text$ = t	
		summery$ = _GetSummery()
		change$ = _GetChange()
		Return Self
	End Method
	'------------------------------------------------
   	Method Parse()
DebugLog ("...parsing import definition... " + text$)
		Local l$ = Right(text$,Len(text$)-6)    'Remove IMPORT
		name$ = l$.Trim()
	End Method	
End Type

'------------------------------------------------
Type _tGlobal
	Field name$
	Field summery$=""
	Field change$=""
	Field seeAlso$=""
	Field text$
	Field _type$
	Field value$
	Field id:Int
	Field link:TLink
	'------------------------------------------------
	Method Compare:Int(withObject:Object)
		Local other:_tGlobal= _tGlobal(withObject)
		If Not other Then Return Super.Compare(withObject)
		If (Self.name$) > (other.name$) Then Return 1
		If (Self.name$) < (other.name$)  Then Return -1
		Return 0
	End Method
	'------------------------------------------------
   	Method New()
		Self.id = _GetID()
	End Method
	'------------------------------------------------
   	Method Create: _tGlobal(t:String)
		text$ = t	
		summery$ = _GetSummery()
		change$ = _GetChange()
		Return Self
	End Method
	'------------------------------------------------
   	Method Parse()
DebugLog ("...parsing global definition... " + text$)
		Local l$ = Right(text$,Len(text$)-6)    'Remove GLOBAL

		' Determine the name and the return type
		Local fp$[] = l$.Split(":")
		name$ = fp$[0].Trim()
		_type$ ="none"
		If Len(fp$) = 2 Then
			_type$ = fp[1]
			' Determine value
			Local pos:Int = _type$.Find("=")
			If pos > 0 Then
				value = Right(_type$,Len(_type$)-pos-1).Trim()
				_type$ = Left(_type$,pos).Trim()
			EndIf
		EndIf
'DebugLog ("___global name="+name$+"   type="+_type$+"   value="+value$)

	End Method	
End Type

'------------------------------------------------
Type _tConstant
	Field name$
	Field summery$=""
	Field change$=""
	Field seeAlso$=""
	Field text$
	Field _type$
	Field value$
	Field id:Int
	Field link:TLink
	'------------------------------------------------
	Method Compare:Int(withObject:Object)
		Local other:_tConstant = _tConstant(withObject)
		If Not other Then Return Super.Compare(withObject)
		If (Self.name$) > (other.name$) Then Return 1
		If (Self.name$) < (other.name$)  Then Return -1
		Return 0
	End Method
	'------------------------------------------------
   	Method New()
		Self.id = _GetID()
	End Method
	'------------------------------------------------
   	Method Create: _tConstant(t:String)
		text$ = t	
		summery$ = _GetSummery()
		change$ = _GetChange()
		Return Self
	End Method
	'------------------------------------------------
   	Method Parse()
DebugLog ("...parsing const definition... " + text$)
		Local l$ = Right(text$,Len(text$)-5)    'Remove CONST
		' Determine the name and the return type
		Local fp$[] = l$.Split(":")
		name$ = fp$[0].Trim()
		_type$ ="none"
		If Len(fp$) = 2 Then
			_type$ = fp[1]
			' Determine value
			Local pos:Int = _type$.Find("=")
			If pos > 0 Then
				value = Right(_type$,Len(_type$)-pos-1).Trim()
				_type$ = Left(_type$,pos).Trim()
			EndIf
		EndIf
'DebugLog ("___constant name="+name$+"   type="+_type$+"   value="+value$)

	End Method	
End Type

'------------------------------------------------
Type _tFunction
	Field name$=""
	Field summery$=""
	Field change$=""
	Field seeAlso$=""
	Field text$=""
	Field _type$
	Field parameterList:TList = Null
	Field parameter$=""
	Field id:Int
	Field link:TLink
	'------------------------------------------------
	Method Compare:Int(withObject:Object)
		Local other:_tFunction= _tFunction(withObject)
		If Not other Then Return Super.Compare(withObject)
		If (Self.name$) > (other.name$) Then Return 1
		If (Self.name$) < (other.name$)  Then Return -1
		Return 0
	End Method
	'------------------------------------------------
   	Method New()
		parameterList = New TList
		Self.id = _GetID()
	End Method
	'------------------------------------------------
   	Method Create: _tFunction(t:String)
		text$ = t	
		summery$ = _GetSummery()
		change$ = _GetChange()
		seeAlso$ = _GetSeeAlso()
		Return Self
	End Method
	'------------------------------------------------
   	Method Parse()
DebugLog ("...parsing function definition... " + text$)
		Local l$ = Right(text$,Len(text$)-8)    'Remove FUNCTION
		Local f$[] = l$.Split("(")
		' Determine the name and the return type
		Local fp$[] = f$[0].Split(":")
		name$ = fp$[0].Trim()
		_type$ ="none"
		If Len(fp$) = 2 Then
			_type$ = fp[1].Trim()
		EndIf
		' Determine parameters
		If Len(f$) = 2
			parameter$ = f[1]
			Local pos:Int = parameter$.Find(")")
			parameter$ = Left(parameter$,pos)    'Get Parameters 
			parameter$ = parameter$.Trim()
			If Len(parameter$) > 0 Then
				' Parsing parameters
				Local param$[] = parameter$.Split(",")
				For l$ = EachIn param$
					Local tPara:_tParameter = New _tParameter.Create(l$.Trim())
					tPara.link = ListAddLast(parameterList, tPara)
					tPara.Parse()
				Next
			EndIf
		EndIf
	End Method
End Type

'------------------------------------------------
Type _tParameter
	Field name$
	Field text$
	Field _type$
	Field value$
	Field id:Int
	Field link:TLink
	'------------------------------------------------
   	Method New()
		Self.id = _GetID()
	End Method
	'------------------------------------------------
   	Method Create: _tParameter(t:String)
		text$ = t	
		Return Self
	End Method
	'------------------------------------------------
   	Method Parse()
DebugLog ("...parsing parameter definition... " + text$)
		' Determine the name and the return type
		Local fp$[] = text$.Split(":")
		name$ = fp$[0].Trim()
		_type$ ="none"
		If Len(fp$) = 2 Then
			_type$ = fp[1]
			' Determine value
			Local pos:Int = _type$.Find("=")
			If pos > 0 Then
				value = Right(_type$,Len(_type$)-pos-1).Trim()
				_type$ = Left(_type$,pos).Trim()
			EndIf
		EndIf
'DebugLog ("___name="+name$+"   rtype="+_type$+"   value="+value$)

	End Method
End Type

'------------------------------------------------
Type _tMethod
	Field name$=""
	Field summery$=""
	Field change$=""
	Field seeAlso$=""
	Field text$=""
	'Field file$=""
	Field _type$
	Field parameterList:TList = Null
	Field parameter$=""
	Field id:Int
	Field link:TLink
	'------------------------------------------------
	Method Compare:Int(withObject:Object)
		Local other:_tMethod= _tMethod(withObject)
		If Not other Then Return Super.Compare(withObject)
		If (Self.name$) > (other.name$) Then Return 1
		If (Self.name$) < (other.name$)  Then Return -1
		Return 0
	End Method
	'------------------------------------------------
   	Method New()
		parameterList = New TList
		Self.id = _GetID()
	End Method
	'------------------------------------------------
   	Method Create: _tMethod(t:String)
		text$ = t	
		summery$ = _GetSummery()
		change$ = _GetChange()
		seeAlso$ = _GetSeeAlso()
		Return Self
	End Method
	'------------------------------------------------
   	Method Parse()
DebugLog ("...parsing method definition... " + text$)
		Local l$ = Right(text$,Len(text$)-7)    'Remove METHOD
		Local f$[] = l$.Split("(")
		' Determine the name and the return type
		Local fp$[] = f$[0].Split(":")
		name$ = fp$[0].Trim()
		_type$ ="none"
		If Len(fp$) = 2 Then
			_type$ = fp[1].Trim()
		EndIf
		' Determine parameters
		If Len(f$) = 2
			parameter$ = f[1]
			Local pos:Int = parameter$.Find(")")
			parameter$ = Left(parameter$,pos)    'Get Parameters 
			parameter$ = parameter$.Trim()
			If Len(parameter$) > 0 Then
				' Parsing parameters
				Local param$[] = parameter$.Split(",")
				For l$ = EachIn param$
					Local tPara:_tParameter = New _tParameter.Create(l$.Trim())
					tPara.link = ListAddLast(parameterList, tPara)
					tPara.Parse()
				Next
			EndIf
		EndIf
	End Method
End Type

'------------------------------------------------
Type _tClass
	Field name$=""
	Field summery$=""
	Field change$=""
	Field seeAlso$=""
	Field text$=""
	Field file$=""
	Field _extends$=""
	Field methodList:TList = Null
	Field fieldList:TList = Null
	Field constantList:TList = Null
	Field id:Int	
	Field link:TLink
	'------------------------------------------------
	Method Compare:Int(withObject:Object)
		Local other:_tClass= _tClass(withObject)
		If Not other Then Return Super.Compare(withObject)
		If (Self.name$) > (other.name$) Then Return 1
		If (Self.name$) < (other.name$)  Then Return -1
		Return 0
	End Method
	'------------------------------------------------
   	Method New()
		methodList = New TList
		fieldList = New TList
		constantList = New TList
		Self.id = _GetID()
	End Method
	'------------------------------------------------
   	Method Create:_tClass(t:String, f:String)
		summery$ = _GetSummery()
		change$ = _GetChange()
		text$ = t	
		file$ = f
		Return Self
	End Method
	'------------------------------------------------
   	Method Parse()
DebugLog ("...parsing class definition... " + text$)
		Local c$[] = text$.Split(" ")
		Local cp$=""
		Self.name$=c$[1]
		If Len(c$) > 2 Then
			cp$ = c$[3]
			If cp$.ToUpper() = "EXTENDS" Then Self._extends$ = c$[4] 
		EndIf
		'Register class type
		If _doc <> Null Then
			_doc.AddClassType(Self)
		EndIf
	End Method
End Type

'------------------------------------------------
Type _tClassType
	Field class:_tClass = Null
	Field name$ = ""
	Field file$ = ""
	Field outputname$=""
	Field id:Int	
	Field link:TLink
	'------------------------------------------------
   	Method xxxxx()
	End Method
	'------------------------------------------------
   	Method New()
		Self.id = _GetID()
	End Method
	'------------------------------------------------
   	Method Create:_tClassType(_class:_tClass)
		class = _class
		name$ = _class.name$.ToUpper()
		file$ = _class.file$
'Print (" >>>>>> _tClassType.Create("+name$+","+file$+") <<<<<<")
		Return Self
	End Method
End Type


'------------------------------------------------
Type _tFile
	Field name$
	Field path$
	Field footer$
	Field header$
	Field nav$
	Field outputname$=""
	
	Field text$=""
	
	Field lines$[]
	Field lineCount:Int=0
	
	Field incllines$[]
	Field inclFile$=""
	Field inclText$=""
	Field inclFileLineCount:Int=0
	Field body$=""
	
	Field currLine$ = ""
	Field currLineNo:Int = -1

	Field constantList:TList = Null
	Field globalList:TList = Null
	Field functionList:TList = Null
	Field classList:TList = Null
	Field importList:TList = Null

	Field id:Int	
	Field link:TLink

	Field currGlobal:_tGlobal = Null
	Field currFunction:_tFunction = Null
	Field currClass:_tClass = Null
	Field currMethod:_tMethod = Null
	Field currField:_tField = Null
	Field currConst:_tConstant = Null
	Field currImport:_tImport = Null
		
	Field inComment:Int=False
	Field inChange:Int=False
	Field inSummery:Int=False
	Field inNav:Int=False
	Field inHeader:Int=False
	Field inFooter:Int=False
	Field isPrivate:Int=False
	Field noDoc:Int=False

	'------------------------------------------------
   	Method xxxxx()
	End Method
	'------------------------------------------------
	Method Compare:Int(withObject:Object)
		Local other:_tFile= _tFile(withObject)
		If Not other Then Return Super.Compare(withObject)
		If (Self.name$) > (other.name$) Then Return 1
		If (Self.name$) < (other.name$)  Then Return -1
		Return 0
	End Method
	'------------------------------------------------
   	Method New()
		constantList = New TList
		globalList = New TList
		functionList = New TList
		classList = New TList
		importList = New TList
		Self.id = _GetID()
	End Method
	'------------------------------------------------
   	Method Create:_tFile(dir:String, fname:String)
		name$ = fname
		path$ = dir		
'Print ("path$="+path$+"   name$="+name$)		
		Return Self
	End Method
	'------------------------------------------------
   	Method LoadClassFile:Int(fname:String)
DebugLog("LoadClassFile="+fname)
		text$ = LoadText(fname)
		lines$ = text$.Split("~n")
		lineCount = Len(lines$)	
		currLineNo = 0
		Return lineCount
	End Method
	'------------------------------------------------
   	Method GetNextLine:Int()
		Local pos:Int=0
		Local posSummery:Int=0
		Local posChange:Int=0
		Local posSeeAlso:Int=0
		Local posNav:Int=0
		Local posHeader:Int=0
		Local posFooter:Int=0
		Local currLine2$=""
		Local docuFile$=""
		currLineNo = currLineNo + 1
		If currLineNo <= lineCount Then
			currLine$ = lines$[currLineNo-1]
DebugLog(Self.name$+"       currLineNo="+ currLineNo+"   "+currLine$)


			If currLine$.ToUpper().Find("PUBLIC")= 0 And inComment = False Then
				isPrivate = False
DebugLog("   isPrivate = FALSE")
			EndIf
			If currLine$.ToUpper().Find("PRIVATE") = 0 And inComment = False Then
				isPrivate = True
DebugLog("   isPrivate = TRUE")
			EndIf
			If isPrivate = False Then
				If currLine$.ToUpper().Find("'#DOCOFF#") >= 0 Then
DebugLog("   noDoc = TRUE")
					noDoc = True
				EndIf
				
				If currLine$.ToUpper().Find("'#DOCON#") >= 0 Then
DebugLog("   noDoc = FALSE")
					noDoc = False
				EndIf
				
				If currLine$.ToUpper().Find("'#INCLFILE#") >= 0 Then
					inclFile$ = Right(currLine$.Trim(),Len(currLine$.Trim())-11)
DebugLog("inclFile$="+inclFile$)
					If FileType(inclfile$)=1 Then
						inclText$ = LoadText(inclfile$)
						'inclLines$ = inclText$.Split("~n")
						'inclFileLineCount = Len(inclLines$)
'DebugLog("incl linesCount="+inclFileLineCount )
'DebugLog("old linesCount="+lineCount)
						'lines$[currLineNo-1] = "'"
						'lines = lines[..currLineNo] + inclLines$ + lines[(currLineNo-1)..(lineCount-1)]
						'lineCount = Len(lines$)
'DebugLog("new linesCount="+lineCount)
						If Len(body$)=0 Then
							body$ = inclText$
						Else
							body$ = body$ + "~n" + inclText$
						EndIf
					EndIf
					currLine$ = ""
					
				EndIf


				If currLine$.ToUpper().Find("'#OUTPUTNAME#") >= 0 Then
					outputname$ = Right(currLine$.Trim(),Len(currLine$.Trim())-13)
				EndIf


				
				If currLine$.ToUpper().Find("#REM") >= 0 Then
DebugLog("   inComment = TRUE")
					inComment = True
				EndIf
				
				If currLine$.ToUpper().Find("#END") >= 0 And inComment = True Then
DebugLog("   inComment = FALSE")
					inComment = False
					inHeader = False
					inFooter = False
					inNav = False
					inSummery = False
					inChange = False
					currLine$ = ""
				EndIf
				
				If noDoc = False Then
					If inComment = False Then
					
						' Find single line summery
						posSummery = currLine$.ToUpper().Find("'SUMMERY:", pos)
						If posSummery >= 0 Then
							_CurrSummery$ = Right(currLine$,Len(currLine$)-(posSummery+9)).Trim()
DebugLog("   summery="+_CurrSummery$)
						EndIf
						
						' Find single line change
						posSeeAlso = currLine$.ToUpper().Find("'SEEALSO:", pos)
						If posSeeAlso >= 0 Then
							_CurrSeeAlso$ = Right(currLine$,Len(currLine$)-(posSeeAlso +9)).Trim()
DebugLog("   seeAlso="+_CurrSeeAlso$)
						EndIf
						
						' Find single line change
						posChange = currLine$.ToUpper().Find("'CHANGES:", pos)
						If posChange >= 0 Then
							_CurrChange$ = Right(currLine$,Len(currLine$)-(posChange+9)).Trim()
DebugLog("   change="+_CurrChange$)
						EndIf
						
						' Find single line header
						posHeader = currLine$.ToUpper().Find("'HEADER:", pos)
						If posHeader >= 0 Then
							header$ = Right(currLine$,Len(currLine$)-(posHeader+8)).Trim()
DebugLog("   header="+header$)
						EndIf
						
						' Find single line navigation
						posNav = currLine$.ToUpper().Find("'NAV:", pos)
						If posNav >= 0 Then
							nav$ = Right(currLine$,Len(currLine$)-(posNav+5)).Trim()
DebugLog("   nav="+header$)
						EndIf
						
						' Find single line footer
						posFooter = currLine$.ToUpper().Find("'FOOTER:", pos)
						If posFooter >= 0 Then
							footer$ = Right(currLine$,Len(currLine$)-(posFooter+8)).Trim()
DebugLog("   footer="+footer$)
						EndIf
						
					Else
					
						' Find multi line summery 
						posSummery = currLine$.ToUpper().Find("SUMMERY:")
						If posSummery >= 0 Or inSummery = True Then
							inSummery = True
							If Len(_CurrSummery$)>0 Then _CurrSummery$ = _CurrSummery$ + "~n"
							If posSummery >= 0 Then
								currLine2$ = Right(currLine$,Len(currLine$)-(posSummery+8)).Trim()
							Else
								currLine2$ = currLine$
							EndIf
							'Remove leading single line comment character
							If Left(currLine2$.Trim(),1)="'" Then
								Local posx =  currLine2$.Find("'")
								currLine2$ = Left(currLine2$,posx) + Right(currLine2$,Len(currLine2$)-(posx+1))
							EndIf
							_CurrSummery$ = _CurrSummery$ + currLine2$
DebugLog("   summery="+_CurrSummery$)
						EndIf
						
						' Find multi line change 
						posChange = currLine$.ToUpper().Find("CHANGES:")
						If posChange >= 0 Or inChange = True Then
							inChange = True
							If Len(_CurrChange$)>0 Then _CurrChange $ = _CurrChange $ + "~n"
							If posChange >= 0 Then
								currLine2$ = Right(currLine$,Len(currLine$)-(posChange+8)).Trim()
							Else
								currLine2$ = currLine$
							EndIf
							'Remove leading single line comment character
							If Left(currLine2$.Trim(),1)="'" Then
								Local posx =  currLine2$.Find("'")
								currLine2$ = Left(currLine2$,posx) + Right(currLine2$,Len(currLine2$)-(posx+1))
							EndIf
							_CurrChange $ = _CurrChange $ + currLine2$
DebugLog("   changes="+ _CurrChange $)
						EndIf
						
						' Find multi line header 
						posHeader = currLine$.ToUpper().Find("HEADER:")
						If posHeader >= 0 Or inHeader = True Then
							inHeader = True
							If Len(header$)>0 Then header$ = header$ + "~n"
							If posHeader >= 0 Then
								header$ = header$ + Right(currLine$,Len(currLine$)-(posHeader +7)).Trim()
							Else
								header$ = header$ + currLine$
							EndIf
DebugLog("   header="+header$)
						EndIf
						
						' Find multi line navigation 
						posNav = currLine$.ToUpper().Find("NAV:")
						If posNav >= 0 Or inNav = True Then
							inNav = True
							If Len(nav$)>0 Then nav$ = nav$ + "~n"
							If posNav >= 0 Then
								nav$ = nav$ + Right(currLine$,Len(currLine$)-(posNav +4)).Trim()
							Else
								nav$ = nav$ + currLine$
							EndIf
DebugLog("   nav="+nav$)
						EndIf
						
						' Find multi line footer 
						posFooter = currLine$.ToUpper().Find("FOOTER:")
						If posFooter >= 0 Or inFooter = True Then
							inFooter = True
							If Len(footer$)>0 Then footer$ = footer$ + "~n"
							If posFooter >= 0 Then
								footer$ = footer$ + Right(currLine$,Len(currLine$)-(posFooter +7)).Trim()
							Else
								footer$ = footer$ + currLine$
							EndIf
DebugLog("   footer="+footer$)
						EndIf
						
					EndIf
				EndIf
			EndIf
			currLine$ = currLine$.Trim()
			' Empty current line when we are inside a multiline comment or in a PRIVATE section
			If inComment = True Or isPrivate= True Or noDoc= True Then		
				currLine$ = ""
			EndIf

			' Remove trailing comment or single line comments
			pos = currLine$.Find("'")
			If pos >= 0 Then
				currLine$ = Left(currLine$,pos)
			EndIf

		Else
			Return False
		EndIf
		Return True
	End Method
	'------------------------------------------------
   	Method Parse()
		Local l$ =""
		Local impFile$=""
		Local impDir$=""
		Local tmpFile:_tFile
DebugLog (" ")
DebugLog ("parsing file... " + Self.path$ + Self.name$)
		If LoadClassFile(Self.path$ + Self.name$)> 0 Then
			While GetNextLine()=True
				l$ = currLine$.Trim()
DebugLog ("    parsing line... " + l$)
				If Left(l$.ToUpper(),5)="CLASS" Then 
					Self.currClass = New _tClass.Create(l$, Self.name$)
					Self.currClass.link = ListAddLast(Self.classList, Self.currClass)
					Self.currClass.Parse()
				EndIf
				If Left(l$.ToUpper(),5)="FIELD" Then 
					Local _Field:_tField= New _tField.Create(l$)
					If Self.currClass <> Null Then
						_Field.link = ListAddLast(Self.currClass.fieldList, _Field)
					EndIf
					_Field.Parse()
				EndIf
				If Left(l$.ToUpper(),6)="METHOD" Then 
					Self.currMethod = New _tMethod.Create(l$)
					If Self.currClass <> Null Then
						Self.currMethod.link = ListAddLast(Self.currClass.methodList, Self.currMethod)
					EndIf
					Self.currMethod.Parse()
				EndIf
				If Left(l$.ToUpper(),8)="FUNCTION" Then
					Self.currClass = Null 
					Self.currFunction = New _tFunction.Create(l$)
					Self.currFunction.link = ListAddLast(Self.functionList, Self.currFunction)
					Self.currFunction.Parse()
				EndIf
				If Left(l$.ToUpper(),6)="GLOBAL" Then
					Self.currClass = Null  
					Local currGlobal:_tGlobal = New _tGlobal.Create(l$)
					currGlobal.link = ListAddLast(Self.globalList, currGlobal)
					currGlobal.Parse()
				EndIf
				If Left(l$.ToUpper(),5)="CONST" Then 
					Local currConst:_tConstant = New _tConstant.Create(l$)
					If Self.currClass = Null Then
						currConst.link = ListAddLast(Self.constantList, currConst)
					Else
						currConst.link = ListAddLast(Self.currClass.constantList, currConst)
					EndIf
					currConst.Parse()
				EndIf
				If Left(l$.ToUpper(),6)="IMPORT" Then
					impFile$ = Trim(Right(l$,Len(l$)-6))

					If Left(impFile$,1)<>Chr(34) Then
					
						Self.currClass = Null  
						Local currImport:_tImport = New _tImport.Create(l$)
						currImport.link = ListAddLast(Self.importList, currImport)
						currImport.Parse()

						impFile$ = Replace(impFile$,".",tilde$)+".monkey"
						impDir$ = ExtractDir(impFile$)
						If Len(impDir$)>0 Then impDir$ = impDir$ + tilde$
						impFile$ = StripDir(impFile$)
DebugLog ("import= <"+_doc.startDir$+impDir$+impFile$+">"+FileType(_doc.startDir$+impDir$+impFile$))					
						If FileType(_doc.startDir$+impDir$+impFile$) = 1 Then
							Local found:Int = 0 
							For Local impf:_tFile = EachIn _doc.fileList
								If impf.name$ = impFile$ Then 
									found = 1
								EndIf
							Next
							If found = 0 Then
DebugLog ("file added = "+_doc.startDir$+impDir$+impFile$)					
								tmpFile  = New _tFile.Create(_doc.startDir$+impDir$, impFile$)
								tmpFile.link = ListAddLast(_doc.fileList, tmpFile )
								tmpFile.Parse()
							EndIf
						EndIf
					EndIf
				EndIf
			Wend
		EndIf
DebugLog ("... finished parsing file... " + Self.name$)

	End Method
End Type

'------------------------------------------------
Type _tDocu
	Field fileList:TList = Null
	Field currFile:_tFile = Null
	Field classTypeList:TList = Null
	Field files$[]
	Field subfiles$[]
	Field startDir$
	Field file$
	Field subfile$
	Field multiComment:Int
	Field output$
	Field outputStart$
	Field output2$
	Field outputStart2$
	Field htmldir$
	Field codedir$
	Field monkeydocdir$
	Field htmlfile$
	Field monkeydocfile$
	Field index$ =""
	Field indexList:TList = Null
	
	'------------------------------------------------
   	Method AddClassType(_class:_tClass)
		Local _classType:_tClassType = Null
		For Local tmpCType:_tClassType = EachIn Self.classTypeList
			If tmpCType.name$ = _class.name$.ToUpper()
				_classType = tmpCType
				Exit
			EndIf
		Next
		If _classType = Null Then
			_classType = New _tClassType.Create(_class)
			_classType.link = ListAddLast(Self.classTypeList, _classType )
		EndIf
	End Method
	'------------------------------------------------
   	Method AddToIndex(c$, p$)
		'_doc.index$ = _doc.index$ + c$ + ":" + p$ + "~n"
		ListAddLast(Self.indexList,c$ + ":" + p$ )
	End Method
	'------------------------------------------------
   	Method GetClassTypeLink:String(ct:String)
		For Local _classType:_tClassType = EachIn Self.classTypeList
			If _classType.name$ = ct.ToUpper()
				Return _classType.file$
			EndIf
		Next
		Return ""
	End Method
	'------------------------------------------------
   	Method FormatBBCode:String(i:String)
		Local pos:Int=0
		Local pos2:Int=0
		Local pos3:Int=0
		Local link$=""
		Local linkname$=""
		Local counter:Int = 0
		Local src$=""
		Local repl$=""
		' Quote
		i = i.Replace( "[quote]","<blockquote>")
		i = i.Replace( "[/quote]","</blockquote>")
		' Italic
		i = i.Replace( "[i]","<i>")
		i = i.Replace( "[/i]","</i>")
		' Underlined
		i = i.Replace( "[u]","<u>")
		i = i.Replace( "[/u]","</u>")
		' Bold
		i = i.Replace( "[b]","<b>")
		i = i.Replace( "[/b]","</b>")
		' Code
		i = i.Replace( "[code]","<p><pre>")
		i = i.Replace( "[/code]","</pre></p>")
		' List
		i = i.Replace( "[list]","<ul>")
		i = i.Replace( "[/list]","</ul>")
		' List =1
		i = i.Replace( "[list=1]","<ol>")
		i = i.Replace( "[/list]","</ol>")
		' List =i
		i = i.Replace( "[list=a]",("<ol style=" + Chr$(34) + "list-style-type: lower-alpha" + Chr(34) + ">"))
		i = i.Replace( "[/list]","</ol>")
		' List =a
		i = i.Replace( "[list=i]",("<ol type=" + Chr$(34) + "i" + Chr(34) + ">"))
		i = i.Replace( "[/list]","</ol>")
		' Listitem
		i = i.Replace( "[*]","<li>")

		' Link/URL
		pos = i.Find("[a ",pos)
		While pos >= 0 And counter < 4
			counter = counter + 1
			pos2 = i.Find("]",pos)
			link$ = i[pos+3..pos2]
			pos3 = i.Find("[/a]",pos2)
			linkname$ = i[pos2+1..pos3]			
			src$ = i[pos..pos3+4]
			repl$ = "<a href=" + Chr(34) + link$ + Chr(34) + ">" + linkname$ + "</a>"
			i = i.Replace( src$,repl$)
			pos=i.Find("[a ",pos3)

		Wend

		' Center
		i = i.Replace( "[center]","<center>")
		i = i.Replace( "[/center]","</center>")

		Return i
	End Method
	
	'------------------------------------------------
   	Method FormatMarkUpCode:String(i:String)
		Local pos:Int=0
		Local pos2:Int=0
		Local pos3:Int=0
		Local link$=""
		Local linkname$=""
		Local counter:Int = 0
		Local src$=""
		Local repl$=""
		' Quote
		i = i.Replace( "[quote]","<blockquote>")
		i = i.Replace( "[/quote]","</blockquote>")
		' Italic
		i = i.Replace( "[i]","%")
		i = i.Replace( "[/i]","%")
		' Underlined
		i = i.Replace( "[u]","<u>")
		i = i.Replace( "[/u]","</u>")
		' Bold
		i = i.Replace( "[b]","*")
		i = i.Replace( "[/b]","*")
		' Code
		i = i.Replace( "[code]","<pre>")
		i = i.Replace( "[/code]","</pre>~n")
		' List
		i = i.Replace( "[list]","~n")
		i = i.Replace( "[/list]","~n")
		' List =1
		i = i.Replace( "[list=1]","~n")
		i = i.Replace( "[/list]","~n")
		' List =i
		i = i.Replace( "[list=a]","~n")
		i = i.Replace( "[/list]","~n")
		' List =a
		i = i.Replace( "[list=i]","~n")
		i = i.Replace( "[/list]","~n")
		' Listitem
		i = i.Replace( "[*]","~n* ")

		' Link/URL
		pos = i.Find("[a ",pos)
		While pos >= 0 And counter < 4
			counter = counter + 1
			pos2 = i.Find("]",pos)
			link$ = i[pos+3..pos2]
			pos3 = i.Find("[/a]",pos2)
			linkname$ = i[pos2+1..pos3]			
			src$ = i[pos..pos3+4]
			repl$ = "<a href=" + Chr(34) + link$ + Chr(34) + ">" + linkname$ + "</a>"
			i = i.Replace( src$,repl$)
			pos=i.Find("[a ",pos3)

		Wend

		' Center
		i = i.Replace( "[center]","<center>")
		i = i.Replace( "[/center]","</center>")

		Return i
	End Method
	
	'------------------------------------------------
   	Method OutputFileBody(_file:_tFile)
		Local s$=""
		Local s2$=""
		Local bodylines$[]
		If Len(_file.body$) > 0 Then
			bodylines$ = _file.body$.Split("~n")
		
			For Local i:Int = 1 To Len(bodylines$)
				s$ = s$ + FormatBBCode(bodylines$[i-1]) + "<br>"
				s2$ = s2$ + FormatBBCode(bodylines$[i-1]) + "~n"
			Next
		EndIf
		output$ = output$ + s$
		output2$ = output2$ + s2$
	End Method
	
	'------------------------------------------------
   	Method OutputFileClass(_class:_tClass)
		
		Local s$=""
		Local s2$=""

		s$ = s$ + "<table style=" + Chr(34) + "width: 100%" + Chr(34) + " id="+ Chr(34) + _class.id + _class.name$ + Chr(34) + ">"
		s$ = s$ + "<tbody>"
		s$ = s$ + "<tr id=" + Chr(34) + _class.name$ + Chr(34) + ">"
		s$ = s$ + "<td class=" +  Chr(34) + "tablehead" + Chr(34) + " colspan=" + Chr(34) + "2" + Chr(34) 
		s$ = s$ + ">" + _class.text$ + "</td>"
		s$ = s$ + "</tr>"
		
		s2$ = s2$ + "# Class " + StripExt(Self.currfile.name$) + "." + _class.name$ + "~n~n"
		
		' Changes
		If Len(_class.change$)> 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Changes:" + "</td>"
			s$ = s$ + "<td>" + FormatBBCode(_class.change$) + "</td>"
			s$ = s$ + "</tr>"
		EndIf
		
		' Summery
		If Len(_class.summery$)> 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Description:" + "</td>"
			s$ = s$ + "<td>" + FormatBBCode(_class.summery$) + "</td>"
			s$ = s$ + "</tr>"
			s2$ = s2$ + FormatMarkUpCode(_class.summery$) + "~n~n"
		EndIf
		
		output2$ = output2$ + s2$
		s2$=""
		
		' Content
		output$ = output$ + s$
		OutputFileClassContent(_class)
		
		' Methods
		If CountList(_class.methodList) <> 0 Then
			For Local _method:_tMethod = EachIn _class.methodList
				OutputFileClassMethod(_class, _method)
			Next
		EndIf
		
		' Constants
		If CountList(_class.constantList) <> 0 Then
			For Local _constant:_tConstant = EachIn _class.constantList
				OutputFileClassConstant(_constant)
			Next
		EndIf
		
		' Fields
		If CountList(_class.fieldList) <> 0 Then
			For Local _field:_tField = EachIn _class.fieldList
				OutputFileClassField(_field)
			Next
		EndIf
		
		s$ = "</tbody>"
		s$ = s$ + "</table>"
		output$ = output$ + s$
		output2$ = output2$ + s2$
	End Method

	'------------------------------------------------
   	Method OutputFileClassConstant(_constant:_tConstant)
		Local s$=""
		Local s2$=""
		Local sumlines$[]
		s$ = s$ + "<tr>"
		s$ = s$ + "<td colspan=" + Chr(34) + "2" + Chr(34) + ">"
		s$ = s$ + "<table style=" + Chr(34) + "width: 100%" + Chr(34) + " class="+ Chr(34) + "subtable" + Chr(34) + ">"
		s$ = s$ + "<tbody>"
		s$ = s$ + "<tr id=" + Chr(34) + _constant.id + _constant.name$ + Chr(34) + ">"
		s$ = s$ + "<td class=" +  Chr(34) + "subtablehead" + Chr(34) + " colspan=" + Chr(34) + "2" + Chr(34) + "id=" + Chr(34) + _constant.name$ + Chr(34)
		s$ = s$ + ">" + _constant.text$ + "</td>"
		s$ = s$ + "</tr>"
		
		s2$ = s2$ + "# Const " + _constant.name$ + ":" + _constant._type$ + "~n~n"

		' Changes
		If Len(_constant.change$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Changes:" + "</td>"
			sumlines$ = _constant.change$.Split("~n")
			s$ = s$ + "<td>"
			For Local i:Int = 1 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1]) + "<br>"
			Next
			s$ = s$ + "</tr>"
		EndIf
		' Description
		If Len(_constant.summery$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Description:" + "</td>"
			sumlines$ = _constant.summery$.Split("~n")
			s$ = s$ + "<td>" + FormatBBCode(sumlines$[0]) + "</td>"
			s$ = s$ + "</tr>"
			
			s2$ = s2$ + FormatMarkUpCode(_constant.summery$) + "~n~n"

		EndIf
		' Type
		If Len(_constant._type$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Type:" + "</td>"
			
			'Determine the typelink
			Local linkType$ = GetClassTypeLink:String(_constant._type$.Trim())
			If Len(linkType$) > 0 Then 
				linkType$ = linkType$ + ".html"
				s$ = s$ + "<td>" + "<a href=" + Chr(34) + linkType$ + Chr(34) + ">" + _constant._type$ + "</a>" + "</td>"
			Else
				s$ = s$ + "<td>" + _constant._type$ + "</td>"
			EndIf
			
			s$ = s$ + "</tr>"
		EndIf
		' Value
		If Len(_constant.value$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Value:" + "</td>"
			s$ = s$ + "<td>" + _constant.value$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf

		' Details
		If Len(sumlines$) > 1 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Details:" + "</td>"
			s$ = s$ + "<td>"
			For Local i:Int = 2 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1])+"<br>"
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf

		s$ = s$ + "</tbody>"
		s$ = s$ + "</table>"
		output$ = output$ + s$
		output2$ = output2$ + s2$
	End Method
	
	'------------------------------------------------
   	Method OutputFileClassContent(_class:_tClass)
		Local s$=""
		
		s$ = s$ + "<tr>"
		s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Table of contents:</td>"
		s$ = s$ + "<td>"
			
		' Methods
		If CountList(_class.methodList) <> 0 Then
			_class.methodList.Sort()
			's$ = s$ + Chr(34) + "Fields:" + Chr(34) + "<br>"
			s$ = s$ + "Methods:" + "<br>"
			s$ = s$ + "<ul>"
			For Local _method:_tMethod = EachIn _class.methodList
				s$ = s$ + "<li><a href="+Chr(34) + "#" + _method.id + _method.name$ + Chr(34) + ">" + _method.name$ + "</a> &emsp;&emsp;<i>( " + _method.text$ + " )</i>"
				If Len(_method.change$) > 0 Then
					s$ = s$ + " &emsp;&emsp;<FONT COLOR="+ Chr(34) + "#FF0000>" + Chr(34) + "   <b>" + _method.change$ + "</b></FONT>"
				EndIf
_doc.AddToIndex(_method.name $, currFile.name$ + ".html")
			Next
			s$ = s$ + "</ul><br>"
		EndIf
		' Constants
		If CountList(_class.constantList) <> 0 Then
			_class.constantList.Sort()
			's$ = s$ + Chr(34) + "Fields:" + Chr(34) + "<br>"
			s$ = s$ + "Constants:" + "<br>"
			s$ = s$ + "<ul>"
			For Local _constant:_tConstant = EachIn _class.constantList
				s$ = s$ + "<li><a href="+Chr(34) + "#" + _constant.id + _constant.name$ + Chr(34) + ">" + _constant.name$ + "</a><i>        ( " + _constant.text$ + " )</i>"
				If Len(_constant.change$) > 0 Then
					s$ = s$ + " &emsp;&emsp;<FONT COLOR="+ Chr(34) + "#FF0000>" + Chr(34) + "   <b>" + _constant.change$ + "</b></FONT>"
				EndIf
_doc.AddToIndex(_constant.name $, currFile.name$ + ".html")
			Next
			s$ = s$ + "</ul><br>"
		EndIf
		' Fields
		If CountList(_class.fieldList) <> 0 Then
			_class.fieldList.Sort()
			's$ = s$ + Chr(34) + "Fields:" + Chr(34) + "<br>"
			s$ = s$ + "Fields:" + "<br>"
			s$ = s$ + "<ul>"
			For Local _field:_tField = EachIn _class.fieldList
				s$ = s$ + "<li><a href="+Chr(34) + "#" + _field.id + _field.name$ + Chr(34) + ">" + _field.name$ + "</a><i>        ( " + _field.text$ + " )</i>"
				If Len(_field.change$) > 0 Then
					s$ = s$ + " &emsp;&emsp;<FONT COLOR="+ Chr(34) + "#FF0000>" + Chr(34) + "   <b>" + _field.change$ + "</b></FONT>"
				EndIf
_doc.AddToIndex(_field.name $, currFile.name$ + ".html")
			Next
			s$ = s$ + "</ul><br>"
		EndIf
		s$ = s$ + "</td>"
		s$ = s$ + "</tr>"
		output$ = output$ + s$
'If _class.name$="ftTimer" Then Print("class content "+_class.name$+"~n"+s$+"~n"+"~n")
	End Method

	'------------------------------------------------
   	Method OutputFileClassField(_field:_tField)
		Local s$=""
		Local s2$=""
		Local sumlines$[]
		s$ = s$ + "<tr>"
		s$ = s$ + "<td colspan=" + Chr(34) + "2" + Chr(34) + ">"
		s$ = s$ + "<table style=" + Chr(34) + "width: 100%" + Chr(34) + " class="+ Chr(34) + "subtable" + Chr(34) + ">"
		s$ = s$ + "<tbody>"
		s$ = s$ + "<tr id=" + Chr(34) + _field.id + _field.name$ + Chr(34) + ">"
		s$ = s$ + "<td class=" +  Chr(34) + "subtablehead" + Chr(34) + " colspan=" + Chr(34) + "2" + Chr(34) + "id=" + Chr(34) + _field.name$ + Chr(34)
		s$ = s$ + ">" + _field.text$ + "</td>"
		s$ = s$ + "</tr>"

		s2$ = s2$ + "# Field " + _field.name$ + ":" + _field._type$ + "~n~n"

		' Change
		If Len(_field.change$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Change:" + "</td>"
			sumlines$ = _field.change$.Split("~n")
			s$ = s$ + "<td>"
			For Local i:Int = 1 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1]) + "<br>"
			Next
			s$ = s$ + "</tr>"
		EndIf
		' Description
		If Len(_field.summery$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Description:" + "</td>"
			sumlines$ = _field.summery$.Split("~n")
			s$ = s$ + "<td>" + FormatBBCode(sumlines$[0]) + "</td>"
			s$ = s$ + "</tr>"
			
			s2$ = s2$ + FormatMarkUpCode(_field.summery$) + "~n~n"
		EndIf
		' Type
		If Len(_field._type$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Type:" + "</td>"
			'Determine the typelink
			Local linkType$ = GetClassTypeLink:String(_field._type$.Trim())
			If Len(linkType$) > 0 Then 
				linkType$ = linkType$ + ".html"
				s$ = s$ + "<td>" + "<a href=" + Chr(34) + linkType$+Chr(34) + ">" + _field._type$ + "</a>" + "</td>"
			Else
				s$ = s$ + "<td>" + _field._type$ + "</td>"
			EndIf

			s$ = s$ + "</tr>"
		EndIf
		' Value
		If Len(_field.value$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Value:" + "</td>"
			s$ = s$ + "<td>" + _field.value$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf
		' Details
		If Len(sumlines$) > 1 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Details:" + "</td>"
			s$ = s$ + "<td>"
			For Local i:Int = 2 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1])+"<br>"
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf

		s$ = s$ + "</tbody>"
		s$ = s$ + "</table>"
		output$ = output$ + s$
		output2$ = output2$ + s2$
	End Method
	
	'------------------------------------------------
   	Method OutputFileClassMethod(_class:_tClass, _method:_tMethod)
		Local s$=""
		Local s2$=""
		Local sumlines$[]
		s$ = s$ + "<tr>"
		s$ = s$ + "<td colspan=" + Chr(34) + "2" + Chr(34) + ">"
		s$ = s$ + "<table style=" + Chr(34) + "width: 100%" + Chr(34) + " class=" + Chr(34) + "subtable" + Chr(34) + ">"
		s$ = s$ + "<tbody>"
		s$ = s$ + "<tr id=" + Chr(34) + _method.id + _method.name$ + Chr(34) + ">"
		s$ = s$ + "<td class=" +  Chr(34) + "subtablehead" + Chr(34) + " colspan=" + Chr(34) + "2" + Chr(34) + "id=" + Chr(34) + _method.name$ + Chr(34)
		s$ = s$ + ">" + _method.text$ + "</td>"
		s$ = s$ + "</tr>"
		
		' Syntax
		s$ = s$ + "<tr>"
		s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + "><br>Syntax:<br><br>" + "</td>"
		s$ = s$ + "<td>"
		s$ = s$ + "<br>"
		If Len(_method._type$) > 0 And _method._type$.ToUpper()<>"VOID" Then
			Local linkType2$ = GetClassTypeLink:String(_method._type$.Trim())
			If Len(linkType2$)> 0 Then 
				's$ = s$ + "<b>"  + "<a href=" + Chr(34) + linkType2$ + ".html" + Chr(34)+ ">" + _method._type$.Trim()+"Obj" + "</a></b> = "
				s$ = s$ + "<b>"  + _method._type$.Trim()+ "</b> = "
			Else
				's$ = s$ + "<b>" + _method._type$.Trim()+ "</b> = "
				s$ = s$ + "<b>" + _method._type$.Trim()+ "</b> = "
			EndIf
		EndIf 
		s$ = s$ + _class.name$ + "."
		s$ = s$ + "<b>" + _method.name$ + "</b>" + " ("
		If Len(_method.parameter$) > 1 Then
			s$ = s$ + _method.parameter$ 
		EndIf
		s$ = s$ + ")"
		s$ = s$ + "</td>"
		s$ = s$ + "</tr>"
		
		s2$ = s2$ + "# Method " + _method.name$ + ":" + _method._type$ + "(" + _method.parameter$ + ")" + "~n~n"

		
		' Changes
		If Len(_method.change$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Changes:" + "</td>"
			sumlines$ = _method.change$.Split("~n")
			s$ = s$ + "<td>"
			For Local i:Int = 1 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1]) + "<br>"
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf
		
		' Description
		If Len(_method.summery$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Description:" + "</td>"
			sumlines$ = _method.summery$.Split("~n")
			s$ = s$ + "<td>" + FormatBBCode(sumlines$[0]) + "</td>"
			s$ = s$ + "</tr>"
			's2$ = s2$ + FormatMarkUpCode(_method.summery$) + "~n~n"
			s2$ = S2$ + FormatMarkUpCode("*Description*")+"~n~n"
			s2$ = s2$ + FormatBBCode(sumlines$[0]) + "~n~n"

		EndIf
		
		
		
		' Return type
		If Len(_method._type$) > 0 And _method._type$.ToUpper()<>"VOID" Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Return type:" + "</td>"
			
			Local linkType$ = GetClassTypeLink:String(_method._type$.Trim())
			If Len(linkType$) > 0 Then 
				linkType$ = linkType$ + ".html"
				's$ = s$ + "<td>" + _method._type$ + "   (" + linkType$ + ")" + "</td>"
				s$ = s$ + "<td>" + "<a href=" + Chr(34) + linkType$ + Chr(34) + ">" + _method._type$ + "</a>" + "</td>"
			Else
				s$ = s$ + "<td>" + _method._type$ + "</td>"
			EndIf
			s$ = s$ + "</tr>"
		EndIf
Rem		
		' Parameters
		If Len(_method.parameter$) > 1 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Parameters:" + "</td>"
			s$ = s$ + "<td>"
			's$ = s$ + "<ul>"
			For Local _para:_tParameter = EachIn _method.parameterList
				s$ = s$ + _para.name$
				If Len(_para._type$) > 0 Then 
					'Determine the typelink
					Local linkType$ = GetClassTypeLink:String(_para._type$.Trim())
					If Len(linkType$) > 0 Then 
						linkType$ = linkType$ + ".html"
						s$ = s$ + " : " + "<a href=" + Chr(34) + linkType$ + Chr(34) + ">" + _para._type$ + "</a>"
					Else
						s$ = s$ + " : " + _para._type$
					EndIf
					
				EndIf
				If Len(_para.value$) > 0 Then s$ = s$ + " = " + _para.value$
				s$ = s$ + "<br>"
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf
EndRem

		' Parameters
		If Len(_method.parameter$) > 1 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Parameters:" + "</td>"
			s$ = s$ + "<td>"
		s$ = s$ + "<table  border=" + Chr(34) + "0" + Chr(34) + Chr(34) + " width:100%" + Chr(34) + " class=" + Chr(34) + "subtable" + Chr(34) +">"
		's$ = s$ + "<table  class=" + Chr(34) + "gridtable" + Chr(34) + Chr(34) + " width:100%" + Chr(34) + ">"
		s$ = s$ + "<tr>"
		s$ = s$ + "<th>Name</th><th>Type</th><th>Value</th>"
		s$ = s$ + "</tr>"
			For Local _para:_tParameter = EachIn _method.parameterList
		s$ = s$ + "<tr>"
		s$ = s$ + "<td>"
				s$ = s$ + _para.name$
		s$ = s$ + "</td>"
		s$ = s$ + "<td>"
				If Len(_para._type$) > 0 Then 
					'Determine the typelink
					Local linkType$ = GetClassTypeLink:String(_para._type$.Trim())
					If Len(linkType$) > 0 Then 
						linkType$ = linkType$ + ".html"
						's$ = s$ + " : " + "<a href=" + Chr(34) + linkType$ + Chr(34) + ">" + _para._type$ + "</a>"
						s$ = s$ + "<a href=" + Chr(34) + linkType$ + Chr(34) + ">" + _para._type$ + "</a>"
					Else
						's$ = s$ + " : " + _para._type$
						s$ = s$ + _para._type$
					EndIf
					
				EndIf
		s$ = s$ + "</td>"
		s$ = s$ + "<td>"
				'If Len(_para.value$) > 0 Then s$ = s$ + " = " + _para.value$
				If Len(_para.value$) > 0 Then s$ = s$ + _para.value$
				's$ = s$ + "<br>"
		s$ = s$ + "</td>"
		s$ = s$ + "</tr>"
			Next
		s$ = s$ + "</table>"
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf


		' Details
		If Len(sumlines$) > 1 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Details:" + "</td>"
			s$ = s$ + "<td>"
			s2$ = S2$ + FormatMarkUpCode("*Details*")+"~n~n"
			For Local i:Int = 2 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1]) + "<br>"
				s2$ = s2$ + FormatBBCode(sumlines$[i-1]) + "~n~n"
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf

		' Code
		Local ccd$ = CurrentDir()
		ChangeDir(codedir$+tilde$)

		If FileType("_"+_class.name$+"."+_method.name$+".monkey")=1 Then
			Local srcCode$=LoadText("_"+_class.name$+"."+_method.name$+".monkey")
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Example:" + "</td>"
			s$ = s$ + "<td>"
			s$ = s$ + "<pre>" + srcCode$
			s$ = s$ + "</pre>"
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
			
			s2$ = s2$ + "Example:" + "~n~n"
			
			s2$ = s2$ + "<pre>" + "~n"
			s2$ = s2$ + srcCode$ + "~n"
			s2$ = s2$ + "</pre>" + "~n"
		EndIf
		ChangeDir(ccd$)

		' SeeAlso
		If Len(_method.seeAlso$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">See also:" + "</td>"
			sumlines$ = _method.seeAlso$.Split(",")
			s$ = s$ + "<td>"
			s2$ = s2$ + "Links: "
			For Local i:Int = 1 To Len(sumlines$)
				's$ = s$ + FormatBBCode(sumlines$[i-1].Trim())
				s$ = s$ + "<a href="+Chr(34) + "#" + FormatBBCode(sumlines$[i-1].Trim()) + Chr(34) + ">" + "<b>" + FormatBBCode(sumlines$[i-1].Trim()) + "</b>" + "</a>"
				s2$ = s2$ + "[[" + FormatBBCode(sumlines$[i-1].Trim()) + "]]"
				If i < Len(sumlines$) Then 
					s$ = s$ + " , "
					s2$ = s2$ + ", "
				EndIf					
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
			
			'Links: [[Resource paths]], [[File formats]], [[CreateImage]], [[Image.DefaultFlags]], [[Image.GrabImage]]
			s2$ = s2$  + "~n~n"

		EndIf
		
		s$ = s$ + "</tbody>"
		s$ = s$ + "</table>"
		output$ = output$ + s$
		output2$ = output2$ + s2$
	End Method

	'------------------------------------------------
   	Method OutputFileConstant(_constant:_tConstant)
		Local s$=""
		Local s2$=""
		Local sumlines$[]
		s$ = s$ + "<table style=" + Chr(34) + "width: 100%" + Chr(34) + ">"
		s$ = s$ + "<tbody>"
		s$ = s$ + "<tr id=" + Chr(34) + _constant.id + _constant.name$ + Chr(34) + ">"
		s$ = s$ + "<td class=" +  Chr(34) + "tablehead" + Chr(34) + " colspan=" + Chr(34) + "2" + Chr(34) 
		s$ = s$ + " id=" + Chr(34) + _constant.name$ + Chr(34) + ">" + _constant.text$ + "</td>"
		s$ = s$ + "</tr>"

		s2$ = s2$ + "# Const " + _constant.name$ + ":" + _constant._type$ + "~n~n"

		' Changes
		If Len(_constant.change$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Changes:" + "</td>"
			sumlines$ = _constant.change$.Split("~n")
			s$ = s$ + "<td>"
			For Local i:Int = 1 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1]) + "<br>"
			Next
			s$ = s$ + "</tr>"
		EndIf

		' Description
		If Len(_constant.summery$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Description:" + "</td>"
			sumlines$ = _constant.summery$.Split("~n")
			s$ = s$ + "<td>" + FormatBBCode(sumlines$[0]) + "</td>"
			s$ = s$ + "</tr>"
			s2$ = s2$ + FormatMarkUpCode(_constant.summery$) + "~n~n"
		EndIf
		' Type
		If Len(_constant._type$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Type:" + "</td>"
			
			'Determine the typelink
			Local linkType$ = GetClassTypeLink:String(_constant._type$.Trim())
			If Len(linkType$) > 0 Then 
				linkType$ = linkType$ + ".html"
				s$ = s$ + "<td>" + "<a href=" + Chr(34) + linkType$ + Chr(34) + ">" + _constant._type$ + "</a>" + "</td>"
			Else
				s$ = s$ + "<td>" + _constant._type$ + "</td>"
			EndIf
			
			s$ = s$ + "</tr>"
		EndIf
		' Value
		If Len(_constant.value$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Value:" + "</td>"
			s$ = s$ + "<td>" + _constant.value$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf

		' Details
		If Len(sumlines$) > 1 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Details:" + "</td>"
			s$ = s$ + "<td>"
			For Local i:Int = 2 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1]) + "<br>"
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf
		
		s$ = s$ + "</table>"
		output$ = output$ + s$
		output2$ = output2$ + s$
	End Method
	'------------------------------------------------
   	Method OutputFileContent(_file:_tFile)
		If Len(_file.body$)>1 Then
			'_doc.AddToIndex(StripExt(_file.name$), 	_file.name$ + ".html")	
		EndIf
		Local s$=""

		If CountList(_file.classList)>0 Or CountList(_file.functionList)>0 Or CountList(_file.constantList)>0 Or CountList(_file.globalList)>0 Then
			s$ = s$ + "<h3>Table of contents:</h3>"
			' Classes
			If  CountList(_file.classList) <> 0 Then
				_file.classList.Sort()
				s$ = s$ + "<p>Classes:</p>"
				s$ = s$ + "<p><ul>"
				For Local _class:_tClass = EachIn _file.classList
					's$ = s$ + "<li>" + _class.name$
					s$ = s$ + "<li><a href="+Chr(34) + "#" + _class.id + _class.name$ + Chr(34) + ">" + _class.name$ + "</a>"
					If Len(_class.change$) > 0 Then
						s$ = s$ + " &emsp;&emsp;<FONT COLOR="+ Chr(34) + "#FF0000>" + Chr(34) + "   <b>" + _class.change$ + "</b></FONT>"
					EndIf
_doc.AddToIndex(_class.name$, 	_file.name$ + ".html")			
				Next
				s$ = s$ + "</ul></p>"
			EndIf
			' Functions
			If CountList(_file.functionList) <> 0 Then
				_file.functionList.Sort()
				s$ = s$ + "<p>Functions:</p>"
				s$ = s$ + "<p><ul>"
				For Local _func:_tFunction = EachIn _file.functionList
					s$ = s$ + "<li><a href="+Chr(34) + "#" + _func.id + _func.name$ + Chr(34) + ">" + _func.name$ + "</a> &emsp;&emsp;<i>( " + _func.text$ + " )</i>"
					If Len(_func.change$) > 0 Then
						s$ = s$ + " &emsp;&emsp;<FONT COLOR="+ Chr(34) + "#FF0000>" + Chr(34) + "   <b>" + _func.change$ + "</b></FONT>"
					EndIf
_doc.AddToIndex(_func.name$, 	_file.name$ + ".html")			
				Next
				s$ = s$ + "</ul></p>"
			EndIf
			' Constants
			If CountList(_file.constantList) <> 0 Then
				_file.constantList.Sort()
				s$ = s$ + "<p>Constants:</p>"
				s$ = s$ + "<p><ul>"
				For Local _constant:_tConstant = EachIn _file.constantList
					's$ = s$ + "<li>" + _constant.name$ + "<i>   ( "+_constant.text$+" )</i>"
					s$ = s$ + "<li><a href="+Chr(34) + "#" + _constant.id + _constant.name$ + Chr(34) + ">" + _constant.name$ + "</a><i>   ( " + _constant.text$ + " )</i>"
					If Len(_constant.change$) > 0 Then
						s$ = s$ + " &emsp;&emsp;<FONT COLOR="+ Chr(34) + "#FF0000>" + Chr(34) + "   <b>" + _constant.change$ + "</b></FONT>"
					EndIf
_doc.AddToIndex(_constant.name$, 	_file.name$ + ".html")			
				Next
				s$ = s$ + "</ul></p>"
			EndIf
			' Globals
			If CountList(_file.globalList) <> 0 Then
				_file.globalList.Sort()
				s$ = s$ + "<p>Globals:</p>"
				s$ = s$ + "<p><ul>"
				For Local _global:_tGlobal = EachIn _file.globalList
					's$ = s$ + "<li>" + _global.name$ + "<i>   ( "+_global.text$+" )</i>"
					s$ = s$ + "<li><a href="+Chr(34) + "#" + _global.id + _global.name$ + Chr(34) + ">" + _global.name$ + "</a><i>   ( " + _global.text$ + " )</i>"
					If Len(_global.change$) > 0 Then
						s$ = s$ + " &emsp;&emsp;<FONT COLOR="+ Chr(34) + "#FF0000>" + Chr(34) + "   <b>" + _global.change$ + "</b></FONT>"
					EndIf
_doc.AddToIndex(_global.name$, 	_file.name$ + ".html")			
				Next
				s$ = s$ + "</ul></p>"
			EndIf
		EndIf
		output$ = output$ + s$
	End Method
	'------------------------------------------------
   	Method OutputFileEnd()
		output$ = output$ + "<p class=" +Chr(34)+ "footer"+Chr(34)+">This document was generated using the <a href="+Chr(34)+FILEURL$+Chr(34)+">"+FILENAME$+"</a> document generator ( Version "+FILEVERSION$+" )</p>"
		output$ = output$ +"</body>" + "~n"
		output$ = output$ + "</html>" + "~n"
	End Method
	'------------------------------------------------
   	Method OutputFileFooter(_file:_tFile)
		Local s$=""
		Local line$=""
		Local lines$[] 
		lines$ = _file.footer$.Split("~n")
		For line$ = EachIn lines$
			s$ = s$ + line$+"<br>"
		Next
		output$ = output$ + FormatBBCode(s$)
	End Method
	'------------------------------------------------
   	Method OutputFileFunction(_func:_tFunction)
		Local s$=""
		Local s2$=""
		Local sumlines$[]
		s$ = s$ + "<table style=" + Chr(34) + "width: 100%" + Chr(34) + ">"
		s$ = s$ + "<tbody>"
		s$ = s$ + "<tr id=" + Chr(34) + _func.id + _func.name$ + Chr(34) + ">"
		s$ = s$ + "<td class=" +  Chr(34) + "tablehead" + Chr(34) + " colspan=" + Chr(34) + "2" + Chr(34) 
		s$ = s$ + " id=" + Chr(34) + _func.name$ + Chr(34) + ">" + _func.text$ + "</td>"
		s$ = s$ + "</tr>"
	
		' Syntax
		s$ = s$ + "<tr>"
		s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + "><br>Syntax:" + "</td>"
		s$ = s$ + "<td>"
		s$ = s$ + "<br>"
		If Len(_func._type$) > 0 And _func._type$.ToUpper()<>"VOID" Then
			Local linkType2$ = GetClassTypeLink:String(_func._type$.Trim())
			If Len(linkType2$)> 0 Then 
				's$ = s$ + "<b>"  + "<a href=" + Chr(34) + linkType2$ + ".html" + Chr(34)+ ">" + _func._type$.Trim() + "</a></b> = "
				s$ = s$ + "<b>"  + _func._type$.Trim()+ "</b> = "
			Else
				's$ = s$ + "<b>" + _func._type$.Trim()+ "</b> = "
				s$ = s$ + "<b>" + _func._type$.Trim()+ "</b> = "
			EndIf
		EndIf 
		s$ = s$ + "<b>" + _func.name$ + "</b>" + " ("
		If Len(_func.parameter$) > 1 Then
			s$ = s$ + _func.parameter$ 
		EndIf
		s$ = s$ + ")"
		s$ = s$ + "</td>"
		s$ = s$ + "</tr>"

		s2$ = s2$ + "# Function " + _func.name$ + ":" + _func._type$ + "(" + _func.parameter$ + ")" + "~n~n"
		
		' Changes
		If Len(_func.change$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Changes:" + "</td>"
			sumlines$ = _func.change$.Split("~n")
			s$ = s$ + "<td>"
			For Local i:Int = 1 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1]) + "<br>"
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf
		
		' Description
		If Len(_func.summery$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Description:" + "</td>"
			sumlines$ = _func.summery$.Split("~n")
			s$ = s$ + "<td>" + FormatBBCode(sumlines$[0]) + "</td>"
			s$ = s$ + "</tr>"
			s2$ = S2$ + FormatMarkUpCode("*Description*")+"~n~n"
			s2$ = s2$ + FormatMarkUpCode(sumlines$[0]) + "~n~n"

		EndIf
		
		' Return type
		If Len(_func._type$) > 0 And _func._type$.ToUpper()<>"VOID" Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Return type:" + "</td>"
			'Determine the typelink
			Local linkType$ = GetClassTypeLink:String(_func._type$.Trim())
			If Len(linkType$) > 0 Then 
				linkType$ = linkType$ + ".html"
				s$ = s$ + "<td>" + "<a href=" + Chr(34) + linkType$ + Chr(34) + ">" + _func._type$ + "</a>" + "</td>"
			Else
				s$ = s$ + "<td>" + _func._type$ + "</td>"
			EndIf
			
			s$ = s$ + "</tr>"
		EndIf


		' Parameters
		If Len(_func.parameter$) > 1 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Parameters:" + "</td>"
			s$ = s$ + "<td>"
		s$ = s$ + "<table  border=" + Chr(34) + "0" + Chr(34) + Chr(34) + " width:100%" + Chr(34) + " class=" + Chr(34) + "subtable" + Chr(34) +">"
		's$ = s$ + "<table  class=" + Chr(34) + "gridtable" + Chr(34) + Chr(34) + " width:100%" + Chr(34) + ">"
		s$ = s$ + "<tr>"
		s$ = s$ + "<th>Name</th><th>Type</th><th>Value</th>"
		s$ = s$ + "</tr>"
			For Local _para:_tParameter = EachIn _func.parameterList
		s$ = s$ + "<tr>"
		s$ = s$ + "<td>"
				s$ = s$ + _para.name$
		s$ = s$ + "</td>"
		s$ = s$ + "<td>"
				If Len(_para._type$) > 0 Then 
					'Determine the typelink
					Local linkType$ = GetClassTypeLink:String(_para._type$.Trim())
					If Len(linkType$) > 0 Then 
						linkType$ = linkType$ + ".html"
						's$ = s$ + " : " + "<a href=" + Chr(34) + linkType$ + Chr(34) + ">" + _para._type$ + "</a>"
						s$ = s$ + "<a href=" + Chr(34) + linkType$ + Chr(34) + ">" + _para._type$ + "</a>"
					Else
						's$ = s$ + " : " + _para._type$
						s$ = s$ + _para._type$
					EndIf
					
				EndIf
		s$ = s$ + "</td>"
		s$ = s$ + "<td>"
				'If Len(_para.value$) > 0 Then s$ = s$ + " = " + _para.value$
				If Len(_para.value$) > 0 Then s$ = s$ + _para.value$
				's$ = s$ + "<br>"
		s$ = s$ + "</td>"
		s$ = s$ + "</tr>"
			Next
		s$ = s$ + "</table>"
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf

		
		
		' Details
		If Len(sumlines$) > 1 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Details:" + "</td>"
			s$ = s$ + "<td>"
			s2$ = S2$ + FormatMarkUpCode("*Details*")+"~n~n"

			For Local i:Int = 2 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1]) + "<br>"
				s2$ = s2$ + FormatBBCode(sumlines$[i-1]) + "~n~n"
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf
		
		' Code
		Local ccd$ = CurrentDir()
		ChangeDir(codedir$+tilde$)

		If FileType("_" + _func.name$ + ".monkey")=1 Then
			Local srcCode$=LoadText("_" + _func.name$ + ".monkey")
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Example:" + "</td>"
			s$ = s$ + "<td>"
			s$ = s$ + "<pre>" + srcCode$
			s$ = s$ + "</pre>"
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
			
			s2$ = s2$ + "Example:" + "~n~n"
			s2$ = s2$ + "<pre>" + "~n"
			s2$ = s2$ + srcCode$ + "~n"
			s2$ = s2$ + "</pre>" + "~n"
		EndIf
		ChangeDir(ccd$)
		
		' SeeAlso
		If Len(_func.seeAlso$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">See also:" + "</td>"
			sumlines$ = _func.seeAlso$.Split(",")
			s$ = s$ + "<td>"
			s2$ = s2$ + "Links: "
			For Local i:Int = 1 To Len(sumlines$)
				's$ = s$ + FormatBBCode(sumlines$[i-1].Trim())
				s$ = s$ + "<a href="+Chr(34) + "#" + FormatBBCode(sumlines$[i-1].Trim()) + Chr(34) + ">" + "<b>" + FormatBBCode(sumlines$[i-1].Trim()) + "</b>" + "</a>"
				s2$ = s2$ + "[[" + FormatBBCode(sumlines$[i-1].Trim()) + "]]"
				If i < Len(sumlines$) Then 
					s$ = s$ + " , "
					s2$ = s2$ + ", "
				EndIf					
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
			
			'Links: [[Resource paths]], [[File formats]], [[CreateImage]], [[Image.DefaultFlags]], [[Image.GrabImage]]
			s2$ = s2$  + "~n~n"

		EndIf
		
				
		s$ = s$ + "</table>"
		output$ = output$ + s$
		output2$ = output2$ + s2$
	End Method
	'------------------------------------------------
   	Method OutputFileGlobal(_global:_tGlobal)
		Local s$=""
		Local s2$=""
		Local sumlines$[]
		s$ = s$ + "<table style=" + Chr(34) + "width: 100%" + Chr(34) + ">"
		s$ = s$ + "<tbody>"
		s$ = s$ + "<tr id=" + Chr(34) + _global.id + _global.name$ + Chr(34) + ">"
		s$ = s$ + "<td class=" +  Chr(34) + "tablehead" + Chr(34) + " colspan=" + Chr(34) + "2" + Chr(34) 
		s$ = s$ + " id=" + Chr(34) + _global.name$ + Chr(34) + ">" + _global.text$ + "</td>"
		s$ = s$ + "</tr>"

		s2$ = s2$ + "# Method " + _global.name$ + ":" + _global._type$ + "~n~n"

		' Changes
		If Len(_global.change$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Changes:" + "</td>"
			sumlines$ = _global.change$.Split("~n")
			s$ = s$ + "<td>"
			For Local i:Int = 1 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1]) + "<br>"
			Next
			s$ = s$ + "</tr>"
		EndIf

		' Description
		If Len(_global.summery$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Description:" + "</td>"
			sumlines$ = _global.summery$.Split("~n")
			s$ = s$ + "<td>" + FormatBBCode(sumlines$[0]) + "</td>"
			s$ = s$ + "</tr>"
			s2$ = s2$ + FormatMarkUpCode(_global.summery$) + "~n~n"
		EndIf
		' Type
		If Len(_global._type$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Type:" + "</td>"
			
			'Determine the typelink
			Local linkType$ = GetClassTypeLink:String(_global._type$.Trim())
			If Len(linkType$) > 0 Then 
				linkType$ = linkType$ + ".html"
				s$ = s$ + "<td>" + "<a href=" + Chr(34) + linkType$ + Chr(34) + ">" + _global._type$ + "</a>" + "</td>"
			Else
				s$ = s$ + "<td>" + _global._type$ + "</td>"
			EndIf
			
			s$ = s$ + "</tr>"
		EndIf
		' Value
		If Len(_global.value$) > 0 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Value:" + "</td>"
			s$ = s$ + "<td>" + _global.value$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf

		' Details
		If Len(sumlines$) > 1 Then
			s$ = s$ + "<tr>"
			s$ = s$ + "<td style=" + Chr(34) + "width:90px" + Chr(34) + ">Details:" + "</td>"
			s$ = s$ + "<td>"
			For Local i:Int = 2 To Len(sumlines$)
				s$ = s$ + FormatBBCode(sumlines$[i-1]) + "<br>"
			Next
			s$ = s$ + "</td>"
			s$ = s$ + "</tr>"
		EndIf

		s$ = s$ + "</table>"
		output$ = output$ + s$
		output2$ = output2$ + s$
	End Method
	'------------------------------------------------
   	Method OutputFileNav(_file:_tFile)
		Local s$=""
		Local line$=""
		Local lines$[] 
		lines$ = _file.nav$.Split("~n")
		For line$ = EachIn lines$
			s$ = s$ + line$+"<br>"
		Next
		output$ = output$ + FormatBBCode(s$)
	End Method
	'------------------------------------------------
   	Method OutputFileHeader(_file:_tFile)
		Local s$=""
		Local s2$=""
		Local line$=""
		Local lines$[] 
		lines$ = _file.header$.Split("~n")
		For line$ = EachIn lines$
			s$ = s$ + line$+"<br>"
			s2$ = s2$ + line$+"~n~n"
		Next
		output$ = output$ + FormatBBCode(s$)
'Print s2$
		output2$ = output2$ + FormatMarkUpCode(s2$)
'Print FormatMarkUpCode(s2$)		
	End Method
	'------------------------------------------------
   	Method OutputFileImport(_import:_tImport)
		Local s$=""
		Local s2$=""
		Local sumlines$[]
		If Left(_import.name$,1)<>"" Then
			s2$ = s2$ + "# Import " + _import.name$ + "~n~n"
		EndIf
		output$ = output$ + s$
		output2$ = output2$ + s2$
	End Method
	'------------------------------------------------
   	Method OutputFileStart(_file:_tFile, d:String, f:String)
		Local s$=""
		's$ = LoadText(AppDir+tilde$+"htmlheader.txt")+"~n"
'Print (d+";"+f)		
		s$ = LoadText("incbin::htmlheader.txt")+"~n"
		If ExtractExt$( f$ ) = "monkey"
			f$ = StripDir(ExtractDir(d )) + "." + StripExt$( f$ )
			s$ = s$ + "<title>" + f$ + "</title>" + "~n"
			s$ = s$ +"</head>" + "~n"
			s$ = s$ + "<body>" + "~n"
			s$ = s$ + "<h2>Module "+ f$ + "</h2>"
		Else
			If _file.outputname$="" Then
				f$ = StripExt$( f$ )
				s$ = s$ + "<title>" + f$ + "</title>" + "~n"
			Else
				s$ = s$ + "<title>" + _file.outputname$ + "</title>" + "~n"
			EndIf
			s$ = s$ +"</head>" + "~n"
			s$ = s$ + "<body>" + "~n"
			If _file.outputname$="" Then
				s$ = s$ + "<h2>File "+ StripExt$( f$ ) + ".html</h2>"
			EndIf
		EndIf
		output$ = output$ + s$
		output2$ = output2$ + "# Module " + ExtractExt( f$) + "~n~n" 
		
	End Method
	
	'------------------------------------------------
   	Method OutputDocs()
Print ("...creating Doc files... ")
		
		'Create directory
		htmldir$ = startDir$+"docs"
		monkeydocdir$ = startDir$+"monkeydoc"
		codedir$ = startDir$+"docCode"
		' Creating the monkeydoc folder
		If FileType(monkeydocdir$) <> 2 Then
DebugLog ("...creating the monkeydoc folder")
			Local success = CreateDir(monkeydocdir$)
			If Not success RuntimeError ("error creating directory "+monkeydocdir$)
		Else
			Local monkeydocfiles$[] = LoadDir(monkeydocdir$)
			For Local monkeydocfiles$ = EachIn monkeydocfiles$
				Local successd = DeleteFile(monkeydocdir$+tilde$+monkeydocfiles$)
DebugLog ("…deleting file "+monkeydocdir$+tilde$+monkeydocfiles$)
				If Not successd RuntimeError ("error deleting file "+monkeydocfiles)
			Next
		EndIf	
		
		' Creating the html docs folder
		If FileType(htmldir$) <> 2 Then
DebugLog ("...creating the docs folder")
			Local success = CreateDir(htmldir$)
			If Not success RuntimeError ("error creating directory "+htmldir$)
		Else
			Local docfiles$[] = LoadDir(htmldir$)
			For Local docfile$ = EachIn docfiles$
'Print(htmldir$+tilde$+docfile$)
				Local successd = DeleteFile(htmldir$+tilde$+docfile$)
DebugLog ("…deleting file "+htmldir$+tilde$+docfile$)
				If Not successd RuntimeError ("error deleting file "+docfile$)
			Next
		EndIf	
		
		'Copy the css style file to the destination folder
		If FileType(htmldir$+tilde$+"style.css" ) = 0 Then
DebugLog ("...copying styles file "+AppDir+tilde$+"style.css to "+htmldir$)
			CopyFile( AppDir+tilde$+"style.css",htmldir$+tilde$+"style.css" )		
		EndIf
		
		'Sort the file list
		Self.fileList.Sort()
		
'****************************************************************************************************
		'Loop through all files
		For Local file:_tFile = EachIn Self.fileList

DebugLog ("Create HTML file for " + file.name$ + " (" + file.path$+")  ID="+file.id)
			currFile = file
			'Clear output
			output$=""
			outputStart$=""
			output2$=""
			outputStart2$=""
			
			'Write start of the file
			OutputFileStart(file, file.path$, file.name$)
			outputStart$ = output$
			outputStart2$ = output2$

			output$=""
			output2$=""
			
			'Write Navigation
			If Len(file.nav$)>0 Then
DebugLog ("Nav in "+file.name$+": " + file.nav$)
				OutputFileNav(file)
			EndIf
			
			'Write HEADER text
			If Len(file.header$)>0 Then
DebugLog ("Header in "+file.name$+": " + file.header$)
				OutputFileHeader(file)
			EndIf
			
			'Write output file body
			If (file.body$)>0 Then OutputFileBody(file)
			
			'Now write out the table of content
			OutputFileContent(file)

			'****************************************************************************************************
			'Imports
			file.importList.Sort()
			For Local _import:_tImport = EachIn file.importList
DebugLog ("   Import " + _import.name$ + "  ID="+_import.id )
				OutputFileImport(_import)
			Next	
			
			'Globals
			file.globalList.Sort()
			For Local _global:_tGlobal = EachIn file.globalList
DebugLog ("   Global " + _global.name$ + " : " + _global._type$+" = "+_global.value$ + "  ID="+_global.id+"      "+_global.summery$)
				OutputFileGlobal(_global)
			Next	
			
			'Constants
			file.constantList.Sort()
			For Local constant:_tConstant = EachIn file.constantList
DebugLog ("   Constant " + constant.name$ + " : " + constant._type$+" = "+constant.value$+"  ID="+constant.id+"      "+constant.summery$)
				OutputFileConstant(constant)
			Next	
			
			'Functions
			file.functionList.Sort()
			For Local func:_tFunction = EachIn file.functionList
DebugLog ("   Function " + func.name$ + " : " + func._type$+"("+func.parameter$+")  ID="+func.id+"      "+func.summery$)
				'Parameter of Methods
				For Local funcparameter:_tParameter = EachIn func.parameterList
DebugLog ("      Parameter " + funcparameter.name$ + " : " + funcparameter._type$+" = "+funcparameter.value$+"  ID="+funcparameter.id)
				Next
				OutputFileFunction(func)	
			Next	
			'Classes
			file.classList.Sort()
			For Local class:_tClass = EachIn file.classList
DebugLog ("   Class " + class.name$ + " extends " + class._extends$+"  ID="+class.id+"      "+class.summery$)
				OutputFileClass(class)
			Next	
			
			'Write FOOTER text
			If Len(file.footer$)>0 Then
DebugLog ("Footer in "+file.name$+": " + file.footer$)
				OutputFileFooter(file)
			EndIf
			
			' Save HTML doc file
			'If file.outputname$="" Then
				htmlfile$ = htmldir$+tilde$+file.name$+".html"
			'Else
			'	htmlfile$ = htmldir$+tilde$+file.outputname$
			'EndIf
			
			If Len(output$) > 0 Then

				output$ = outputStart$ + output$
				'Write file footer
				OutputFileEnd()
				If file.outputname$="" Then
Print ("Writing HTML file "+htmlfile$)
					SaveText(output$,htmlfile$)
					_doc.AddToIndex(StripExt(file.name$), 	StripDir(htmlfile$))
				Else
Print ("Writing file "+htmldir$+tilde$+file.outputname$+"     ("+file.name$+")")
					SaveText(output$,htmldir$+tilde$+file.outputname$)
					_doc.AddToIndex(StripExt(file.name$), 	StripDir(htmldir$+tilde$+file.outputname$))
				EndIf
			EndIf
			' Save monkeydoc  file
			If ExtractExt(file.name$)="monkey"
				If ExtractExt(file.name$)="monkey"
					monkeydocfile$ = monkeydocdir$+tilde$+file.name$+"doc"
				Else
					monkeydocfile$ = monkeydocdir$+tilde$+StripExt(file.name$)+".monkeydoc"
				EndIf
				If Len(output2$) > 0 Then
	
					output2$ = outputStart2$ + output2$
					'Write file footer
					'OutputFileEnd()
Print ("Writing monkeydoc file "+monkeydocfile$)
					SaveText(output2$,monkeydocfile$)
				EndIf
			EndIf
			
		Next
		Notify("Doc files are created!")	
Rem		
		'Create index file
		Self.indexList.Sort()
		Local in%=1
		Local lc%=0
		Local lastC$=""
		For Local _index$ = EachIn Self.indexList
			lc = lc + 1
			Local i$[] = _index$.Split(":")
			If i$[0] <> lastC$ Then 
				lastC$ = i$[0]
				in%=1
			Else 
				in% = in% + 1
			EndIf
			_doc.index$ = _doc.index$ + i$[0]
			If in% = 1 Then
				 _doc.index$ = _doc.index$ + ":" + i$[1] + "#" + i$[0]
			Else
				 _doc.index$ = _doc.index$ + " (" + in% + "):" + i$[1] + "#" + i$[0]
			EndIf
			If lc < Self.indexList.Count() Then _doc.index$ = _doc.index$ + "~n"
		Next
'Print ("lc="+lc+"    count="+indexList.Count())
		SaveText(index$,htmldir$+tilde$+"index.txt")
EndRem		
	End Method
	
	
	'------------------------------------------------
   	Method New()
		fileList = New TList
		classTypeList = New TList
		indexList = New TList
	End Method
	'------------------------------------------------
   	Method Create:_tDocu(dir:String)
		_doc = Self
		startDir$ = dir$
		ChangeDir( startDir$ )
		files$ = LoadDir(startDir$)	


		subfiles$ = LoadDir(startDir$+"docParse")	
DebugLog ("Files in docParse directory = "+Len(subfiles$))
		For subfile$ = EachIn subfiles$
			If FileType("docParse\"+subfile$) = 1 And ExtractExt("docParse\"+subfile$)="txt" Then 
				Self.currFile  = New _tFile.Create(startDir$+"docParse\", subfile$)
				Self.currFile.link = ListAddLast(Self.fileList, Self.currFile )
				Self.currFile.Parse()
			EndIf
		Next	




	'Print("startdir="+startDir$)
DebugLog ("Files in directory = "+Len(files$))
		For file$ = EachIn files$
Print ("file="+file$)		
			If FileType(file$) = 1 And ExtractExt(file$)="monkey" Then 
				Self.currFile  = New _tFile.Create(startDir$, file$)
				Self.currFile.link = ListAddLast(Self.fileList, Self.currFile )
				Self.currFile.Parse()
			EndIf
		Next
		
		Return Self
	End Method
	
End Type


'------------------------------------------------
Function _GetSummery:String()
	Local ret$ = _currSummery$
	_currSummery$ = ""
	Return ret$
End Function

'------------------------------------------------
Function _GetChange:String()
	Local ret$ = _currChange$
	_currChange$ = ""
	Return ret$
End Function

'------------------------------------------------
Function _GetSeeAlso:String()
	Local ret$ = _currSeeAlso$
	_currSeeAlso$ = ""
	Return ret$
End Function

'------------------------------------------------
Function _GetID:Int()
	_id = _id + 1
	Return _id
End Function

'***************************************************
Function AddLine(t:String)
	'output$ = output$ + t$
	'output$ = output$ + "~n"
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
Local startDir$ = RequestDir("Choose folder to document...", startDir_old$)
If Len(startDir$) <= 1 Then End
startDir$ = startDir$ + tilde$
SaveLastDir(FILENAME$+".ini", startDir$)



Print ""
Print "--------------------------------------------------"
Print FILENAME$+" "+FILEVERSION$
Print "--------------------------------------------------"

Print "Documenting folder... " + startDir$

Global doc:_tDocu = New _tDocu.Create(startDir$)
doc.OutputDocs()

Print "..finished documenting folder " + startDir$



 











