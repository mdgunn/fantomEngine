Method OnCreate:Int()
        'Create the instance of the engine
        Local eng:ftEngine = New ftEngine

        ' Create now the object
        Local zonebox:ftObject = eng.CreateZoneBox(20, 100, 320, 240)
        Return 0
End