#SingleInstance force
if not A_IsAdmin ;running by administrator
{
   Run *RunAs "%A_ScriptFullPath%" 
   ExitApp 0
}

IfExist, Retro_Mario.ico
{
    ;freezing icon
    menu, TRAY, Icon, Retro_Mario.ico, , 1
}
; Menu, Tray, Icon,,, 1

global CLversion:="Copyright by Woyin" 

;The beginning of all things
#Include %A_ScriptDir%\lib\lib_init.ahk 
#include %A_ScriptDir%\lib\lib_keysFunction.ahk
#include %A_ScriptDir%\lib\lib_keysSet.ahk
;get the settings from capslock+settings.ini 
#include %A_ScriptDir%\lib\lib_settings.ahk 
;public functions
#Include %A_ScriptDir%\lib\lib_functions.ahk 
#include %A_ScriptDir%\lib\lib_loadAnimation.ahk

; language
#include %A_ScriptDir%\language\lang_func.ahk
#include %A_ScriptDir%\language\Simplified_Chinese.ahk

;change dir
;#include ..\userAHK
;#include *i main.ahk

#MaxHotkeysPerInterval 500
#NoEnv
;  #WinActivateForce
Process Priority,,High


start:
; Make some other Things
#Include %A_ScriptDir%\userAHK\main.ahk


;-----------------START-----------------

; 尝试将左右Shift 变成左括号"("和右括号")"的输入

; 设置一个阈值（以毫秒为单位）来决定何时认为是“长按”
; 可以根据需要调整这个时间
shiftThreshold := 300

; 左Shift键的设置
~LShift Up::
    if (A_PriorKey = "LShift" and A_TimeSincePriorHotkey < shiftThreshold) 
        SendRaw, (
        ;Send, {(}
Return

; 右Shift键的设置
~RShift Up::
    if (A_PriorKey = "RShift" and A_TimeSincePriorHotkey < shiftThreshold) 
        SendRaw, )
        ;Send, {)}
Return

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
            ChangeInputMethod()
        }
    return

