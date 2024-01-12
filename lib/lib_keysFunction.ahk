; keys functions start-------------
; 所有按键对应功能都放在这，为防止从set.ini通过按键设置调用到非按键功能函数，
; 规定函数以"keyFunc_"开头

keyFunc_doNothing(){
    return
}

keyFunc_send(p){
    sendinput, % p
    return
}

keyFunc_run(p){
    run, % p
    return
}


keyFunc_moveLeft(){
    SendInput,{left}
    return
}


keyFunc_moveRight(){
    SendInput,{right}
    Return
}


keyFunc_moveUp(i:=1){
    global
    if(WinActive("ahk_id" . GuiHwnd))
    {
        ControlFocus, , ahk_id %LV_show_Hwnd%
        SendInput, {Up %i%}
        ControlFocus, , ahk_id %editHwnd%
    }
    else
        SendInput,{up %i%}
    Return
}


keyFunc_moveDown(i:=1){
    global
    if(WinActive("ahk_id" . GuiHwnd))
    {
        ControlFocus, , ahk_id %LV_show_Hwnd%
        SendInput, {Down %i%}
        ControlFocus, , ahk_id %editHwnd%
    }
    else
        SendInput,{down %i%}
    Return
}


keyFunc_moveWordLeft(){
    SendInput,^{Left}
    Return
}


keyFunc_moveWordRight(){
    SendInput,^{Right}
    Return
}


keyFunc_backspace(){
    SendInput,{backspace}
    Return
}


keyFunc_delete(){
    SendInput,{delete}
    Return
}


keyFunc_end(){
    SendInput,{End}
    Return
}


keyFunc_home(){
    SendInput,{Home}
    Return
}


keyFunc_deleteLine(){
    SendInput,{End}+{home}{bs}
    Return
}


keyFunc_enterWherever(){
    SendInput,{End}{Enter}
    Return
}


keyFunc_enter(){
SendInput, {Enter}
Return
}

keyFunc_sendChar(char){
    ClipboardOld:=ClipboardAll
    Clipboard:=char
    SendInput, +{insert}
    Sleep, 50
    Clipboard:=ClipboardOld
    return
}

keyFunc_pageUp(){
    global
    if(WinActive("ahk_id" . GuiHwnd))
    {
        ControlFocus, , ahk_id %LV_show_Hwnd%
        SendInput, {PgUp}
        ControlFocus, , ahk_id %editHwnd%
    }
    else
        SendInput, {PgUp}
    return
}


keyFunc_pageDown(){
    global
    if(WinActive("ahk_id" . GuiHwnd))
    {
        ControlFocus, , ahk_id %LV_show_Hwnd%
        SendInput, {PgDn}
        ControlFocus, , ahk_id %editHwnd%
    }
    else
        SendInput, {PgDn}
    Return
}

;页面向上移动一页，光标不动
keyFunc_pageMoveUp(){
    SendInput, ^{PgUp}
    return
}

;页面向下移动一页，光标不动
keyFunc_pageMoveDown(){
    SendInput, ^{PgDn}
    return
}

keyFunc_pasteSystem(){
    global

    ; ;
    ; 禁止 OnClipboardChange 运行，防止 Clipboard:=sClipboardAll 重复执行，导致偶尔会粘贴出空白
    ;  if(!CLsets.global.allowClipboard)  ;禁用剪贴板功能
    ;  {
    ;      CapsLock2:=""
    ;      return
    ;  }
    if (whichClipboardNow!=0)
    {
        allowRunOnClipboardChange:=false
        Clipboard:=sClipboardAll
        whichClipboardNow:=0
    }
    SendInput, ^{v}
    return
}



keyFunc_tabPrve(){
    SendInput, ^+{tab}
    return
}


keyFunc_tabNext(){
    SendInput, ^{tab}
    return
}


keyFunc_jumpPageTop(){
    SendInput, ^{Home}
    return
}


keyFunc_jumpPageBottom(){
    SendInput, ^{End}
    return
}


keyFunc_selectUp(i:=1){
    SendInput, +{Up %i%}
    return
}


keyFunc_selectDown(i:=1){
    SendInput, +{Down %i%}
    return
}


keyFunc_selectLeft(){
    SendInput, +{Left}
    return
}


keyFunc_selectRight(){
    SendInput, +{Right}
    return
}


keyFunc_selectHome(){
    SendInput, +{Home}
    return
}

;; 
keyFunc_moveHome(){
    SendInput, {Home}
    return
}


keyFunc_selectEnd(){
    SendInput, +{End}
    return
}

keyFunc_moveEnd(){
    SendInput, {End}
    return
}

keyFunc_selectWordLeft(){
    SendInput, +^{Left}
    return
}


keyFunc_selectWordRight(){
    SendInput, +^{Right}
    return
}

;页面移动一行，光标不动
keyFunc_pageMoveLineUp(i:=1){
    SendInput, ^{Up %i%}
    return
}


keyFunc_pageMoveLineDown(i:=1){
    SendInput, ^{Down %i%}
    return
}

keyFunc_mediaPrev(){
    SendInput, {Media_Prev}
    return
}


keyFunc_mediaNext(){
    SendInput, {Media_Next}
    return
}


keyFunc_mediaPlayPause(){
    SendInput, {Media_Play_Pause}
    return
}


keyFunc_volumeUp(){
    SendInput, {Volume_Up}
    return
}


keyFunc_volumeDown(){
    SendInput, {Volume_Down}
    return
}


keyFunc_volumeMute(){
    SendInput, {Volume_Mute}
    return
}


keyFunc_reload(){
    MsgBox, , , reload, 0.5
    Reload
    return
}

keyFunc_ditto(){
    SendInput, ^+!c
    Return
}