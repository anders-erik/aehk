
; Screen Recorder - Snipping Tool
; Anders-Erik : 2024-10-12


; - - - - - - - - - - - - - - -
; OVERVIEW
; - Uses the built in snipping tool program 
; - provides shortcuts for 
;   1) Closes open snipping-tools and starts a new session in recording mode  -  (win + ctrl + alt + d )
;   2) Closes open snipping-tools and starts a new session in image mode  -  (win + ctrl + alt + s )
;   3) Starting the recording after selected rectangle  -  (win + ctrl + alt + c )
;   4) Stopping the recording  -  (win + ctrl + alt + c )
;   5) Closing the snipping tool only  -  (win + ctrl + alt + w )
;
; NOTE: used on Windows 11 on a horizontal 1920x1080 primary monitor. 
;       On a different monitor setup the shortcut for starting the recording will most likely not work. 





; - - - - - - - - - - - - - - -
; SHORTCUTS

; Closes any currently running instances and starts snipping in recording mode
; win + ctrl + alt + d 
#^!d:: StartSnippingExeInRecordingMode() 

; Closes any currently running instances and starts snipping in image mode
; win + ctrl + alt + s
#^!s:: StartSnippingExeInImageMode() 

; When app is running this is used in two ways:
; 1. after a rectangle is selected it will trigger the start of a new recording
; 2. during recording it will trigger the app to stop recording
; win + ctrl + alt + c 
#^!c:: StartAndStopRecording()

; Closes any currently running instances of Snipping Tool
; win + ctrl + alt + w
#^!w:: CloseSnippingToolExe()





; - - - - - - - - - - - - - - -
; FUNCTIONS


; Start a new session of Snipping Tool in Recording mode using the built in win+shift+R shortcut.
; Closes any currently running SnippingTool.exe if it exists.
StartSnippingExeInRecordingMode(*) {

    CloseSnippingToolExe()

    Send "#+{R}"
}


; Start a new session of Snipping Tool in Image mode using the built in win+shift+S shortcut.
; Closes any currently running SnippingTool.exe if it exists.
StartSnippingExeInImageMode(*) {

    CloseSnippingToolExe()

    Send "#+{S}"
}

; Make sure snipping tool is closed before starting a new one !
CloseSnippingToolExe(*) {
    if WinExist("Snipping Tool") or WinExist("ahk_exe SnippingTool.exe")
        WinClose ; Uses the window found by WinExis
}



; Moves cursor to a hard-coded top-center location - intended to be called after rectangle selection 
StartRecording(){

    MouseGetPos &clientX, &clientY

    ; Manully set values for snipping on a horizontal primary screen of size 1920x1080
    DllCall("SetCursorPos", "int", 880, "int", 28)

    MouseClick()
    MouseClick()

    ; return cursor to starting position
    DllCall("SetCursorPos", "int", clientX, "int", clientY)
    ; MouseMove clientX, clientY

    return

}


; Moves cursor to the "Recording toolbar" window, clicks, and returns.
StopRecording(){
    ; MsgBox("curently in recording mode.")

    WinGetClientPos &X, &Y, &W, &H, "Recording toolbar"
    MouseGetPos &clientX2, &clientY2
    ;MsgBox "Snipping Tool's client area is at " X "," Y " and its size is " W "x" H

    ; values from trial and error
    clickX := X + 65
    clickY := Y + 35

    DllCall("SetCursorPos", "int", clickX, "int", clickY)

    MouseClick()

    ; return cursor to starting position
    ; DllCall("SetCursorPos", "int", clientX2, "int", clientY2) ; Didn't work !
    MouseMove clientX2, clientY2
}


; Checks if SnippingTool.exe and it's windows are running. Exits if executable not found.
; If the "Snipping Tool" window is found -- try to begin recording.
; If "Recording toolbar" is found instead -- stop recording.
StartAndStopRecording(*) {

    ; Make sure that all expepcted exe's and windows exists
    snipExe := WinExist("ahk_exe SnippingTool.exe")
    snippingWin := WinExist("Snipping Tool") ; Name at all times except when not actively recording
    recordingWin := WinExist("Recording toolbar") ; App name when actively recording


    if !snipExe {
        MsgBox("SnippingTool.exe window not found.")
        return
    }

    if snippingWin {
        StartRecording()
    }
    else if recordingWin {
        StopRecording()
    }
    else {
        MsgBox("No 'Snipping Tool' nor 'Recording toolbar' window found. Unknown 'SnippingTool.exe' window")
    }

}

