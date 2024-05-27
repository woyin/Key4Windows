keyFunc_doNothing() {
    return
}

keyFunc_send(p) {
    Send(p)
    return
}

keyFunc_run(p) {
    Run(p)
    return
}

keyFunc_moveLeft() {
    Send("{Left}")
    return
}

keyFunc_moveRight() {
    Send("{Right}")
    return
}

keyFunc_moveUp(i := 1) {
    global
    if (WinActive("ahk_id" . GuiHwnd)) {
        ControlFocus("", "ahk_id" . LV_show_Hwnd)
        Send("{Up " . i . "}")
        ControlFocus("", "ahk_id" . editHwnd)
    } else {
        Send("{Up " . i . "}")
    }
    return
}

keyFunc_moveDown(i := 1) {
    global
    if (WinActive("ahk_id" . GuiHwnd)) {
        ControlFocus("", "ahk_id" . LV_show_Hwnd)
        Send("{Down " . i . "}")
        ControlFocus("", "ahk_id" . editHwnd)
    } else {
        Send("{Down " . i . "}")
    }
    return
}

keyFunc_moveWordLeft() {
    Send("^+{Left}")
    return
}

keyFunc_moveWordRight() {
    Send("^+{Right}")
    return
}

keyFunc_backspace() {
    Send("{Backspace}")
    return
}

keyFunc_delete() {
    Send("{Delete}")
    return
}

keyFunc_end() {
    Send("{End}")
    return
}

keyFunc_home() {
    Send("{Home}")
    return
}

keyFunc_deleteLine() {
    Send("{End}+{Home}{Backspace}")
    return
}

keyFunc_enterWherever() {
    Send("{End}{Enter}")
    return
}

keyFunc_enter() {
    Send("{Enter}")
    return
}

keyFunc_sendChar(char) {
    ClipboardOld := ClipboardAll
    Clipboard := char
    Send("^v")
    Sleep(50)
    Clipboard := ClipboardOld
    return
}

keyFunc_pageUp() {
    global
    if (WinActive("ahk_id" . GuiHwnd)) {
        ControlFocus("", "ahk_id" . LV_show_Hwnd)
        Send("{PgUp}")
        ControlFocus("", "ahk_id" . editHwnd)
    } else {
        Send("{PgUp}")
    }
    return
}

keyFunc_pageDown() {
    global
    if (WinActive("ahk_id" . GuiHwnd)) {
        ControlFocus("", "ahk_id" . LV_show_Hwnd)
        Send("{PgDn}")
        ControlFocus("", "ahk_id" . editHwnd)
    } else {
        Send("{PgDn}")
    }
    return
}

keyFunc_pageMoveUp() {
    Send("^+{PgUp}")
    return
}

keyFunc_pageMoveDown() {
    Send("^+{PgDn}")
    return
}

keyFunc_pasteSystem() {
    global
    if (whichClipboardNow != 0) {
        allowRunOnClipboardChange := false
        Clipboard := sClipboardAll
        whichClipboardNow := 0
    }
    Send("^v")
    return
}

keyFunc_tabPrve() {
    Send("^+{Tab}")
    return
}

keyFunc_tabNext() {
    Send("^{Tab}")
    return
}

keyFunc_jumpPageTop() {
    Send("^{Home}")
    return
}

keyFunc_jumpPageBottom() {
    Send("^{End}")
    return
}

keyFunc_selectUp(i := 1) {
    Send("+{Up " . i . "}")
    return
}

keyFunc_selectDown(i := 1) {
    Send("+{Down " . i . "}")
    return
}

keyFunc_selectLeft() {
    Send("+{Left}")
    return
}

keyFunc_selectRight() {
    Send("+{Right}")
    return
}

keyFunc_selectHome() {
    Send("+{Home}")
    return
}

keyFunc_moveHome() {
    Send("{Home}")
    return
}

keyFunc_selectEnd() {
    Send("+{End}")
    return
}

keyFunc_moveEnd() {
    Send("{End}")
    return
}

keyFunc_selectWordLeft() {
    Send("+^{Left}")
    return
}

keyFunc_selectWordRight() {
    Send("+^{Right}")
    return
}

keyFunc_pageMoveLineUp(i := 1) {
    Send("^+{Up " . i . "}")
    return
}

keyFunc_pageMoveLineDown(i := 1) {
    Send("^+{Down " . i . "}")
    return
}

keyFunc_mediaPrev() {
    Send("{Media_Prev}")
    return
}

keyFunc_mediaNext() {
    Send("{Media_Next}")
    return
}

keyFunc_mediaPlayPause() {
    Send("{Media_Play_Pause}")
    return
}

keyFunc_volumeUp() {
    Send("{Volume_Up}")
    return
}

keyFunc_volumeDown() {
    Send("{Volume_Down}")
    return
}

keyFunc_volumeMute() {
    Send("{Volume_Mute}")
    return
}

keyFunc_reload() {
    MsgBox("Reloading script", "Info", 0.5)
    Reload
    return
}

keyFunc_ditto() {
    Send("^+!c")
    return
}
