Method OnCreate:Int()
        ' Create an instance of the engine
        eng = New engine
        
        ' Create an image object
        Local obj:ftObject = eng.CreateImage("spaceship.png", 40, 100)
        
        ' Set the collision type to rotated box collision
        obj.SetcolType(ftEngine.ctBox)
        Return 0
End