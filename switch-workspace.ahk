#Requires AutoHotkey v2.0

; Switch Workspace Hotkeys - Left Win-Key
; Anders-Erik : 2024-10-12


; OVERVIEW
;   - enabling the switching of workspaces using the following hotkeys:
;       - alt+Lwin+left/right arrow
;       - Lwin + wheel
;       - Lwin + alt + wheel
;       - Lwin + ctrl + wheel
;
; TODO
;   - Keep a longer list of recently focused windows
;   - Do some desktop id/name/title detection to give the script more state information
;       - also so I can better understand the state of the swtihcing and available windows!
;   - make sure behavior is stable when switching to a desktop containing no windows in the focusable substring array
;
; BUGS
;   [RESOLVED] : I had forgotten to clear the map, thus persisting the all title of all desktop I had visited
;   1. Sometimes Windows are detected when switching to a desktop they are not part of
;       - sometimes focuses on windows when switching between two desktops without the app..


; Set current window id -- 
; currentWindowId := WinExist("A")
IniWrite WinExist("A"), "C:\tmp\switch-workspace.ini", "section1", "currentWindowId"


; Array of apps to focus on if substring is found in windows title.
; In order of importance -- does not work currently because 'WinGetList' determines order/
focusApps := [
    "code", 		    ; VSCode has highest priority
	"visual studio",    ; VSCode & Visual Studio
	"firefox",
    "google chrome",    ; some electron apps also has chrome in them!
    "ubuntu",
    "shell",
    "command",
    "File",
    "chrome",           ; some electron apps also has chrome in them!
    "spotify",          ; Only containes spotify if no music is playing...
]

; Matched Apps for focus : format = substring-id
; Example:  `matchedApps["firefox"] = 3`
matchedApps := Map()


; Array of apps NOT to focus on if substring is found in windows title
; Takes precedence over focusApps-array.
ignoreApps := [
    "autohotkey v2.",
]


; Matches visable windows on current desktop to list of app-names.
; If ther is a match -- focus.
MatchFocusApps(){
    matchedApps.Clear()

    ids := WinGetList(,, "Program Manager")
    winListTitles := ""
    for this_id in ids
    {
        ; WinActivate this_id
        this_class := WinGetClass(this_id)
        this_title := WinGetTitle(this_id)
        winListTitles .= "this_id=" . this_id . " : " . this_title . "`n"

        ; Ignore
        Loop ignoreApps.Length{
            if( InStr(this_title, ignoreApps[A_Index]) ){
                continue
            }
        }

        ; Focus
        Loop focusApps.Length{
            
            substring := focusApps[A_Index]
            if( InStr(this_title, substring) ){
                ; Associates each focus substring with the window id
                matchedApps[substring] := this_id
                
                ; MsgBox "Focus on : " . this_title
            }
        }

        ; ; PRINT WINDOW INFO

        ; Result := MsgBox(
        ;     (
        ;         "Visiting All Windows
        ;         " A_Index " of " ids.Length "
        ;         ahk_id " this_id "
        ;         ahk_class " this_class "
        ;         " this_title "
        
        ;         Continue?"
        ;     ),, 4)
        ;     if (Result = "No")
        ;         return

    }

    ; MsgBox winListTitles ; Print info for all windows of current method call
    ; MsgBox "matchedApps.Count = " . matchedApps.Count
    
    ; Focus on the window with highest priority
    ; If there are no mathing windows, focus on the first available id
    if(matchedApps.Count > 0)
        FocusApp()
    else
        WinActivate ids[0]


}


; Focus on the matched window with the highest priority.
; Loops through the constant array of focusable apps and checks if they have a matching KV-pair in the matches-map.
FocusApp(){
    ; TrayTip("Yello")

    ; step through array in order, thus enforcing the statement that substring earlier in the list are prioritized
    Loop focusApps.Length{
        
        substring := focusApps[A_Index]

        ; substring has previously recieved a match -- try setting new focus
        if( matchedApps.Has(substring) ){
            ; MsgBox "Matched substring: " . substring

            currentWindowId := IniRead("C:\tmp\switch-workspace.ini", "section1", "currentWindowId")
            matchedId := matchedApps.Get(substring)
            
            ; INFO
            ; MsgBox  "id                 = " . matchedId . 
            ;         "`nWinActive        = " . WinActive() . 
            ;         "`ncurrentWindowId  = " . currentWindowId
            
            ; MsgBox "Focus index " . A_Index . " :  `nTitle = " . WinGetTitle(matchedId) . "`n"

            
            ; If no manually registered window is set, then we make sure to set to a good, focueApp-included window!
            if(currentWindowId == 0){
                WinActivate matchedId
                currentWindowId := matchedId
            }

            if matchedId == currentWindowId ; If the currently active window is the same as matched one, we keep looking
                continue

            
            ; if we encountered a new focusable window and the id is not the current one, we focus!
            WinActivate matchedId

            ; Update currentWindowId 
            IniWrite WinExist("A"), "C:\tmp\switch-workspace.ini", "section1", "currentWindowId"

            return
        }
    }
}





!#Left::
!#WheelUp::
^#WheelUp::
#WheelUp::{
    SwitchLeft()
}

!#Right::
!#WheelDown::
^#WheelDown::
#WheelDown::{
    SwitchRight()
}




SwitchLeft(){
    Send "#^{Left}"
    Sleep 500
    MatchFocusApps()
}

SwitchRight(){
    Send "#^{Right}"
    Sleep 500
    MatchFocusApps()
}




; ; Workspace Right
; #!Right::
; {
;     Send "#^{Right}"
; }
; #!WheelDown::
; {
;     Send "#^{Right}"
; }
; #^WheelDown::
; {
;     Send "#^{Right}"
; }
; #WheelDown::
; {
;     Send "#^{Right}"
; }

;MoveRight()
;{
;    Send "#^{Right}"
;}