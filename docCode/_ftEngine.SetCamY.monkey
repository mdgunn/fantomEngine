Method OnUpdate:Int()
    ' Determine the update factor depending on the delta time
    Local d:Float = Float(myEngine.CalcDeltaTime())/60.0

    ' Update the engine
    myEngine.Update(Float(d))

    ' Determine the player X-position
    Local ypos:Float = player.GetPosY()
    
    ' Now set the camera accordingly so the player is always in the middle of the canvas
    eng.SetCamY(ypos - eng.GetCanvasHeight()/2)

    Return 0
End