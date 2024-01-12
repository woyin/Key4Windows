#SingleInstance force

IfExist, Retro_Mario.ico
{
    ;freezing icon
    menu, TRAY, Icon, Retro_Mario.ico, , 1
}
; Menu, Tray, Icon,,, 1

global CLversion:="Copyright by Woyin" 

#Include %A_ScriptDir%\lib\lib_functions.ahk
#Include %A_ScriptDir%\lib\lib_KeysFunction.ahk

;-----------------START-----------------

; 尝试将左右Shift 变成左括号"("和右括号")"的输入

; 设置一个阈值（以毫秒为单位）来决定何时认为是“长按”
; 可以根据需要调整这个时间

LShift::
    keyWait, LShift, T0.01
    if (ErrorLevel) {
        startTime := A_TickCount
        while GetKeyState("LShift", "P") {
            ; Lasting Time is bigger than xxx ms
            if ((A_TickCount - startTime) > 100) {
                SendInput, {LShift down}
                KeyWait, LShift
                SendInput, {LShift up}
                return
            }
        }
        Send, {(}
    }
return

RShift::
    keyWait, RShift, T0.01
    if (ErrorLevel) {
        startTime := A_TickCount
        while GetKeyState("RShift", "P") {
            ; Lasting Time is bigger than xxx ms
            if ((A_TickCount - startTime) > 100) {
                SendInput, {RShift down}
                KeyWait, RShift
                SendInput, {RShift up}
                return
            }
        }
        Send, {)}
    }
return

;-------程序解释------------------------
; 该程序的逻辑与Mac上面的改变按键的逻辑不同
; Autohotkey 无法真正意义上实现Capslock的组合键，所以用了两个变量来间接判断Capslock按键到底是被触发了一次，还是按住后与其他组合键一起使用
; 判断是否触碰了一下就松开的通过KeyWait方法，对Capslock 点击松开进行判断，并通过SetTimer 来判断到底是按了一次还是长按，并调整相关的变量值
;--------------------------------------

global CapsLockToChangeInputMethod, CapsLockStatus

 ; 每次按下CapsLock都默认是为了修改输入法，而不是将CapsLock 当作修饰键来用
CapsLock::
    CapsLockToChangeInputMethod:=1 ;为是否切换输入法开关
    ; 默认CapsLock（系统变量）的值为1，即大小写打开（但后续会关闭）
    CapsLockStatus:=1 
    CapsLockHoldTime:=300 ;阈值300ms，只要按住的时间不超过300ms，就不会触发下面的定时器
    ; 同时设置一个定时器，只要按键时间超过阈值，则翻转默认逻辑，即CapsLock成为修饰符而非修改输入法 
    SetTimer, noNeedToChangeInputMethod, % CapsLockHoldTime

    ; 等待CapsLock 被释放
    ; 该语句的目的是与后面的两个#IF 形成
    KeyWait, CapsLock
        ;只要CapsLock松开，就一定要将CapsLockStatus置为0，否则在松开后，依然可以通过单独按键形成组合键
        ;即原本需要按住CapsLock才能生效的组合键，现在松开后，单独按键，比如a就能触发CapsLock+a的组合键效果
        ;松开的原因为，因为CapsLock已经松开，所有围绕它的编程都需要作废
        CapsLockStatus:=0
    ; 当CapsLockToChangeInputMethod 标识位为1时，改变输入法
        if CapsLockToChangeInputMethod{
            send #{Space}

    ; 全局变量置为0，避免反复执行切换输入法操作
            CapsLockToChangeInputMethod:=0
        }
    return

;----------------------------keys-set-start-----------------------------
; 这段#IF 不会被阻塞，因为可以和下面的按键形成组合键，与KeyWait不冲突
; 如果CapsLock在150ms内被松开，则CapsLockStatus会被置为0，下面所有组合键都不会生效（不过是废话，毕竟CapsLock都被松开了）
    #IF CapsLockStatus ;when capslock key press and hold

    a::
        keyFunc_moveHome()
    Return
    b::
        keyFunc_moveLeft()
    Return
    c::
        keyFunc_ditto()
    Return
    d::
        keyFunc_delete()
    Return
    e::
        keyFunc_moveEnd()
    Return
    f::
        keyFunc_moveRight()
    Return
    g::
    h::
    i::
    j::
    k::
    l::
    n::
        keyFunc_moveDown()
    Return
    m::
    o::
    p::
        keyFunc_moveUp()
    Return
    q::
    r::
    s::
    t::
    u::
    v::
    w::
    x::
    y::
    z::
    1::
    2::
    3::
    4::
    5::
    6::
    7::
    8::
    9::
    0::
    f1::
    f2::
    f3::
    f4::
    f5::
    f6::
    f7::
    f8::
    f9::
    f10::
    f11::
    f12::
    space::
    tab::
    enter::
    esc::
    backspace::
    ralt::

    #IF