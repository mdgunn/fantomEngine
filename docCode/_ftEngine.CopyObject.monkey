' Create the 1st object in the middle of the screen
Local obj1 := eng.CreateBox(20, 20, cw/2, ch/2 )

' Copy the 1st object, which creates the 2nd object
Local obj2 := eng.CopyObject(obj1)