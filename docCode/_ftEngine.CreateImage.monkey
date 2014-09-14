Method OnCreate:Int()
        ' Create an instance of the engine
        eng = New engine
        
        ' Create an image object
        Local obj:ftObject = eng.CreateImage("spaceship.png", 40, 100)

        ' Preload an image
        Local tpatlas:Image = mojo.LoadImage("spritesheet.png")

        ' Create an object from a TexturePacker sprite sheet
        Local obj:ftObject = eng.CreateImage(tpatlas, "PackerFileName.txt", "SpaceShip", 320, 240)
       
        Return 0
End

Class engine Extends ftEngine
        ' ...
End