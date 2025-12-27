#Requires AutoHotkey v2.0
#SingleInstance Force

; ------------------------------------------------------------------------------
; Global Variables & Configuration
; ------------------------------------------------------------------------------
IconFile := "assets\Retro_Mario.ico"
if FileExist(IconFile) {
    TraySetIcon(IconFile)
}

; Configuration Object
global Config := Map()
Config["HoldTimeout"] := 150
Config["MouseSpeed"] := 10
Config["MouseAcceleration"] := 1.1
Config["MaxMouseSpeed"] := 50
Config["ExcludedApps"] := Map()
Config["Keys"] := Map()
Config["GlobalKeys"] := Map()

; Action Mappings (Action Name -> Function)
global Actions := Map()
Actions["MoveUp"] := (*) => Send("{Up}")
Actions["MoveDown"] := (*) => Send("{Down}")
Actions["MoveLeft"] := (*) => Send("{Left}")
Actions["MoveRight"] := (*) => Send("{Right}")
Actions["MoveHome"] := (*) => Send("{Home}")
Actions["MoveEnd"] := (*) => Send("{End}")
Actions["Delete"] := (*) => Send("{Delete}")
Actions["ClipboardHistory"] := (*) => Send("^+!c")
Actions["MouseUp"] := (*) => StartMouseMovement(0, -1)
Actions["MouseDown"] := (*) => StartMouseMovement(0, 1)
Actions["MouseLeft"] := (*) => StartMouseMovement(-1, 0)
Actions["MouseRight"] := (*) => StartMouseMovement(1, 0)
Actions["MouseClickLeft"] := (*) => Click("Left")
Actions["MouseClickRight"] := (*) => Click("Right")
Actions["WinMinimize"] := (*) => WinMinimize("A")

; File Paths
global IniFilePath := A_ScriptDir "\settings.ini"

; State
global CapsLockStartTime := 0
global LShiftStartTime := 0
global RShiftStartTime := 0

; ------------------------------------------------------------------------------
; Initialization
; ------------------------------------------------------------------------------
LoadConfiguration()
SetupTrayMenu()
SetupHotkeys()

; ------------------------------------------------------------------------------
; Configuration Management
; ------------------------------------------------------------------------------
LoadConfiguration() {
    global Config
    
    ; General
    Config["HoldTimeout"] := IniRead(IniFilePath, "General", "HoldTimeout", 150)
    Config["MouseSpeed"] := IniRead(IniFilePath, "General", "MouseSpeed", 10)
    Config["MouseAcceleration"] := IniRead(IniFilePath, "General", "MouseAcceleration", 1.1)
    Config["MaxMouseSpeed"] := IniRead(IniFilePath, "General", "MaxMouseSpeed", 50)
    
    ; Excluded Apps
    rawExcluded := IniRead(IniFilePath, "ExcludedApps", "ProcessNames", "")
    Config["ExcludedApps"].Clear()
    Loop Parse, rawExcluded, "," {
        if (A_LoopField != "")
            Config["ExcludedApps"][A_LoopField] := true
    }

    ; CapsLock Keys
    LoadKeysSection("Keys", Config["Keys"])
    
    ; Global Keys
    LoadKeysSection("GlobalKeys", Config["GlobalKeys"])
}

LoadKeysSection(sectionName, targetMap) {
    targetMap.Clear()
    try {
        keysSection := IniRead(IniFilePath, sectionName)
    } catch {
        keysSection := ""
    }
    
    Loop Parse, keysSection, "`n", "`r" {
        if (A_LoopField = "")
            continue
        parts := StrSplit(A_LoopField, "=")
        if (parts.Length = 2) {
            triggerKey := Trim(parts[1])
            actionName := Trim(parts[2])
            if (triggerKey != "" && actionName != "")
                targetMap[triggerKey] := actionName
        }
    }
}

SaveConfiguration() {
    ; General
    IniWrite(Config["HoldTimeout"], IniFilePath, "General", "HoldTimeout")
    IniWrite(Config["MouseSpeed"], IniFilePath, "General", "MouseSpeed")
    IniWrite(Config["MouseAcceleration"], IniFilePath, "General", "MouseAcceleration")
    IniWrite(Config["MaxMouseSpeed"], IniFilePath, "General", "MaxMouseSpeed")
    
    ; Excluded Apps
    excludedStr := ""
    for app, _ in Config["ExcludedApps"] {
        excludedStr .= app . ","
    }
    excludedStr := RTrim(excludedStr, ",")
    IniWrite(excludedStr, IniFilePath, "ExcludedApps", "ProcessNames")
    
    ; Keys
    SaveKeysSection("Keys", Config["Keys"])
    SaveKeysSection("GlobalKeys", Config["GlobalKeys"])
}

