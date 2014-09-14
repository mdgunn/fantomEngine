Method OnUpdate:Int()
        'Determine the delta time and a update factor for the engines next update
        Local d:Float = Float(eng.CalcDeltaTime())/60.0
        'Update all objects in the engine
        eng.Update(d)
        'Check for collisions of objects 
        eng.CollisionCheck()
        Return 0
End