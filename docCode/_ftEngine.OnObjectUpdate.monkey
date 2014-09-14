' The engine class extends the ftEngine class to override the On... methods
Class engine Extends ftEngine
	Method OnObjectUpdate:Int(obj:ftObject)
	        'Move the object 10 pixels to the right
	        obj.SetPos(10.0, 0.0, True)
	
	        Return 0
	End
End