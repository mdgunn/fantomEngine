
Import os

Const OUTPUT:="fantomEngine_V153_final"

Function LoadDir:String[]( path:String )

	Local dirs:=New StringList
	Local files:=New StringList
	
	dirs.AddLast ""
Print ("path="+path)	
	While Not dirs.IsEmpty()
	
		Local dir:=dirs.RemoveFirst()
Print ("path="+path+dir)	
	
		For Local f:=Eachin os.LoadDir( path+dir )
		
			Local p:=dir+"/"+f
Print ("p="+p)	
		
			files.AddLast p[1..]

			If FileType( path+p )=FILETYPE_DIR dirs.AddLast p
		Next
	Wend

	Return files.ToArray()
End

Function Main()

	Local desktop:=""
	
	If HostOS()="winnt"
		desktop=GetEnv( "HOMEPATH" )+"/Desktop"
	Else
		desktop=GetEnv( "HOME" )+"/Desktop"
	Endif
	
	Local dest:=desktop+"/"+OUTPUT
	
	If FileType( dest )
		Print dest+" already exists!"
		'ExitApp -1
	Endif
	
	CreateDir dest
	If FileType( dest )<>2
		Print "Failed to create dir "+dest
		ExitApp -1
	Endif
	
	Local cd:=CurrentDir()

'Print ("cd1="+cd)

'Print ("FILETYPE cd="+FileType( cd ))	

'Print ("FILETYPE FILETYPE_DIR="+FILETYPE_DIR)	

	'While FileType( cd+"/bin" )<>FILETYPE_DIR
		'cd=ExtractDir( cd )
	'Wend
'Print ("cd2="+cd)	
	Local files:=LoadDir( cd )
	
	Local ignore:=[
		"rebuildall",
		"rebuildall.exe",
		"ted-build-*",
		"brlx",
		".bmx",
		".bak",
		".git",
		".gitignore",
		".DS_Store",
		".Thumbs.db",
		"*.ini",
		"docParse",
		"docInclude",
		"docCode",
		"Tools",
		"main_macos",
		"createrelease",
		"z_cft*",
		"*.build*" ]
	
	For Local f:=Eachin files
	
		Local e:="/"+f+"/"
		Local skip:=False
		For Local t:=Eachin ignore
			skip=True
			If t.StartsWith( "*" )
				If e.Contains( t[1..]+"/" ) Exit
			ElseIf t.EndsWith( "*" )
				If e.Contains( "/"+t[..-1] ) Exit
			Else
				If e.Contains( "/"+t+"/" ) Exit
			Endif
			skip=False
		Next
		If skip Continue
		
		If e.Contains( "/." )
			Print "Skipping unknown hidden file: "+f
			Continue
		Endif
		
		Local src:=cd+"/"+f
		Local dst:=dest+"/"+f
		
		If FileType( src )=FILETYPE_DIR
			'Print "CreateDir: "+dst
			CreateDir dst
		Else
			'Print "CopyFile: "+src
			CopyFile src,dst
		Endif

	Next
	
End
