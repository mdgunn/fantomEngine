Method OnUpdate:Int()
  Local delta:Float = Float(myEngine.CalcDeltaTime())/60.0
  myEngine.Update(delta)
  Return 0
End