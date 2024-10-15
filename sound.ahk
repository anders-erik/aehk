#Requires AutoHotkey v2.0

; Playback & Volume Control
; Anders-Erik : 2024-10-12

; NOTE: The numpad num-controls do not always work with Num-Lock enabled! 


; - - - - - - - - - - - - -
; PLAYBACK


; STOP PLAYBACK - ONE WAY
+^NumpadDot::Media_Stop
+^NumpadDel::Media_Stop 

; PLAY/PAUSE - TOGGLE
+^|::Media_Play_Pause
+^Numpad5::Media_Play_Pause
+^NumpadClear::Media_Play_Pause

; PREVIOUS TRACK
+^{::Media_Prev
+^Numpad4::Media_Prev
+^NumpadLeft::Media_Prev

; NEXT TRACK
+^}::Media_Next
+^Numpad6::Media_Next
+^NumpadRight::Media_Next	




; - - - - - - - - - - 
; VOLUME

; Toggle mute
+^NumpadIns::
+^Numpad0::
{
	SoundSetMute -1
}

+^_::
+^NumpadSub::
{
	Send "{Volume_Down 2}"
}

+^+:: 								; AHK seems to just figure out that "+^+" means shift+ctrl+'+'. Link : https://www.autohotkey.com/board/topic/32557-how-is-hash-key-represented-in-autohotkey/
+^NumpadAdd::
{
	Send "{Volume_Up 2}"
}


