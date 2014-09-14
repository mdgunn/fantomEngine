' Load the tile map created by Tiled
Local tm := eng.CreateTileMap("yourMap.json", 0, 0 )

' Determine the number of objects included in the map
Print ("Number of map objects = " + tm.GetMapObjCount())

' Iterate through the map objects
For Local moi := 1 To tm.GetMapObjCount()
	Local mo := tm.GetMapObj(moi)
	
	' Determine some of the objects fields/properties
	Print ("obj #"+moi+"   Name="+mo.GetName())
	Print ("obj #"+moi+"   Type="+mo.GetType())
	Print ("obj #"+moi+"   LayerName="+mo.GetLayerName())
	
	If mo.GetType() = "typePolyLine" Then
		Local pl:Float[] = mo.GetPolyLine()
		Print ("length of polyline = "+pl.Length())
		For Local pli:= 1 To pl.Length() Step 2
			Print ("#"+pli+"  = "+pl[pli-1]+":"+pl[pli])
		Next
	Endif
	Print ("")
Next
