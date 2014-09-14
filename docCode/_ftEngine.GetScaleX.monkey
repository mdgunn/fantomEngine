Method OnCreate:Int()
        ' Create an instance your engine class
        eng = New engine
        eng.SetCanvasSize(800, 600)
        sx = eng.GetScaleX()
        sy = eng.GetScaleY()
        Return 0
End