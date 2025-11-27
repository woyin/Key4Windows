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

; Show styled tooltip helper
ShowStyledTip(text, duration := 1000) {
    static MyGui := ""
    
    ; Destroy previous GUI if it exists
    if (MyGui) {
        try MyGui.Destroy()
    }
    
    MyGui := Gui("+AlwaysOnTop -Caption +ToolWindow +LastFound +Owner")
    MyGui.MarginX := 10
    MyGui.MarginY := 5
    MyGui.BackColor := "Red"
    MyGui.SetFont("cWhite s10 w700", "Segoe UI")
    MyGui.Add("Text",, text)
    
    ; Calculate position
    try {
        if CaretGetPos(&x, &y) {
            ; Show near caret (slightly below)
            x += 10
            y += 20
        } else {
            ; Fallback to mouse position
            MouseGetPos(&x, &y)
            x += 20
            y += 20
        }
    } catch {
        ; Fallback if something fails
        MouseGetPos(&x, &y)
    }
    
    MyGui.Show("x" x " y" y " NoActivate")
    
    ; Auto-hide
    SetTimer () => (MyGui ? (MyGui.Destroy(), MyGui := "") : ""), -duration
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

; ------------------------------------------------------------------------------
; Core Logic: CapsLock
; ------------------------------------------------------------------------------

; Disable default CapsLock toggle
SetCapsLockState("AlwaysOff")

; Record start time on press
*CapsLock:: {
    global CapsLockStartTime := A_TickCount
}

; Handle action on release
*CapsLock Up:: {
    ; Calculate duration
    duration := A_TickCount - CapsLockStartTime
    
    ; If released quickly AND no other key was pressed in between
    if (duration < HoldTimeout && A_PriorKey = "CapsLock") {
        Send("{LWin down}{Space}{LWin up}")
        ShowStyledTip("Input Method Switched", 500)
    }
}

; ------------------------------------------------------------------------------
; Core Logic: Shift Parentheses
; ------------------------------------------------------------------------------

; Use pass-through (~) to ensure Shift works instantly as a modifier for other keys
~LShift:: {
    global LShiftStartTime := A_TickCount
}

~LShift Up:: {
    duration := A_TickCount - LShiftStartTime
    
    ; If released quickly AND no other key was pressed
    if (duration < HoldTimeout && A_PriorKey = "LShift") {
        Send("{(}")
    }
}

~RShift:: {
    global RShiftStartTime := A_TickCount
}

~RShift Up:: {
    duration := A_TickCount - RShiftStartTime
    
    ; If released quickly AND no other key was pressed
    if (duration < HoldTimeout && A_PriorKey = "RShift") {
        Send("{)}")
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