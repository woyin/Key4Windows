# MacKey4Windows (formerly LinuxKey/Key4Windows)

MacKey4Windows is a powerful AutoHotkey script designed to bring **macOS-style shortcuts and navigation** to Windows. It enhances productivity by keeping your hands on the keyboard and minimizing arm movement.

## Features

### 🚀 Core Features
*   **MacOS Shortcuts**: Seamlessly use `Alt+C` (Copy), `Alt+V` (Paste), `Alt+W` (Close Tab) and more on Windows.
*   **CapsLock Navigation**: Press and hold `CapsLock` to activate a navigation layer (Vim-style `H/J/K/L` or custom).
*   **Mouse Control**: Control the mouse cursor with your keyboard, featuring **Smart Acceleration**.

### ✨ New in v3.0
*   **Graphical Settings UI**: Right-click the tray icon to easily configure everything.
*   **Dynamic Hotkeys**: Remap any key binding without touching the code.
*   **Global Keys Manager**: Manage your global shortcuts (like `Alt+Key` mappings) directly in the UI.
*   **Process Exclusion**: easily disable hotkeys in specific games or apps (e.g., CS:GO).

### 🆕 New in v3.1
*   **Shift Selection Mode**: `CapsLock` layer actions for selecting text (`SelectUp`, `SelectDown`, `SelectLeft`, `SelectRight`, `SelectHome`, `SelectEnd`).
*   **Word-level Navigation**: Jump by word (`CapsLock+W/Q`) and delete by word (`DeleteWord`, `BackspaceWord`).
*   **Page Navigation**: `PageUp` and `PageDown` actions available in the CapsLock layer.
*   **Pause/Resume**: Quickly toggle all hotkeys on/off from the tray menu.
*   **Export/Import Config**: Backup and restore your `settings.ini` via the GUI.
*   **Reset to Defaults**: One-click reset for General settings in the GUI.
*   **Performance**: HWND-cached `IsExcludedApp()` for reduced system calls.
*   **Validation**: All config values are type-checked and clamped to safe ranges.
*   **DPI Aware**: Settings window scales correctly on high-DPI displays.

## Usage

1.  Download and install [AutoHotkey v2](https://www.autohotkey.com/).
2.  Run `MacKey4Windows.ahk`.
3.  **Basic Navigation**: Hold `CapsLock` and press:
    *   `P` / `N`: Up / Down
    *   `B` / `F`: Left / Right
    *   `W` / `Q`: Word Right / Word Left
    *   `V`: Page Down
    *   (Mappings are fully customizable in Settings)
4.  **Settings**: Right-click the **Retro Mario** tray icon -> `Settings`.
    *   **General**: Adjust Hold Timeout, Mouse Speed, Acceleration, Max Speed, Interval.
    *   **CapsLock Keys**: Customise the navigation layer.
    *   **Global Keys**: Customise system-wide shortcuts.
    *   **Excluded Apps**: Add programs where the script should be inactive.
5.  **Pause**: Right-click tray icon -> `Pause` to temporarily disable all hotkeys.
6.  **Export/Import**: Use the buttons in Settings to backup or restore configuration.

## Configuration

All settings are stored in `settings.ini`.
*   You can edit this file manually or use the built-in GUI (Recommended).
*   **Backups**: Use the Export button in Settings, or manually backup your `settings.ini`.
*   **Validation**: Invalid values are automatically clamped to safe ranges on load.

## Optimization & Structure

*   Powered by AutoHotkey v2.
*   Uses `settings.ini` for persistent configuration.
*   Modular design with dynamic key registration.
*   HWND-cached excluded app detection for performance.
*   Config validation with `ClampInt` / `ClampFloat` helpers.

## License

[MIT License](LICENSE)
