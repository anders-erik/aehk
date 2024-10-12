#Requires AutoHotkey v2.0

; Double Press Win for Workspace overview
; Anders-Erik : 2024-10-12

; Overview: 
;
; I had a lot of interference with the native bahavor of the win-key and as a result I opted to only implement multiple presses
; Currently exactly 2 presses are required to trigger the view!
;
;   FUTURE:
; It would be nice to prevent default win-key behavior until the end of the timer..

; Script largely taken from official docs
; https://www.autohotkey.com/docs/v2/lib/SetTimer.htm


~LWin:: ; '~' seems to prevent AHK from blocking default key behavior
~Rwin::
KeyLWin(ThisHotkey)  ; This is a named function hotkey.
{
    static lwin_presses := 0
    if lwin_presses > 0 ; SetTimer already started, so we log the keypress instead.
    {
        lwin_presses += 1
        return
    }

    lwin_presses := 1
    SetTimer TimerCallback, -250 ; ms

    TimerCallback()  ; This is a nested function.
    {
        if lwin_presses = 1 ; The key was pressed once.
        {
        }
        else if lwin_presses = 2 ; The key was pressed twice.
        {
            ; Send "{LWin}"
            Send "#{Tab}"

        }
        else if lwin_presses = 3 {
        }
        else if lwin_presses > 3 {
        }

        lwin_presses := 0
    }
}