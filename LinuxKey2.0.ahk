#Requires AutoHotkey v2.0
#SingleInstance Force

; 检查图标文件
if FileExist("Retro_Mario.ico") {
    TraySetIcon("Retro_Mario.ico")
}

; 全局变量
global CLversion := "Copyright by Woyin"
global CapsLockToChangeInputMethod := 0
global CapsLockStatus := 0
global abc := false

; 改变输入法状态的开关
noNeedToChangeInputMethod() {
    global CapsLockToChangeInputMethod := 0
}

; 实际使用的按键功能函数
keyFunc_moveLeft() {
    Send("{Left}")
}

keyFunc_moveRight() {
    Send("{Right}")
}

keyFunc_moveUp() {
    Send("{Up}")
}

keyFunc_moveDown() {
    Send("{Down}")
}

keyFunc_delete() {
    Send("{Delete}")
}

keyFunc_moveHome() {
    Send("{Home}")
}

keyFunc_moveEnd() {
    Send("{End}")
}

keyFunc_ditto() {
    Send("^+!c")
}

; Mac风格快捷键
!c::Send("^c")    ; 复制
!x::Send("^x")    ; 剪切
!v::Send("^v")    ; 粘贴
!a::Send("^a")    ; 全选
!z::Send("^z")    ; 撤销
!y::Send("^y")    ; 重做
!w::Send("^w")    ; 关闭标签
!t::Send("^t")    ; 新建标签
!f::Send("^f")    ; 查找
!s::Send("^s")    ; 保存
!b::Send("^b")    ; 粗体
!i::Send("^i")    ; 斜体
!q::Send("!{F4}") ; 关闭窗口

; 左右Shift键改造
LShift:: {
    if !KeyWait("LShift", "T0.01") {  ; 如果按键没有在10ms内释放
        startTime := A_TickCount
        while GetKeyState("LShift", "P") {
            Send("{LShift Down}")
            KeyWait("LShift")
            if ((A_TickCount - startTime) < 150 && A_PriorKey = "LShift")
                Send("(")
            Send("{LShift Up}")
        }
    }
}

RShift:: {
    if !KeyWait("RShift", "T0.01") {  ; 如果按键没有在10ms内释放
        startTime := A_TickCount
        while GetKeyState("RShift", "P") {
            Send("{RShift Down}")
            KeyWait("RShift")
            if ((A_TickCount - startTime) < 150 && A_PriorKey = "RShift")
                Send(")")
            Send("{RShift Up}")
        }
    }
}

; 禁用原始的CapsLock功能
SetCapsLockState("AlwaysOff")

; CapsLock处理
*CapsLock:: {
    global CapsLockToChangeInputMethod := 1
    global CapsLockStatus := 1
    SetTimer(noNeedToChangeInputMethod, 150)

    KeyWait("CapsLock")
    global CapsLockStatus := 0
    if (CapsLockToChangeInputMethod) {
        Send("{LWin down}{Space}{LWin up}")  
        global CapsLockToChangeInputMethod := 0
    }
}

; CapsLock组合键
#HotIf GetKeyState("CapsLock", "P")
a::keyFunc_moveHome()
b::keyFunc_moveLeft()
c::keyFunc_ditto()
d::keyFunc_delete()
e::keyFunc_moveEnd()
f::keyFunc_moveRight()
n::keyFunc_moveDown()
p::keyFunc_moveUp()
#HotIf