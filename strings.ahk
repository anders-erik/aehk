#Requires AutoHotkey v2.0

; https://en.wikipedia.org/wiki/AutoHotkey
; NOTE: if clipboard is empty I move to the game bar [which I can reach by using win+alt]
#g::Run "https://www.google.com/search?q=" . A_Clipboard

; Email
!m:: SendText "anderserikerik@gmail.com"

; Todays ISO Date
^!d:: SendInput A_YYYY "-" A_MM "-" A_DD

; Current Time
^!t:: SendInput A_Hour ":" A_Min ":" A_Sec



; Additional mouse buttons
; https://www.autohotkey.com/boards/viewtopic.php?t=24881
; XButton1::MsgBox "X1"
; XButton2::MsgBox "X2"
