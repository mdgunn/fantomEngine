Method OnCreate:Int()
        'Create the instance of the engine
        Local eng:ftEngine = New ftEngine

        ' Create now the object
        Local box:ftObject = eng.CreateBox(20, 100, 320, 240)
        Return 0
End