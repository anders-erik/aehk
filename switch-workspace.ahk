
; Switch Workspace Hotkeys
; Anders-Erik : 2024-10-12


; OVERVIEW
;   - enabling the switching of workspaces using the following hotkeys:
;       - alt+win+left/right arrow
;       - win + wheel
;       - win + alt + wheel
;       - win + ctrl + wheel
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