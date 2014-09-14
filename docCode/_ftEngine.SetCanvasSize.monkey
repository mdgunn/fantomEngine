Method OnCreate:Int()
        ' Create an instance your engine class
        eng = New engine

        ' Set the virtual size to 800x600 and let the engine do letterbox scaling if needed
        eng.SetCanvasSize(800, 600, eng.cmLetterbox)
        Return 0
End