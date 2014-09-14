Method OnUpdate:Int()
        ' Calculate the time (in milliseconds) since the last update and devide it by 60.0
        Local mySpeed:Float = Float(eng.CalcDeltaTime())/60.0

        'Now update all objects of the engine with the given speed factor
        eng.Update(mySpeed)

        Return 0
End