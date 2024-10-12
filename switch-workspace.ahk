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


; Workspace LEFT
!#Left::
{
    Send "#^{Left}"
}
!#WheelUp::
{
    Send "#^{Left}"
}
^#WheelUp::
{
    Send "#^{Left}"
}
#WheelUp::
{
    Send "#^{Left}"
}

; Workspace Right
#!Right::
{
    Send "#^{Right}"
}
#!WheelDown::
{
    Send "#^{Right}"
}
#^WheelDown::
{
    Send "#^{Right}"
}
#WheelDown::
{
    Send "#^{Right}"
}

;MoveRight()
;{
;    Send "#^{Right}"
;}