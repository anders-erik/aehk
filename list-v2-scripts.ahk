
; List all currently running AutoHotKey v2 processes/scripts
; Anders-Erik : 2024-10-12

; Template from here:
; https://www.autohotkey.com/docs/v2/lib/WinGetList.htm

DetectHiddenWindows(True)
ids := WinGetList(, , "Program Manager")
listStr := ""
for this_id in ids {
    ;WinActivate this_id ; focus on particular window

    this_class := WinGetClass(this_id)
    this_title := WinGetTitle(this_id)

    ; Concatenate all titles
    if InStr(this_title, "autohotkey v2.") {
        listStr .= this_title
    }

}

; Show Titles
MsgBox listStr
