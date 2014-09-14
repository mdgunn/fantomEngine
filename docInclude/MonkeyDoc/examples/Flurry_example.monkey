Strict

#rem
	Script:			Flurry_example.monkey
	Description:	Sample script to show how to use Flurry on the Android or IOS platform 
	Author: 		Michael Hartlef
	Version:      	1.11
	License:		MIT
#End

Import mojo
Import flurry

#If TARGET="android"

#FLURRY_APIKEY="DH9JR2PZBWF2NB2MZ6TJ"				'your Flurry API key

#Else

#FLURRY_APIKEY="S2HCQRQXRS63KV8FV3X2"				'your Flurry API key

#End


Class MyApp Extends App

	Field flurry:Flurry
	Field eventCount:Int = 0
	Field ch:Int
	Field ended:Bool = False
	
	Method OnCreate:Int()
		flurry=Flurry.GetFlurry()
		flurry.onStartSession()
		ch = DeviceHeight()
		SetUpdateRate 60
		Return 0
	End
	
	Method OnUpdate:Int()
		If TouchHit( 0 ) And ended = False Then
			If TouchY(0) < ch/2
				eventCount += 1
				Print("Log Event count #"+eventCount)	
				'flurry.logEvent("Event #"+eventCount)
				'flurry.logEvent("Event #"+eventCount,True)
				'flurry.logEvent("Event with params",["Value1", "Key1", "Value2", "Key2"])
				flurry.logEvent("Event with params",[eventCount, "Count#", "Michael", "PlayerName"], True)
			Else
				ended = True
				Print("flurry.onEndSession()")
				flurry.onEndSession()
			Endif
		Endif
		Return 0
	End
	
	Method OnRender:Int()
		Cls
		DrawLine(0,ch/2,DeviceWidth(),ch/2)
		DrawText "Click above the line to log an event in Flurry.",20,20
		DrawText "Click below the line to end the Flurry session.",20, ch/2 + 40
		Return 0
	End
	
End

Function Main:Int()
	New MyApp
	Return 0
End