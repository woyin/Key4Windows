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

keyFunc_mouseSpeedIncrease(){
    global
    mouseSpeed+=1
    if(mouseSpeed>20)
    {
        mouseSpeed:=20
    }
    showMsg("mouse speed: " . mouseSpeed, 1000)
    setSettings("Global","mouseSpeed",mouseSpeed)
    return
}


keyFunc_mouseSpeedDecrease(){
    global
    mouseSpeed-=1
    if(mouseSpeed<1)
    {
        mouseSpeed:=1
    }
    showMsg("mouse speed: " . mouseSpeed, 1000)
    setSettings("Global","mouseSpeed",mouseSpeed)
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

;双字符
keyFunc_doubleChar(char1,char2:=""){
    if(char2=="")
    {
        char2:=char1
    }
    charLen:=StrLen(char2)
    selText:=getSelText()
    ClipboardOld:=ClipboardAll
    if(selText)
    {
        Clipboard:=char1 . selText . char2
        SendInput, +{insert}
    }
    else
    {
        Clipboard:=char1 . char2
        SendInput, +{insert}{left %charLen%}
    }
    Sleep, 100
    Clipboard:=ClipboardOld
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

keyFunc_switchClipboard(){
    global
    if(CLsets.global.allowClipboard)
    {
        CLsets.global.allowClipboard:="0"
        setSettings("Global","allowClipboard","0")
        showMsg("Clipboard OFF",1500)
    }
    else
    {
        CLsets.global.allowClipboard:="1"
        setSettings("Global","allowClipboard","1")
        showMsg("Clipboard ON",1500)
    }
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


keyFunc_cut_1(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }
        
    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{x}
    ClipWait, 0.1
    if (ErrorLevel)
    {
        SendInput,{home}+{End}^{x}
        ClipWait, 0.1
    }
    if (!ErrorLevel)
    {
        ;cClipboardAll:=ClipboardAll
        clipSaver("c")
        whichClipboardNow:=1
    }
    else
    {
        Clipboard:=ClipboardOld
    }
    Return
}


keyFunc_copy_1(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{insert}
    ClipWait, 0.1
    if (ErrorLevel)
    {
        SendInput,{home}+{End}^{insert}{End}
        ClipWait, 0.1
    }
    if (!ErrorLevel)
    {
        ;  cClipboardAll:=ClipboardAll
        clipSaver("c")
        whichClipboardNow:=1
    }
    else
    {
        Clipboard:=ClipboardOld
    }
    return
}


keyFunc_paste_1(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    if (whichClipboardNow!=1)
    {
        Clipboard:=cClipboardAll
        whichClipboardNow:=1
    }
    SendInput, ^{v}
    Return
}


keyFunc_undoRedo(){
    global
    if(ctrlZ)
    {
        SendInput, ^{z}
        ctrlZ:=""
    }
    Else
    {
        SendInput, ^{y}
        ctrlZ:=1
    }
    Return
}


keyFunc_cut_2(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{x}
    ClipWait, 0.1
    if (ErrorLevel)
    {
        SendInput,{home}+{End}^{x}
        ClipWait, 0.1
    }
    if (!ErrorLevel)
    {
        ;  caClipboardAll:=ClipboardAll
        clipSaver("ca")
        whichClipboardNow:=2
    }
    else
    {
        Clipboard:=ClipboardOld
    }
    Return
}


keyFunc_copy_2(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{insert}
    ClipWait, 0.1
    if (ErrorLevel)
    {
        SendInput,{home}+{End}^{insert}{End}
        ClipWait, 0.1
    }
    if (!ErrorLevel)
    {
        ;  caClipboardAll:=ClipboardAll
        clipSaver("ca")
        whichClipboardNow:=2
    }
    else
    {
        Clipboard:=ClipboardOld
    }
    return
}


keyFunc_paste_2(){
    global
    if(CLsets.global.allowClipboard="0")  ;禁用剪贴板功能
    {
        CapsLock2:=""
        return
    }

    if (whichClipboardNow!=2)
    {
        Clipboard:=caClipboardAll
        whichClipboardNow:=2
    }
    SendInput, ^{v}
    Return
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