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
Config["MouseInterval"] := 20
Config["ExcludedApps"] := Map()
Config["Keys"] := Map()
Config["GlobalKeys"] := Map()

; Default values for Reset to Defaults (#11)
global DefaultConfig := Map()
DefaultConfig["HoldTimeout"] := 150
DefaultConfig["MouseSpeed"] := 10
DefaultConfig["MouseAcceleration"] := 1.1
DefaultConfig["MaxMouseSpeed"] := 50
DefaultConfig["MouseInterval"] := 20

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

; #6 - Shift Selection Mode Actions
Actions["SelectUp"] := (*) => Send("+{Up}")
Actions["SelectDown"] := (*) => Send("+{Down}")
Actions["SelectLeft"] := (*) => Send("+{Left}")
Actions["SelectRight"] := (*) => Send("+{Right}")
Actions["SelectHome"] := (*) => Send("+{Home}")
Actions["SelectEnd"] := (*) => Send("+{End}")

; #7 - Word-level Movement Actions
Actions["WordLeft"] := (*) => Send("^{Left}")
Actions["WordRight"] := (*) => Send("^{Right}")
Actions["SelectWordLeft"] := (*) => Send("^+{Left}")
Actions["SelectWordRight"] := (*) => Send("^+{Right}")
Actions["DeleteWord"] := (*) => Send("^{Delete}")
Actions["BackspaceWord"] := (*) => Send("^{Backspace}")

; #8 - Page Up/Down Actions
Actions["PageUp"] := (*) => Send("{PgUp}")
Actions["PageDown"] := (*) => Send("{PgDn}")

; File Paths
global IniFilePath := A_ScriptDir "\settings.ini"

; State
global CapsLockStartTime := 0
global LShiftStartTime := 0
global RShiftStartTime := 0

; #4 - IsExcludedApp HWND Cache
global CachedIsExcluded := false
global CachedHwnd := 0

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
    
    ; General - #14: Config value validation with type checking and clamping
    Config["HoldTimeout"] := ClampInt(IniRead(IniFilePath, "General", "HoldTimeout", 150), 50, 1000)
    Config["MouseSpeed"] := ClampInt(IniRead(IniFilePath, "General", "MouseSpeed", 10), 1, 100)
    Config["MouseAcceleration"] := ClampFloat(IniRead(IniFilePath, "General", "MouseAcceleration", 1.1), 1.0, 3.0)
    Config["MaxMouseSpeed"] := ClampInt(IniRead(IniFilePath, "General", "MaxMouseSpeed", 50), 5, 200)
    Config["MouseInterval"] := ClampInt(IniRead(IniFilePath, "General", "MouseInterval", 20), 5, 100)
    
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

; #14 - Validation helpers
ClampInt(val, minVal, maxVal) {
    try {
        n := Integer(val)
    } catch {
        n := minVal
    }
    return Max(minVal, Min(maxVal, n))
}

ClampFloat(val, minVal, maxVal) {
    try {
        n := Float(val)
    } catch {
        n := minVal
    }
    return Max(minVal, Min(maxVal, n))
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
    IniWrite(Config["MouseInterval"], IniFilePath, "General", "MouseInterval")
    
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

; #1 - Fixed: silent catch now logs errors via OutputDebug
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
            OutputDebug("⚠ Failed to register hotkey '" key "' -> '" actionName "': " err.Message)
        }
    }
}

; ------------------------------------------------------------------------------
; Logic Functions
; ------------------------------------------------------------------------------

; #4 - IsExcludedApp with HWND caching for performance
IsExcludedApp() {
    global CachedIsExcluded, CachedHwnd
    try {
        hwnd := WinGetID("A")
        if (hwnd = CachedHwnd)
            return CachedIsExcluded
        CachedHwnd := hwnd
        procName := WinGetProcessName("A")
        CachedIsExcluded := Config["ExcludedApps"].Has(procName)
        return CachedIsExcluded
    }
    return false
}

