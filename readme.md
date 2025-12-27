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

## Usage

1.  Download and install [AutoHotkey v2](https://www.autohotkey.com/).
2.  Run `MacKey4Windows.ahk`.
3.  **Basic Navigation**: Hold `CapsLock` and press:
    *   `P` / `N`: Up / Down
    *   `B` / `F`: Left / Right
    *   (Mappings are fully customizable in Settings)
4.  **Settings**: Right-click the **Retro Mario** tray icon -> `Settings`.
    *   **General**: Adjust Hold Timeout, Mouse Speed, Acceleration.
    *   **CapsLock Keys**: Customise the navigation layer.
    *   **Global Keys**: Customise system-wide shortcuts.
    *   **Excluded Apps**: Add programs where the script should be inactive.

## Configuration

All settings are stored in `settings.ini`.
*   You can edit this file manually or use the built-in GUI (Recommended).
*   **Backups**: It is recommended to backup your `settings.ini` if you have complex custom mappings.

## Optimization & Structure

*   Powered by AutoHotkey v2.
*   Uses `settings.ini` for persistent configuration.
*   Modular design with dynamic key registration.

## License

[MIT License](LICENSE)
