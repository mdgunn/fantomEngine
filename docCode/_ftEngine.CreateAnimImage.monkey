Method OnCreate:Int()
        ' Create an instance of the engine
        eng = New engine
        
        ' Preload an image
        Local spriteSheet:Image = mojo.LoadImage("spritesheet.png")

        ' Create an object from a sprite sheet with 4 animation frames
        Local obj:ftObject = eng.CreateAnimImage(spriteSheet, 0, 0, 32, 32, 4, 320, 240)
       
        Return 0
End