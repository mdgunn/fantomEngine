Method OnCreate:Int()
        'Create the instance of the engine
        Local eng:ftEngine = New ftEngine

        ' Create now the object
        Local zonecircle:ftObject = eng.CreateZonecircle(50, 320, 240)
        Return 0
End