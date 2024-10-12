
; https://superuser.com/questions/950960/pin-applications-to-multiple-desktops-in-windows-10


WS_EX_TOOLWINDOW := 0x00000080
+MButton::WinSet, ExStyle, ^%WS_EX_TOOLWINDOW%, A
^MButton::WinSet, AlwaysOnTop, toggle, A
