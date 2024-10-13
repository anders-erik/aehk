#Requires AutoHotkey v2.0

veg := ["Asparagus", "Broccoli", "Cucumber"]

; Apps to focus in order of importance - Appears to not work as inteded..
apps := [
	"code", 		 ; VSCode has highest priority
	"firefox",
	"visual studio", ; VSCode & Visual Studio
]

DetectHiddenWindows(False)
ids := WinGetList(,, "Program Manager")
for this_id in ids
{
    ; WinActivate this_id
    this_class := WinGetClass(this_id)
    this_title := WinGetTitle(this_id)

	if InStr(this_title, "autohotkey v2.") {
		continue
	}   

	; if( InStr(this_title, "firefox") ){
	; 	MsgBox "FIREFOX"
	; }
	

	Loop apps.Length{
		if( InStr(this_title, apps[A_Index]) ){
			MsgBox "Focus on : " . this_title
			return
		}
	}

		

	; MsgBox "No apps to focus found!"
	; Loop veg.Length
	; 	MsgBox veg[A_Index]
	
    ; Result := MsgBox(
    ; (
    ;     "Visiting All Windows
    ;     " A_Index " of " ids.Length "
    ;     ahk_id " this_id "
    ;     ahk_class " this_class "
    ;     " this_title "

    ;     Continue?"
    ; ),, 4)
    ; if (Result = "No")
    ;     break
}