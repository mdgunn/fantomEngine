Local myEngine = New cEngine

' Create a constant for the timer ID
Const circleTimerID:Int = 222

' Create now the object
Local circle:ftObject = myEngine.CreateCircle(100, 320, 240)

' Create a timer for the circle that fires after 3000 milliseconds
Local myObjTimer := myEngine.CreateObjTimer(circle, circleTimerID, 3000)

'***************************************
' The cEngine class extends the ftEngine class to override the On... methods
Class cEngine Extends ftEngine
	Method OnObjectTimer:Int(timerId:Int, obj:ftObject)
		If timerId = circleTimerID
			' Remove the object
			obj.Remove()
		Endif
		Return 0
	End	
End
