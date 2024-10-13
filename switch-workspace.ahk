#Requires AutoHotkey v2.0

; Switch Workspace Hotkeys - Left Win-Key
; Anders-Erik : 2024-10-13



; OVERVIEW
;   - enables the switching between workspaces using the following hotkeys:
;       - alt + Lwin + L/R-arrow
;       - Lwin + wheel
;       - win + alt + wheel
;       - win + ctrl + wheel
;   - Automatically moves user focus to the most recently active window on that desktop
;       - Keeps a list of window-ids, sorted by order of most recent focus
;       - when a desktop-switch taskes place the script querries all newly available windows, detects the most recently used one, and activated that window.
;       - if no window is detected, nothing is done and the user will initiate focus in his or her own
;       - because the script keeps a list that is populated during it's own lifetime, the user is required to initiate focus at any time when targeting a desktop without previously active windows since the script was started.




; - - - - - - - - - - - - - - - - - -
;   HOTKEYS
;

; Move to next Desktop to the LEFT
!#Left::
!#WheelUp::
^#WheelUp::
#WheelUp::{
    Send "#^{Left}"
    Sleep 500
    ; MatchFocusApps() ; old : map of prioritized title substrings
    FocusOnMostRecent() ; new : sorted array of all window id's that the user has visited; most recent first
}

; Move to next Desktop to the RIGHT
!#Right::
!#WheelDown::
^#WheelDown::
#WheelDown::{
    Send "#^{Right}"
    Sleep 500
    ; MatchFocusApps() ; old : map of prioritized title substrings
    FocusOnMostRecent() ; new : sorted array of all window id's that the user has visited; most recent first
}



; The callback when switching desktops
; Queries the history to determine which window to activate
FocusOnMostRecent(){
    availableIds := WinGetList(,, "Program Manager")
    _focusHistory := FocusHistory()
    ; _focusHistory.msgBoxHistory()
    ; _focusHistory.LogHistory()
    newId := _focusHistory.getMostRecentIdFromAvailable(availableIds)

    ; No match with previously visited window
    ; Atm user has to actively visit each window the first time
    ; If trying to set 'WinActivate' below with newId=0m an error is thrown
    if(newId == 0){
        return
    }
    
    ; The actual call to focus on a particular window
    WinActivate newId

    ; Log - I still can't quite what I'm logging lol
    infoString := ""
    infoString .= "Current Focus = " . _focusHistory.getCurrentId() . "`n"
    infoString .= "newId         = " . newId . "`n"
    LogLineToFile(infoString)
    ; MsgBox infoString
}





; - - - - - - - - - - - - - - - - - 
; HISTORY MANAGEMENT
;


; History of focused windows.
; Provides interface and persistence for access to the history of active window id's since beginning of script.
Class FocusHistory {
    ; Sorted array of viewed window id's. Most recently active window-id first.
    static focus_id_history := Array()
     ; Dummy variable
    static count := 0
     ; Dummy variable
    static printCount := 0

    ; empty constructor
    __New(){
    }
    

    ; Shows current history array as a list, using MsgBox
    msgBoxHistory(){
        FocusHistory.printCount++
        printString := "focus_id_history Print : `n"
        Loop FocusHistory.focus_id_history.Length{
            printString .= FocusHistory.focus_id_history[A_Index] . "`n"
        }
        MsgBox printString
    }

    ; Logs current history array as a list, using default logging settings [append to log file]
    LogHistory(){
        FocusHistory.printCount++
        printString := "focus_id_history Print : `n"
        Loop FocusHistory.focus_id_history.Length{
            printString .= FocusHistory.focus_id_history[A_Index] . "`n"
        }
        SendText printString
    }


    ; Adds passed window-id the the front of the history array.
    tryAddToList(_id){
        if(_id == 0) ; never keep '0' as window id because it usually means that we are not targeting anything, which is not something we want to accidentally set!
            return 

        ; this is here to enable the below optimization
        ; if(FocusHistory.focus_id_history.Length == 0){
        ;     FocusHistory.focus_id_history.InsertAt(1, _id)
        ;     return
        ; }

        ; If window is already in the first slot - no action needed
        ; This is added for optimization. If computer is running a long time and array grows, this might be helpful.
        ; At least it gives me a bit more peace of mind. :)
        if (FocusHistory.focus_id_history.Has(1) && _id == FocusHistory.focus_id_history[1]) ; Has(1) : make sure that the method breaks before the first insertion
            return

        ; Remove all occurrences of current window-id
        Loop FocusHistory.focus_id_history.Length{
            ; if the window-id already exists, remove it
            if(_id == FocusHistory.focus_id_history[A_Index]){
                FocusHistory.focus_id_history.RemoveAt(A_Index)
                break ; make sure that we stop after removing the first element, to prevent inde out of bounds. This make the script more voulnerable to a growing id-array.
            }
        }
        
        
        ; Insert the newly focued window into array
        FocusHistory.focus_id_history.InsertAt(1, _id)
    }

    ; Returns most recent focused window id -- irrespective of available windows
    ; Returns '0' if list is empty
    getCurrentId(){
        if(FocusHistory.focus_id_history.Has(1))
            return FocusHistory.focus_id_history[1]
        else
            return 0
    }

    ; Return the most recently focues window id of the currently available
    ; Returns: 
    ;   1) <window id> on match
    ;   2) '0' on no match
    getMostRecentIdFromAvailable(_availableIdsArray){

        ; Start with the history: need to check against all available id's before moving on to the next in history array.
        historyIndex := 1
        Loop FocusHistory.focus_id_history.Length{
            availableIndex := 1
            Loop _availableIdsArray.Length{
                if (FocusHistory.focus_id_history[historyIndex] == _availableIdsArray[availableIndex]){
                    return _availableIdsArray[availableIndex]
                }
                availableIndex++
            }
            historyIndex++
        }
        

        return 0
    }

}




; Update the history every n milliseconds
; Minimal time to stay on one window to guarantee that it is put first in the history queue
SetTimer WriteCurrentToHistory, 1000

; Update the history by butting the currently active window as most recent
WriteCurrentToHistory(){

    _focusHistory := FocusHistory()
    _focusHistory.tryAddToList(WinExist("A"))

}





; - - - - - - - - - - - - - - 
; LOGGING


; Logging utility for convenience to file : A_WorkingDir . "\not-in-use\log.txt"
LogLineToFile(logStr){
    FileAppend  logStr . "`n",                      ; line to append to file
                 A_WorkingDir . "\not-in-use\log.txt"     ; Relative path
}


























; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                           OLD VERSION BELOW
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


; Overview:
;   - persists using ini-file
;   - keeps a constant list of app-title substrings of decreasing priority. When switching desktops the script will step through the list, trying to focus on the window with highest matched priority, making sure that the currently targeted window is activated.
;       - when trying to find a good window all matched titles are added to a map with it's priority index. The window with the lowest index is selected that is defferent from the current window.


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
; If there is a match -- focus.
MatchFocusApps(){
    ; _focusHistory := FocusHistory()
    ; _focusHistory.msgBoxHistory()

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