; #5 - Mouse interval now uses Config["MouseInterval"] instead of hardcoded 20
StartMouseMovement(dx, dy) {
    currentSpeed := Config["MouseSpeed"]
    acceleration := Config["MouseAcceleration"]
    maxSpeed := Config["MaxMouseSpeed"]
    interval := Config["MouseInterval"]
    
    while GetKeyState(A_ThisHotkey, "P") {
        MouseMove(dx * currentSpeed, dy * currentSpeed, 0, "R")
        
        ; Accelerate
        currentSpeed *= acceleration
        if (currentSpeed > maxSpeed)
            currentSpeed := maxSpeed
            
        Sleep interval
    }
}

; ------------------------------------------------------------------------------
; GUI & Menu
; ------------------------------------------------------------------------------

; #9 - Tray menu with Pause/Resume toggle
SetupTrayMenu() {
    Tray := A_TrayMenu
    Tray.Delete() ; Clear default
    Tray.Add("Settings", (*) => ShowSettingsGUI())
    Tray.Add("Pause", TogglePause)
    Tray.Add()  ; Separator
    Tray.Add("Reload", (*) => Reload())
    Tray.Add("Exit", (*) => ExitApp())
}

TogglePause(*) {
    Suspend(-1)  ; Toggle suspend state
    if A_IsSuspended {
        A_TrayMenu.Rename("Pause", "Resume")
        ShowStyledTip("⏸ Paused", 800)
    } else {
        A_TrayMenu.Rename("Resume", "Pause")
        ShowStyledTip("▶ Resumed", 800)
    }
}

ShowSettingsGUI() {
    ; #10 - DPI scaling support
    myGui := Gui("+AlwaysOnTop +Resize", "MacKey4Windows Settings")
    myGui.SetFont("s10", "Segoe UI")
    
    tabs := myGui.Add("Tab3", "w550 h480", ["General", "CapsLock Keys", "Global Keys", "Excluded Apps"])
    
    ; --- General Tab ---
    tabs.UseTab("General")
    
    myGui.Add("Text", "Section", "Hold Timeout (ms):")
    myGui.Add("Edit", "ys w100 vHoldTimeout", Config["HoldTimeout"])
    
    myGui.Add("Text", "xs Section", "Mouse Base Speed:")
    myGui.Add("Edit", "ys w100 vMouseSpeed", Config["MouseSpeed"])
    
    myGui.Add("Text", "xs Section", "Mouse Acceleration:")
    myGui.Add("Edit", "ys w100 vMouseAccel", Config["MouseAcceleration"])

    ; #2 - MaxMouseSpeed now exposed in GUI
    myGui.Add("Text", "xs Section", "Max Mouse Speed:")
    myGui.Add("Edit", "ys w100 vMaxMouseSpeed", Config["MaxMouseSpeed"])

    ; #5 - Mouse Interval exposed in GUI
    myGui.Add("Text", "xs Section", "Mouse Interval (ms):")
    myGui.Add("Edit", "ys w100 vMouseInterval", Config["MouseInterval"])

    ; #11 - Reset to Defaults button in General tab
    myGui.Add("Button", "xs Section w120", "Reset to Defaults").OnEvent("Click", (*) => ResetGeneralDefaults(myGui))
    
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
    ; Place buttons below the Tab control
    myGui.Add("Button", "xm y500 w80", "Save").OnEvent("Click", (*) => SaveAndReload(myGui))
    myGui.Add("Button", "x+20 w80", "Cancel").OnEvent("Click", (*) => myGui.Destroy())
    
    ; #12 - Export / Import buttons
    myGui.Add("Button", "x+40 w80", "Export").OnEvent("Click", (*) => ExportConfig())
    myGui.Add("Button", "x+10 w80", "Import").OnEvent("Click", (*) => ImportConfig())
    
    myGui.Show()
}

