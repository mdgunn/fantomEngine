Method OnUpdate:Int()
    ' Determine the update factor depending on the delta time
    Local d:Float = Float(myEngine.CalcDeltaTime())/60.0

    ' Update the engine
    myEngine.Update(Float(d))

    ' Determine the player position
    Local pos:Float[] = player.GetPos()
    
    ' Now set the camera accordingly so the player is always in the middle of the canvas
    eng.SetCam(pos[0] - eng.GetCanvasWidth()/2, pos[1] - eng.GetCanvasHeight()/2)

    Return 0
End