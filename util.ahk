#Requires AutoHotkey v2.0

; Util
; Anders-Erik - 2024-10-15



; - - - - - - - -
;	MOUSE BUTTONS
;

; 1. Multiply regular scrolling speed by "Med_speed" when holding down ctrl+alt
; 2. Multiply regular scrolling speed by "High_speed" when holding down both ctrl+win+alt

; Prevent default behavior
XButton1:: Send ""
XButton2:: Send ""

; https://www.autohotkey.com/boards/viewtopic.php?t=123480

Med_speed := 3
High_speed := 5


^!WheelDown::Send("{WheelDown " Med_speed "}")
^!WheelUp::Send("{WheelUp " Med_speed "}") 

#^!WheelDown::Send("{WheelDown " High_speed "}") 
#^!WheelUp::Send("{WheelUp " High_speed "}") 

; Speed up using the two additional mouse buttons on logitech G305
~WheelDown::{
	if GetKeyState("XButton2", "p")
		Send("{WheelDown " Med_speed "}")
	if GetKeyState("XButton1", "p")
		Send("{WheelDown " High_speed "}")
}
~WheelUp::{
	if GetKeyState("XButton2", "p")
		Send("{WheelUp " Med_speed "}")
	if GetKeyState("XButton1", "p")
		Send("{WheelUp " High_speed "}")
}