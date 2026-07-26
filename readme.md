# MacKey4Windows (formerly LinuxKey/Key4Windows)

MacKey4Windows is a powerful AutoHotkey script designed to bring **macOS-style shortcuts and navigation** to Windows. It enhances productivity by keeping your hands on the keyboard and minimizing arm movement.

## Features

### 🚀 Core Features
*   **Full macOS Shortcuts**: Seamlessly use `Alt` as `Cmd` — `Alt+C` (Copy), `Alt+V` (Paste), `Alt+W` (Close Tab), `Alt+Q` (Quit) and **50+ more**.
*   **CapsLock Navigation**: Press and hold `CapsLock` to activate a navigation layer (Emacs-style `P/N/B/F` + Word/Page movement).
*   **Mouse Control**: Control the mouse cursor with your keyboard, featuring **Smart Acceleration**.

### ✨ Shortcut Categories

#### Cmd (Alt) → Ctrl Mappings
| Shortcut | Action | Shortcut | Action |
|---|---|---|---|
| `Alt+C` | Copy | `Alt+V` | Paste |
| `Alt+X` | Cut | `Alt+A` | Select All |
| `Alt+Z` | Undo | `Alt+Y` | Redo |
| `Alt+S` | Save | `Alt+F` | Find |
| `Alt+N` | New | `Alt+O` | Open |
| `Alt+P` | Print | `Alt+W` | Close Tab |
| `Alt+T` | New Tab | `Alt+Q` | Quit (Alt+F4) |
| `Alt+L` | Address Bar | `Alt+K` | Quick Action |
| `Alt+D` | Bookmark | `Alt+G` | Find Next |
| `Alt+J` | Downloads | `Alt+R` | Refresh |
| `Alt+B` | Bold | `Alt+I` | Italic |
| `Alt+U` | Underline | `Alt+/` | Comment |
| `Alt+H` | Minimize | `Alt+M` | Minimize |
| `Alt+E` | Use for Find | | |

#### Cmd+Shift (Alt+Shift) Mappings
| Shortcut | Action |
|---|---|
| `Alt+Shift+Z` | Redo (macOS style) |
| `Alt+Shift+S` | Save As |
| `Alt+Shift+T` | Reopen Closed Tab |
| `Alt+Shift+N` | New Window / Incognito |
| `Alt+Shift+V` | Paste as Plain Text |
| `Alt+Shift+F` | Find in Files |
| `Alt+Shift+P` | Command Palette (VS Code) |
| `Alt+Shift+E` | Explorer Sidebar (VS Code) |

#### Text Navigation & Selection
| Shortcut | Action |
|---|---|
| `Alt+Left/Right` | Line Start / End |
| `Alt+Up/Down` | Document Start / End |
| `Alt+Backspace` | Delete to Line Start |
| `Alt+Shift+Left/Right` | Select to Line Start / End |
| `Alt+Shift+Up/Down` | Select to Document Start / End |

#### Tab & Zoom Management
| Shortcut | Action |
|---|---|
| `Alt+1~9` | Switch to Tab 1-9 |
| `Alt+0` | Reset Zoom |
| `Alt+=` | Zoom In |
| `Alt+-` | Zoom Out |
| `Alt+[` | Browser Back |
| `Alt+]` | Browser Forward |

#### Screenshots
| Shortcut | Action |
|---|---|
| `Alt+Shift+3` | Full Screen Screenshot |
| `Alt+Shift+4/5` | Snip & Sketch (Win+Shift+S) |

### 🎹 CapsLock Navigation Layer
Hold `CapsLock` to activate:

| Key | Action | Key | Action |
|---|---|---|---|
| `P/N` | Up / Down | `B/F` | Left / Right |
| `A/E` | Line Start / End | `D` | Delete |
| `H` | Kill Line (to end) | `X` | Backspace |
| `T` | Transpose Chars | `W/Q` | Word Right / Left |
| `V` | Page Down | `C` | Clipboard History |
| `I/K/J/L` | Mouse ↑↓←→ | `U/O` | Mouse Click L/R |

**CapsLock Tap** = Switch Input Method

### ⚙️ Settings & Management
*   **Graphical Settings UI**: Right-click the tray icon → `Settings`.
*   **Dynamic Hotkeys**: Remap any key binding without touching the code.
*   **Pause/Resume**: Toggle all hotkeys from the tray menu.
*   **Export/Import**: Backup and restore configuration.
*   **Process Exclusion**: Disable hotkeys in specific apps.
*   **Reset to Defaults**: One-click reset for General settings.

## Usage

1.  Download and install [AutoHotkey v2](https://www.autohotkey.com/).
2.  Run `MacKey4Windows.ahk`.
3.  Right-click the **Retro Mario** tray icon for Settings, Pause, Reload, Exit.

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
