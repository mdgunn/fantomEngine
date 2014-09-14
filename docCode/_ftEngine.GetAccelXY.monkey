Method OnUpdate:Int()
    ' Determine the update factor depending on the delta time
    Local d:Float = Float(myEngine.CalcDeltaTime())/60.0

    ' Update the engine
    myEngine.Update(Float(d))

    ' Here is where you check the accelerometer values
    Local acxy:Float[] = eng.GetAccelXY()

    Return 0
End