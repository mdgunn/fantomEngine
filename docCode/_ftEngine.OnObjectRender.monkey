' The engine class extends the ftEngine class to override the On... methods
Class engine Extends ftEngine
	Method OnObjectRender:Int(obj:ftObject)
	        ' Check if the group ID of the object is 222
	        If obj.GetGroupID() = 222 Then
	
	                ' Set alpha to 0.5
	                mojo.SetAlpha(0.5)
	                
	                ' Determine the position of the object
	                Local pos[]:Float = obj.GetPos()
	
	                ' Draw a circle at the objects position and set the alpha back to 1.0
	                mojo.DrawCircle (pos[0], pos[1], 30.0)
	                mojo.SetAlpha(1.0)
	
	        Endif
	        Return 0
	End
End