; #11 - Reset General settings to default values
ResetGeneralDefaults(guiObj) {
    result := MsgBox("Reset all General settings to defaults?", "Confirm Reset", "YesNo Icon!")
    if (result = "Yes") {
        guiObj["HoldTimeout"].Value := DefaultConfig["HoldTimeout"]
        guiObj["MouseSpeed"].Value := DefaultConfig["MouseSpeed"]
        guiObj["MouseAccel"].Value := DefaultConfig["MouseAcceleration"]
        guiObj["MaxMouseSpeed"].Value := DefaultConfig["MaxMouseSpeed"]
        guiObj["MouseInterval"].Value := DefaultConfig["MouseInterval"]
    }
}

; #12 - Export configuration to a user-chosen file
ExportConfig() {
    targetFile := FileSelect("S16", A_ScriptDir "\settings_backup.ini", "Export Configuration", "INI Files (*.ini)")
    if (targetFile = "")
        return
    try {
        FileCopy(IniFilePath, targetFile, true)
        MsgBox("Configuration exported to:`n" targetFile, "Export Successful", "Iconi")
    } catch as err {
        MsgBox("Export failed: " err.Message, "Error", "Icon!")
    }
}

; #12 - Import configuration from a user-chosen file
ImportConfig() {
    sourceFile := FileSelect(1, A_ScriptDir, "Import Configuration", "INI Files (*.ini)")
    if (sourceFile = "")
        return
    result := MsgBox("Import will overwrite current settings and reload.`nContinue?", "Confirm Import", "YesNo Icon!")
    if (result = "Yes") {
        try {
            FileCopy(sourceFile, IniFilePath, true)
            MsgBox("Configuration imported. Script will now reload.", "Import Successful", "Iconi")
            Reload()
        } catch as err {
            MsgBox("Import failed: " err.Message, "Error", "Icon!")
        }
    }
}

PopulateListView(lv, mapData, isCapsLock) {
    for key, action in mapData {
        displayKey := FormatKeyForDisplay(key, isCapsLock)
        lv.Add(, action, displayKey, key)
    }
}

; #13 - Simplified FormatKeyForDisplay using character-by-character parsing
FormatKeyForDisplay(key, isCapsLock) {
    static modifiers := Map(
        "^", "Ctrl + ",
        "!", "Alt + ",
        "+", "Shift + ",
        "#", "Win + "
    )
    display := ""
    Loop Parse, key {
        if modifiers.Has(A_LoopField)
            display .= modifiers[A_LoopField]
        else
            display .= A_LoopField
    }
    return (isCapsLock ? "CapsLock + " : "") . display
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

; #2 - SaveAndReload now includes MaxMouseSpeed and MouseInterval
SaveAndReload(guiObj) {
    saved := guiObj.Submit()
    
    ; Update Config Global - #14: validate on save
    Config["HoldTimeout"] := ClampInt(saved.HoldTimeout, 50, 1000)
    Config["MouseSpeed"] := ClampInt(saved.MouseSpeed, 1, 100)
    Config["MouseAcceleration"] := ClampFloat(saved.MouseAccel, 1.0, 3.0)
    Config["MaxMouseSpeed"] := ClampInt(saved.MaxMouseSpeed, 5, 200)
    Config["MouseInterval"] := ClampInt(saved.MouseInterval, 5, 100)
    
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

; #3 - ShowStyledTip with static variable for timer closure
ShowStyledTip(text, duration := 1000) {
    static TipGui := ""
    if (TipGui) {
        try TipGui.Destroy()
        TipGui := ""
    }
    TipGui := Gui("+AlwaysOnTop -Caption +ToolWindow +LastFound +Owner")
    TipGui.BackColor := "Red"
    TipGui.SetFont("cWhite s10 w700", "Segoe UI")
    TipGui.MarginX := 10
    TipGui.MarginY := 5
    TipGui.Add("Text",, text)
    
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
    
    TipGui.Show("x" x " y" y " NoActivate")
    SetTimer () => (TipGui ? (TipGui.Destroy(), TipGui := "") : ""), -duration
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