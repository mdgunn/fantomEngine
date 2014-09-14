Method OnCreate:Int()
        'Create the instance of the engine
        Local eng:ftEngine = New ftEngine

        ' Create now the object
        Local circle:ftObject = eng.CreateCircle(100, 320, 240)
        Return 0
End