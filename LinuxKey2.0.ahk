#Requires AutoHotkey v2.0
#SingleInstance Force

; ------------------------------------------------------------------------------
; Configuration & Initialization
; ------------------------------------------------------------------------------

; Check and load icon
if FileExist("Retro_Mario.ico") {
    TraySetIcon("Retro_Mario.ico")
}

; Load Settings
IniFile := A_ScriptDir "\settings.ini"
HoldTimeout := IniRead(IniFile, "General", "HoldTimeout", 150)
MouseSpeed := IniRead(IniFile, "General", "MouseSpeed", 10)
ExcludedAppsStr := IniRead(IniFile, "ExcludedApps", "ProcessNames", "")

; Global State
global CapsLockToChangeInputMethod := 0
global CapsLockStatus := 0

; ------------------------------------------------------------------------------
; Helper Functions
; ------------------------------------------------------------------------------

; Reset input method switch flag
ResetInputMethodFlag() {
    global CapsLockToChangeInputMethod := 0
}

; Show tooltip helper
ShowTip(text, duration := 1000) {
    ToolTip text
    SetTimer () => ToolTip(), -duration
}

; Check if current app is excluded
IsExcludedApp() {
    if (ExcludedAppsStr = "")
        return false
    
    try {
        activeProcess := WinGetProcessName("A")
        if (InStr("," . ExcludedAppsStr . ",", "," . activeProcess . ","))
            return true
    }
    return false
}

; ------------------------------------------------------------------------------
; Core Logic: CapsLock & Shift (Wrapped in #HotIf)
; ------------------------------------------------------------------------------

#HotIf !IsExcludedApp()

; Disable default CapsLock toggle
SetCapsLockState("AlwaysOff")

*CapsLock:: {
    global CapsLockToChangeInputMethod := 1
    global CapsLockStatus := 1
    
    ; Set a timer to disable "Input Method Switch" intent if held too long
    SetTimer(ResetInputMethodFlag, -HoldTimeout) 
    
    KeyWait("CapsLock")
    
    global CapsLockStatus := 0
    
    ; If the flag is still true (released quickly), switch input method
    if (CapsLockToChangeInputMethod) {
        Send("{LWin down}{Space}{LWin up}")
        ShowTip("Input Method Switched", 500)
        global CapsLockToChangeInputMethod := 0
    }
}

LShift:: {
    if (KeyWait("LShift", "T" . HoldTimeout / 1000)) { 
        ; Released quickly
        if (A_PriorKey = "LShift") {
            Send("{(}")
        }
    } else {
        ; Held longer than timeout, act as normal Shift
        Send("{LShift Down}")
        KeyWait("LShift")
        Send("{LShift Up}")
    }
}

RShift:: {
    if (KeyWait("RShift", "T" . HoldTimeout / 1000)) {
        ; Released quickly
        if (A_PriorKey = "RShift") {
            Send("{)}")
        }
    } else {
        ; Held longer than timeout, act as normal Shift
        Send("{RShift Down}")
        KeyWait("RShift")
        Send("{RShift Up}")
    }
}

; ------------------------------------------------------------------------------
; Hotkeys: CapsLock Layer
; ------------------------------------------------------------------------------

#HotIf GetKeyState("CapsLock", "P") && !IsExcludedApp()

; Navigation
a::Send "{Home}"
e::Send "{End}"
b::Send "{Left}"
f::Send "{Right}"
p::Send "{Up}"
n::Send "{Down}"

; Editing
d::Send "{Delete}"
c::Send "^+!c" ; Ditto clipboard history (custom)

; Mouse Keys
i::MouseMove 0, -MouseSpeed, 0, "R" ; Up
k::MouseMove 0, MouseSpeed, 0, "R"  ; Down
j::MouseMove -MouseSpeed, 0, 0, "R" ; Left
l::MouseMove MouseSpeed, 0, 0, "R"  ; Right
u::Click "Left"
o::Click "Right"

; ------------------------------------------------------------------------------
; Hotkeys: Mac-style Shortcuts (Alt -> Ctrl)
; ------------------------------------------------------------------------------

#HotIf !IsExcludedApp()

!c::Send "^c"    ; Copy
!x::Send "^x"    ; Cut
!v::Send "^v"    ; Paste
!a::Send "^a"    ; Select All
!z::Send "^z"    ; Undo
!y::Send "^y"    ; Redo
!w::Send "^w"    ; Close Tab
!t::Send "^t"    ; New Tab
!f::Send "^f"    ; Find
!s::Send "^s"    ; Save
!b::Send "^b"    ; Bold
!i::Send "^i"    ; Italic
!q::Send "!{F4}" ; Close Window

#HotIf