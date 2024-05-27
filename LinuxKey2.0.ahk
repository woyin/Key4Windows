#SingleInstance force

; Check if the icon file exists and set the tray icon if it does
if FileExist("Retro_Mario.ico") {
    MenuSetIcon("Retro_Mario.ico", 1)
}

global CLversion := "Copyright by Woyin"

#Include A_ScriptDir "\lib\lib_functions.ahk"
#Include A_ScriptDir "\lib\lib_KeysFunction.ahk"
#Include A_ScriptDir "\lib\lib_macKeys.ahk"

;-----------------START-----------------

; Attempt to change left and right Shift keys to left parenthesis "(" and right parenthesis ")"
global abc := false

LShift::ShiftHandler("LShift", "{(}")
RShift::ShiftHandler("RShift", "{)}")

ShiftHandler(shiftKey, output) {
    KeyWait(shiftKey, "T0.01")
    if (ErrorLevel) {
        startTime := A_TickCount
        while GetKeyState(shiftKey, "P") {
            Send "{" shiftKey " down}"
            KeyWait(shiftKey)
            if ((A_TickCount - startTime < 150) && (A_PriorKey = shiftKey)) {
                Send output
            }
            Send "{" shiftKey " up}"
        }
    }
}

;-------程序解释------------------------
; 该程序的逻辑与Mac上面的改变按键的逻辑不同
; Autohotkey 无法真正意义上实现Capslock的组合键，所以用了两个变量来间接判断Capslock按键到底是被触发了一次，还是按住后与其他组合键一起使用
; 判断是否触碰了一下就松开的通过KeyWait方法，对Capslock 点击松开进行判断，并通过SetTimer 来判断到底是按了一次还是长按，并调整相关的变量值
;--------------------------------------

global CapsLockToChangeInputMethod := false, CapsLockStatus := false

CapsLock::CapsLockHandler()

CapsLockHandler() {
    global CapsLockToChangeInputMethod, CapsLockStatus

    CapsLockToChangeInputMethod := true
    CapsLockStatus := true
    CapsLockHoldTime := 300
    SetTimer(NoNeedToChangeInputMethod, CapsLockHoldTime, 1)

    KeyWait("CapsLock")
    CapsLockStatus := false
    if CapsLockToChangeInputMethod {
        Send "#{Space}"
        CapsLockToChangeInputMethod := false
    }
}

NoNeedToChangeInputMethod() {
    global CapsLockToChangeInputMethod
    CapsLockToChangeInputMethod := false
}

;----------------------------keys-set-start-----------------------------
#IF CapsLockStatus ; when CapsLock key is pressed and held

a:: keyFunc_moveHome()
b:: keyFunc_moveLeft()
c:: keyFunc_ditto()
d:: keyFunc_delete()
e:: keyFunc_moveEnd()
f:: keyFunc_moveRight()
n:: keyFunc_moveDown()
p:: keyFunc_moveUp()

#IF
