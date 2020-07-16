#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

; Make Some other key-remapping without CapsLock
+ESC::~ ; Mapping for 60% keyboard, for example Anne Pro 2
; 黏贴
+Backspace::
    send +{Insert}
    return
; 复制
^BackSpace::
    send ^{Insert}
    return