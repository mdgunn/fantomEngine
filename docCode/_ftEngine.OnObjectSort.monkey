' The engine class extends the ftEngine class to override the On... methods
Class engine Extends ftEngine
	Method OnObjectSort:Int(obj1:ftObject, obj2:ftObject)
		' This method is called when objects are compared during a sort of its layer list
		
		' We compare the bottom (yPos+Height/2) of each object, the ones with a smaller result will
		' be sort infront of the other object and so appear behind the over object.
		If (obj1.yPos + obj1.GetHeight()/2) < (obj2.yPos + obj2.GetHeight()/2) Then 
			Return False
		Else
			Return True
		Endif
	End	
End