;----------------------------keys-set-start-----------------------------
; 这段#IF 不会被阻塞，因为可以和下面的按键形成组合键，与KeyWait不冲突
; 如果CapsLock在150ms内被松开，则CapsLockStatus会被置为0，下面所有组合键都不会生效（不过是废话，毕竟CapsLock都被松开了）
; 先是通过lib/lib_keysSet.ahk 中的默认定义，为每个配合了CapsLock的组合键做一个默认值
; 然后又通过lib/lib_settings.ahk 中的方法，通过读取settings.ini 文件中[Keys] 段的值进行覆盖（用户自定义的覆盖）
; 这种做法本质上是以lib_keySet 作为系统默认配置（不需要修改），然后利用setting.ini 文件作为用户配置文件进行修改
    #IF CapsLockStatus ;when capslock key press and hold

    a::
    b::
    c::
    d::
    e::
    f::
    g::
    h::
    i::
    j::
    k::
    l::
    n::
    m::
    o::
    p::
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
    try
        runFunc(keyset["caps_" . A_ThisHotkey])

    Return

    `::
    try
        runFunc(keyset.caps_backQuote)

    return


    -::
    try
        runFunc(keyset.caps_minus)

    return

    =::
    try
        runFunc(keyset.caps_equal)

    Return


    [::
    try
        runFunc(keyset.caps_leftSquareBracket)

    Return

    ]::
    try
        runFunc(keyset.caps_rightSquareBracket)

    Return

    \::
    try
        runFunc(keyset.caps_backslash)

    return

    `;::
    try
        runFunc(keyset.caps_semicolon)

    Return

    '::
    try
        runFunc(keyset.caps_quote)

    return


    ,::
    try
        runFunc(keyset.caps_comma)

    Return

    .::
    try
        runFunc(keyset.caps_dot)

    return

    /::
    try
        runFunc(keyset.caps_slash)

    Return

    ;  RAlt::
    ;  try
    ;      runFunc(keyset.caps_ralt)
    ;  
    ;  return



    ;---------------------caps+lalt----------------

    <!a::
    try
        runFunc(keyset.caps_lalt_a)

    return

    <!b::
    try
        runFunc(keyset.caps_lalt_b)

    Return

    <!c::
    try
        runFunc(keyset.caps_lalt_c)

    return

    <!d::
    try
        runFunc(keyset.caps_lalt_d)

    Return

    <!e::
    try
        runFunc(keyset.caps_lalt_e)

    Return

    <!f::
    try
        runFunc(keyset.caps_lalt_f)

    Return

    <!g::
    try
        runFunc(keyset.caps_lalt_g)

    Return

    <!h::
    try
        runFunc(keyset.caps_lalt_h)

    return

    <!i::
    try
        runFunc(keyset.caps_lalt_i)

    return

    <!j::
    try
        runFunc(keyset.caps_lalt_j)

    return

    <!k::
    try
        runFunc(keyset.caps_lalt_k)

    return

    <!l::
    try
        runFunc(keyset.caps_lalt_l)

    return

    <!m::
    try
        runFunc(keyset.caps_lalt_m)

    return

    <!n::
    try
        runFunc(keyset.caps_lalt_n)

    Return

    <!o::
    try
        runFunc(keyset.caps_lalt_o)

    return

    <!p::
    try
        runFunc(keyset.caps_lalt_p)

    Return

    <!q::
    try
        runFunc(keyset.caps_lalt_q)

    return

    <!r::
    try
        runFunc(keyset.caps_lalt_r)

    Return

    <!s::
    try
        runFunc(keyset.caps_lalt_s)

    Return

    <!t::
    try
        runFunc(keyset.caps_lalt_t)

    Return

    <!u::
    try
        runFunc(keyset.caps_lalt_u)

    return

    <!v::
    try
        runFunc(keyset.caps_lalt_v)

    Return

    <!w::
    try
        runFunc(keyset.caps_lalt_w)

    Return

    <!x::
    try
        runFunc(keyset.caps_lalt_x)

    Return

    <!y::
    try
        runFunc(keyset.caps_lalt_y)

    return

    <!z::
    try
        runFunc(keyset.caps_lalt_z)

    Return

    <!`::
        runFunc(keyset.caps_lalt_backquote)

    return

    <!1::
    try
        runFunc(keyset.caps_lalt_1)

    return

    <!2::
    try
        runFunc(keyset.caps_lalt_2)

    return

    <!3::
    try
        runFunc(keyset.caps_lalt_3)

    return

    <!4::
    try
        runFunc(keyset.caps_lalt_4)

    return

    <!5::
    try
        runFunc(keyset.caps_lalt_5)

    return

    <!6::
    try
        runFunc(keyset.caps_lalt_6)

    return

    <!7::
    try
        runFunc(keyset.caps_lalt_7)

    return

    <!8::
    try
        runFunc(keyset.caps_lalt_8)

    return

    <!9::
    try
        runFunc(keyset.caps_lalt_9)

    Return

    <!0::
    try
        runFunc(keyset.caps_lalt_0)

    Return

    <!-::
    try
        runFunc(keyset.caps_lalt_minus)

    return

    <!=::
    try
        runFunc(keyset.caps_lalt_equal)

    Return

    <!BackSpace::
    try
        runFunc(keyset.caps_lalt_backspace)

    Return

    <!Tab::
    try
        runFunc(keyset.caps_lalt_tab)

    Return

    <![::
    try
        runFunc(keyset.caps_lalt_leftSquareBracket)

    Return

    <!]::
    try
        runFunc(keyset.caps_lalt_rightSquareBracket)

    Return

    <!\::
    try
        runFunc(keyset.caps_lalt_Backslash)

    return

    <!`;::
    try
        runFunc(keyset.caps_lalt_semicolon)

    Return

    <!'::
    try
        runFunc(keyset.caps_lalt_quote)

    return

    <!Enter::
    try
        runFunc(keyset.caps_lalt_enter)

    Return

    <!,::
    try
        runFunc(keyset.caps_lalt_comma)

    Return

    <!.::
    try
        runFunc(keyset.caps_lalt_dot)

    return

    <!/::
    try
        runFunc(keyset.caps_lalt_slash)

    Return

    <!Space::
    try
        runFunc(keyset.caps_lalt_space)

    Return

    <!RAlt::
    try
        runFunc(keyset.caps_lalt_ralt)

    return

    <!F1::
    try
        runFunc(keyset.caps_lalt_f1)

    return

    <!F2::
    try
        runFunc(keyset.caps_lalt_f2)

    return

    <!F3::
    try
        runFunc(keyset.caps_lalt_f3)

    return

    <!F4::
    try
        runFunc(keyset.caps_lalt_f4)

    return

    <!F5::
    try
        runFunc(keyset.caps_lalt_f5)

    return

    <!F6::
    try
        runFunc(keyset.caps_lalt_f6)

    return

    <!F7::
    try
        runFunc(keyset.caps_lalt_f7)

    return

    <!F8::
    try
        runFunc(keyset.caps_lalt_f8)

    return

    <!F9::
    try
        runFunc(keyset.caps_lalt_f9)

    return

    <!F10::
    try
        runFunc(keyset.caps_lalt_f10)

    return

    <!F11::
    try
        runFunc(keyset.caps_lalt_f11)

    return

    <!F12::
    try
        runFunc(keyset.caps_lalt_f12)

    return


    ;  #s::
    ;      keyFunc_activateSideWin("l")
    ;  
    ;  return

    ;  #f::
    ;      keyFunc_activateSideWin("r")
    ;      
    ;  return

    ;  #e::
    ;      keyFunc_activateSideWin("u")
    ;  
    ;  return

    ;  #d::
    ;      keyFunc_activateSideWin("d")
    ;      
    ;  return

    ;  #w::
    ;      keyFunc_putWinToBottom()
    ;      
    ;  return

    ;  #a::
    ;      keyFunc_activateSideWin("fl")
    ;      
    ;  return

    ;  #g::
    ;      keyFunc_activateSideWin("fr")
    ;      
    ;  return

    ;  #z::
    ;      keyFunc_clearWinMinimizeStach()
    ;      
    ;  return

    ;  #x::
    ;      keyFunc_inWinMinimizeStack(true)
    ;      
    ;  return

    ;  #c::
    ;      keyFunc_inWinMinimizeStack()
    ;      
    ;  return

    ;  #v::
    ;      keyFunc_outWinMinimizeStack()
    ;      
    ;  return

    #IF




GuiClose:
GuiEscape:
Gui, Cancel
return
