Method OnUpdate:Int()
    ' Determine the update factor depending on the delta time
    Local d:Float = Float(myEngine.CalcDeltaTime())/60.0

    ' Update the engine
    myEngine.Update(Float(d))

    ' Determine the player X-position
    Local xpos:Float = player.GetPosX()
    
    ' Now set the camera accordingly so the player is always in the middle of the canvas
    eng.SetCamX(xpos - eng.GetCanvasWidth()/2)

    Return 0
End