SaveKeysSection(sectionName, sourceMap) {
    IniDelete(IniFilePath, sectionName)
    for key, action in sourceMap {
        if (key != "")
            IniWrite(action, IniFilePath, sectionName, key)
    }
}

; ------------------------------------------------------------------------------
; Dynamic Hotkeys
; ------------------------------------------------------------------------------
SetupHotkeys() {
    ; Register CapsLock Layer Keys
    HotIf (*) => GetKeyState("CapsLock", "P") && !IsExcludedApp()
    RegisterMapKeys(Config["Keys"])
    
    ; Register Global Keys
    HotIf (*) => !IsExcludedApp()
    RegisterMapKeys(Config["GlobalKeys"])
    
    HotIf ; Turn off context
}

RegisterMapKeys(keyMap) {
    for key, actionName in keyMap {
        if (key = "")
            continue
        try {
            if Actions.Has(actionName) {
                Hotkey key, Actions[actionName], "On"
            } else {
                ; Create a closure for the specific action string
                Hotkey key, ((str) => (*) => Send(str))(actionName), "On"
            }
        } catch as err {
            ; Apply
        }
    }
}

; ------------------------------------------------------------------------------
; Logic Functions
; ------------------------------------------------------------------------------
IsExcludedApp() {
    try {
        procName := WinGetProcessName("A")
        if Config["ExcludedApps"].Has(procName)
            return true
    }
    return false
}

StartMouseMovement(dx, dy) {
    currentSpeed := Config["MouseSpeed"]
    acceleration := Config["MouseAcceleration"]
    maxSpeed := Config["MaxMouseSpeed"]
    
    while GetKeyState(A_ThisHotkey, "P") {
        MouseMove(dx * currentSpeed, dy * currentSpeed, 0, "R")
        
        ; Accelerate
        currentSpeed *= acceleration
        if (currentSpeed > maxSpeed)
            currentSpeed := maxSpeed
            
        Sleep 20
    }
}

; ------------------------------------------------------------------------------
; GUI & Menu
; ------------------------------------------------------------------------------
SetupTrayMenu() {
    Tray := A_TrayMenu
    Tray.Delete() ; Clear default
    Tray.Add("Settings", (*) => ShowSettingsGUI())
    Tray.Add("Reload", (*) => Reload())
    Tray.Add("Exit", (*) => ExitApp())
}

