Method OnRender:Int()
	Cls
	Local currFPS:Int = myEngine.GetFPS()
	eng.Render()
	DrawText("FPS: "+currFPS, 10,10)
End
	