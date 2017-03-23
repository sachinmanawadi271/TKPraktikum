#include, Gdip.ahk 

f5:: 
  try{
    ppt := ComObjActive("PowerPoint.Application")
	objppt := ppt.ActivePresentation
	TotalSlides:=% objppt.Slides.Count
	FileCreateDir, temp
  }
  catch e {
	MsgBox % "Error in " e.Message ", which was called at line " e.Line 
  }
  ;objppt.Export("C:\Users\SK\Documents\AutoHotKey\temp",FilterName:="png",1366,768)
  ;"C:\Users\SK\Documents\AutoHotKey\temp", "E:\AHK\AutoHotKeyScripts\temp"
  
  ;path = %A_WorkingDir%\temp
  ;objppt.Export(path, FilterName:="png",1366,768)
  
  ;Loop %TotalSlides%{
	;var++
	;MsgBox %var%
	;saveppt := objppt.Slides(var).Export(A_ScriptDir . "\temp\" . var . ".png", "PNG",1366,768)
  ;}
  ;pt := ppt.ActivePresentation.(test, ppSaveAsPNG)
  SysGet, MonitorCount, MonitorCount
  ;MsgBox %MonitorCount%
  ;MsgBox saved
  ;MsgBox inside %MonitorCount%
  ppt := objppt.SlideShowSettings
  ppt.Run
  ;monitorDisplay(objppt, MonitorCount)
Return

Right::
	SlideNum :=% objppt.SlideShowWindow.View.Slide.SlideIndex
	;MsgBox %SlideNum%
	saveScreenshot(SlideNum)
	;saveppt := objppt.Slides(SlideNum).Export(A_ScriptDir . "\temp\" . SlideNum . ".png", "PNG",1366,768)
	objppt.SlideShowWindow.View.Next
	monitorDisplay(objppt, MonitorCount)
	return
	
Left::
	objppt.SlideShowWindow.View.Previous
	monitorDisplay(objppt, MonitorCount)
	return

monitorDisplay(objppt, MonitorCount){
	try{
		CurrentSlideNumber :=% objppt.SlideShowWindow.View.Slide.SlideIndex
		}
	catch{
		FileRemoveDir, temp, 1
		ExitApp
		}
	;MsgBox %CurrentSlideNumber% is the current slide
	monitor := MonitorCount-1
	var2 := 0
	Loop %monitor%{
		;MsgBox insideloop
		var2++
		;MsgBox var2(MonitorNumber) val = %var2%
		setDisplay(var2, CurrentSlideNumber-1)
		CurrentSlideNumber--
		;var2 := 0
		;MsgBox end of Loop monitor var2 = %var2%
	}
}	
	
getCoordinates(MonitorNumber){
	;coord := 1366*MonitorNumber
	if(MonitorNumber = 1)
		return 1920
	if(MonitorNumber = 2)
		return 3286
	;return coord
}

;SetEnv file, C:\Users\SK\Documents\AutoHotKey\1.png

setDisplay(MonitorNumber, PreviousSlideNumber){
global
	coord := getCoordinates(MonitorNumber)
	SetEnv file, %A_WorkingDir%\temp\%PreviousSlideNumber%.png
	;file := "C:\Users\SK\Documents\AutoHotKey\Slide" . %CurrentSlideNumber% . ".png"
	;file := "C:\Users\SK\Documents\AutoHotKey\1.png"
	;MsgBox %coord%,%MonitorNumber%,%PreviousSlideNumber%,%file%
	if(MonitorNumber = "1"){
		Gui, %MonitorNumber%:destroy
		Gui, %MonitorNumber%:+AlwaysOnTop +LastFound +Owner -Caption
		Gui, %MonitorNumber%:Color, Black
		Gui, %MonitorNumber%:Add, Picture, w1366 h-1, %file%	
		Gui, %MonitorNumber%:Show, x%coord% y0 maximize
	}
	if(MonitorNumber = "2"){
		Gui, %MonitorNumber%:destroy
		Gui, %MonitorNumber%:+AlwaysOnTop +LastFound +Owner -Caption
		Gui, %MonitorNumber%:Color, Black
		Gui, %MonitorNumber%:Add, Picture, w1024 h768, %file%	
		Gui, %MonitorNumber%:Show, x%coord% y0 maximize
	}
}

Screenshot(outfile)
{
    pToken := Gdip_Startup()

    screen=0|0|%A_ScreenWidth%|%A_ScreenHeight%
    pBitmap := Gdip_BitmapFromScreen(screen)

    Gdip_SaveBitmapToFile(pBitmap, outfile, 100)
    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
}

saveScreenshot(SlideNumber){
	file := A_WorkingDir . "\temp\" . SlideNumber . ".png"
	Screenshot(file)
}


ESC::
	objppt.SlideShowWindow.View.Exit
	FileRemoveDir, temp, 1
	ExitApp
