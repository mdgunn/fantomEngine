' Shooting a shot in the direction of an enemy object
Const shotID:Int = 1234
Const shotID:Int = 9876

' First determine the angle of the enemy object compared to the player
Local targetAngle:Float = playerObj.GetTargetAngle(enemyObj)

' Calculate the starting position of the shot 30 pixels in the direction of the enemy
Local startPos:Float[] = playerObj.GetVector(30.0, targetAngle )

' Create a shot at the center of the player
Local shotObj:ftObject = fE.CreateImage( "shoot.png", startPos[0], startPos[1] )

' Give the shot object an ID so we can identify it later
shotObj.SetID(shotID)

' Set its collision parameters
shotObj.SetColGroup(shotID)
shotObj.SetColWith(enemyID)

' Set the angle of the shot
shotObj.SetAngle(tAngle)

' Give the shot a speed
shotObj.SetSpeed(10)