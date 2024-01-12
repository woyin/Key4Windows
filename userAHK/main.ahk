; 黏贴

; 改变输入法
; 同时还要将常量CapsLockToChangeInputMethod 置为0，避免反复执行切换工作
ChangeInputMethod()
{
    ; Windows修改输入法按键
    send #{Space}

    ; 全局变量置为0，避免反复执行切换输入法操作
    CapsLockToChangeInputMethod:=0
    return
}