ShowSettingsGUI() {
    myGui := Gui("+AlwaysOnTop", "MacKey4Windows Settings")
    myGui.SetFont("s10", "Segoe UI")
    
    tabs := myGui.Add("Tab3", "w550 h450", ["General", "CapsLock Keys", "Global Keys", "Excluded Apps"])
    
    ; --- General Tab ---
    tabs.UseTab("General")
    
    myGui.Add("Text", "Section", "Hold Timeout (ms):")
    myGui.Add("Edit", "ys w100 vHoldTimeout", Config["HoldTimeout"])
    
    myGui.Add("Text", "xs Section", "Mouse Base Speed:")
    myGui.Add("Edit", "ys w100 vMouseSpeed", Config["MouseSpeed"])
    
    myGui.Add("Text", "xs Section", "Mouse Acceleration:")
    myGui.Add("Edit", "ys w100 vMouseAccel", Config["MouseAcceleration"])

    
    ; --- CapsLock Keys Tab ---
    tabs.UseTab("CapsLock Keys")
    myGui.Add("Text",, "Keys active when CapsLock is HELD down.`nDouble-click to edit.")
    
    lvCaps := myGui.Add("ListView", "w500 h300 Grid -Multi vListViewCaps", ["Action / Send", "Trigger Key (Display)", "Internal Key"])
    lvCaps.ModifyCol(1, 220)
    lvCaps.ModifyCol(2, 200)
    lvCaps.ModifyCol(3, 0) 
    
    PopulateListView(lvCaps, Config["Keys"], true)
    
    btnAddCaps := myGui.Add("Button", "w80 Section", "Add")
    btnDelCaps := myGui.Add("Button", "ys w80", "Remove")
    
    btnAddCaps.OnEvent("Click", (*) => AddMapping(lvCaps, myGui, true))
    btnDelCaps.OnEvent("Click", (*) => RemoveMapping(lvCaps))
    lvCaps.OnEvent("DoubleClick", (*) => EditMappingKey(lvCaps, myGui, true))
    
    ; --- Global Keys Tab ---
    tabs.UseTab("Global Keys")
    myGui.Add("Text",, "Global Shortcuts (Always active unless excluded).`nDouble-click to edit.")
    
    lvGlobal := myGui.Add("ListView", "w500 h300 Grid -Multi vListViewGlobal", ["Action / Send", "Trigger Key (Display)", "Internal Key"])
    lvGlobal.ModifyCol(1, 220)
    lvGlobal.ModifyCol(2, 200)
    lvGlobal.ModifyCol(3, 0) 
    
    PopulateListView(lvGlobal, Config["GlobalKeys"], false)
    
    btnAddGlob := myGui.Add("Button", "w80 Section", "Add")
    btnDelGlob := myGui.Add("Button", "ys w80", "Remove")
    
    btnAddGlob.OnEvent("Click", (*) => AddMapping(lvGlobal, myGui, false))
    btnDelGlob.OnEvent("Click", (*) => RemoveMapping(lvGlobal))
    lvGlobal.OnEvent("DoubleClick", (*) => EditMappingKey(lvGlobal, myGui, false))

    ; --- Excluded Apps Tab ---
    tabs.UseTab("Excluded Apps")
    myGui.Add("Text",, "Excluded Processes:")
    lvApps := myGui.Add("ListView", "w500 h300 Grid -Multi vListViewApps", ["Process Name"])
    lvApps.ModifyCol(1, 400)
    for app, _ in Config["ExcludedApps"] {
        lvApps.Add(, app)
    }
    
    btnAddApp := myGui.Add("Button", "w80 Section", "Add")
    btnDelApp := myGui.Add("Button", "ys w80", "Remove")
    
    btnAddApp.OnEvent("Click", (*) => AddProcess(lvApps, myGui))
    btnDelApp.OnEvent("Click", (*) => RemoveProcess(lvApps))

    ; --- Footer ---
    tabs.UseTab()
    ; Place buttons below the Tab control (Height 450)
    myGui.Add("Button", "xm y470 w80", "Save").OnEvent("Click", (*) => SaveAndReload(myGui))
    myGui.Add("Button", "x+20 w80", "Cancel").OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

PopulateListView(lv, mapData, isCapsLock) {
    for key, action in mapData {
        displayKey := FormatKeyForDisplay(key, isCapsLock)
        lv.Add(, action, displayKey, key)
    }
}

FormatKeyForDisplay(key, isCapsLock) {
    display := key
    ; Use placeholders to avoid recursive replacement of "+"
    display := StrReplace(display, "^", "{Ctrl}")
    display := StrReplace(display, "!", "{Alt}")
    display := StrReplace(display, "+", "{Shift}")
    display := StrReplace(display, "#", "{Win}")
    
    ; Convert placeholders to final format
    display := StrReplace(display, "{Ctrl}", "Ctrl + ")
    display := StrReplace(display, "{Alt}", "Alt + ")
    display := StrReplace(display, "{Shift}", "Shift + ")
    display := StrReplace(display, "{Win}", "Win + ")
    
    if (isCapsLock)
        display := "CapsLock + " . display
        
    return display
}

EditMappingKey(lv, parentGui, isCapsLock) {
    row := lv.GetNext()
    if (row == 0)
        return
        
    actionName := lv.GetText(row, 1)
    
    promptGui := Gui("+Owner" parentGui.Hwnd " +AlwaysOnTop", "Change Trigger")
    promptGui.Add("Text",, "Press new key for: " actionName)
    promptGui.Add("Hotkey", "vNewKey")
    
    btnOk := promptGui.Add("Button", "w80 Default", "OK")
    btnOk.OnEvent("Click", (*) => HandleKeyParam(promptGui, lv, row, 3, isCapsLock))
    promptGui.Show()
}

AddMapping(lv, parentGui, isCapsLock) {
    promptGui := Gui("+Owner" parentGui.Hwnd " +AlwaysOnTop", "Add Mapping")
    
    promptGui.Add("Text",, "Select Action OR Type Send String:")
    
    ; Build Actions List
    actionList := []
    for actionName, _ in Actions {
        actionList.Push(actionName)
    }
    
    cbAction := promptGui.Add("ComboBox", "vActionName w200", actionList)
    
    promptGui.Add("Text",, "Trigger Key (Press key to bind):")
    hkCtrl := promptGui.Add("Hotkey", "vTriggerKey")
    
    btnOk := promptGui.Add("Button", "w80 Default", "OK")
    btnOk.OnEvent("Click", (*) => VerifyAndAdd(promptGui, lv, isCapsLock))
    
    promptGui.Show()
    
    VerifyAndAdd(g, listv, isCaps) {
        res := g.Submit()
        if (res.ActionName != "" && res.TriggerKey != "") {
            displayKey := FormatKeyForDisplay(res.TriggerKey, isCaps)
            listv.Add(, res.ActionName, displayKey, res.TriggerKey)
        }
        g.Destroy()
    }
}

RemoveMapping(lv) {
    row := lv.GetNext()
    if (row > 0)
        lv.Delete(row)
}

HandleKeyParam(g, listv, r, colInternal, isCapsLock) {
    saved := g.Submit()
    if (saved.NewKey != "") {
         listv.Modify(r, "Col" colInternal, saved.NewKey)
         listv.Modify(r, "Col2", FormatKeyForDisplay(saved.NewKey, isCapsLock))
    }
    g.Destroy()
}

AddProcess(lv, parentGui) {
    InputBoxObj := InputBox("Enter process name (e.g., notepad.exe):", "Add Exclusion")
    if (InputBoxObj.Result = "OK" && InputBoxObj.Value != "") {
        lv.Add(, InputBoxObj.Value)
    }
}

RemoveProcess(lv) {
    row := lv.GetNext()
    if (row > 0)
        lv.Delete(row)
}

SaveAndReload(guiObj) {
    saved := guiObj.Submit()
    
    ; Update Config Global
    Config["HoldTimeout"] := saved.HoldTimeout
    Config["MouseSpeed"] := saved.MouseSpeed
    Config["MouseAcceleration"] := saved.MouseAccel
    
    ; Update Excluded Apps
    Config["ExcludedApps"].Clear()
    lvApps := guiObj["ListViewApps"]
    Loop lvApps.GetCount() {
        Config["ExcludedApps"][lvApps.GetText(A_Index, 1)] := true
    }
    
    ; Update CapsLock Keys
    Config["Keys"].Clear()
    lvCaps := guiObj["ListViewCaps"]
    Loop lvCaps.GetCount() {
        action := lvCaps.GetText(A_Index, 1)
        key := lvCaps.GetText(A_Index, 3) 
        if (key != "" && action != "")
            Config["Keys"][key] := action
    }
    
    ; Update Global Keys
    Config["GlobalKeys"].Clear()
    lvGlob := guiObj["ListViewGlobal"]
    Loop lvGlob.GetCount() {
        action := lvGlob.GetText(A_Index, 1)
        key := lvGlob.GetText(A_Index, 3) 
        if (key != "" && action != "")
            Config["GlobalKeys"][key] := action
    }
    
    SaveConfiguration()
    guiObj.Destroy()
    Reload()
}

; ------------------------------------------------------------------------------
; Helper Functions (UI Feedback)
; ------------------------------------------------------------------------------
ShowStyledTip(text, duration := 1000) {
    static MyGui := ""
    if (MyGui) {
        try MyGui.Destroy()
    }
    MyGui := Gui("+AlwaysOnTop -Caption +ToolWindow +LastFound +Owner")
    MyGui.BackColor := "Red"
    MyGui.SetFont("cWhite s10 w700", "Segoe UI")
    MyGui.MarginX := 10
    MyGui.MarginY := 5
    MyGui.Add("Text",, text)
    
    try {
        if CaretGetPos(&x, &y) {
            x += 10
            y += 20
        } else {
            MouseGetPos(&x, &y)
            x += 20
            y += 20
        }
    } catch {
        MouseGetPos(&x, &y)
    }
    
    MyGui.Show("x" x " y" y " NoActivate")
    SetTimer () => (MyGui ? (MyGui.Destroy(), MyGui := "") : ""), -duration
}

; ------------------------------------------------------------------------------
; Core: CapsLock & Shift Logic (Static)
; ------------------------------------------------------------------------------
#HotIf !IsExcludedApp()

SetCapsLockState("AlwaysOff")

*CapsLock:: {
    global CapsLockStartTime := A_TickCount
}

*CapsLock Up:: {
    duration := A_TickCount - CapsLockStartTime
    if (duration < Config["HoldTimeout"] && A_PriorKey = "CapsLock") {
        Send("{LWin down}{Space}{LWin up}")
        ShowStyledTip("Input Method Switched", 500)
    }
}

~LShift:: {
    global LShiftStartTime := A_TickCount
}

~LShift Up:: {
    duration := A_TickCount - LShiftStartTime
    if (duration < Config["HoldTimeout"] && A_PriorKey = "LShift") {
        Send("{(}")
    }
}

~RShift:: {
    global RShiftStartTime := A_TickCount
}

~RShift Up:: {
    duration := A_TickCount - RShiftStartTime
    if (duration < Config["HoldTimeout"] && A_PriorKey = "RShift") {
        Send("{)}")
    }
}

#HotIf