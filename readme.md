# LinuxKey 2.0

这是一个基于 AutoHotkey v2 的 Windows 键盘增强工具，旨在为 Windows 用户提供类似 Linux/macOS 的高效键盘体验。特别适合 60% 键盘用户和开发者。

## ✨ 核心功能

### 1. CapsLock 增强
*   **短按**：切换输入法（发送 `Win+Space`），并在光标处显示**红底白字**的提示。
*   **长按（作为修饰键）**：
    *   **光标移动**：
        *   `CapsLock + P / N`：上 / 下
        *   `CapsLock + B / F`：左 / 右
        *   `CapsLock + A / E`：行首 (Home) / 行尾 (End)
    *   **编辑**：
        *   `CapsLock + D`：删除 (Delete)
        *   `CapsLock + C`：调用 Ditto 剪贴板 (Ctrl+Shift+Alt+C)
    *   **鼠标控制**（🆕 新功能）：
        *   `CapsLock + I / K`：鼠标上移 / 下移
        *   `CapsLock + J / L`：鼠标左移 / 右移
        *   `CapsLock + U`：鼠标左键单击
        *   `CapsLock + O`：鼠标右键单击

### 2. Shift 增强
*   **短按**：
    *   `左 Shift`：输入 `(`
    *   `右 Shift`：输入 `)`
*   **长按 / 组合键**：保持原始 Shift 功能（无延迟，瞬间响应）。

### 3. macOS 风格快捷键
使用 `Alt` 键模拟 macOS 的 `Command` 键，让 Windows 操作更符合直觉：

*   **常用命令**：
    *   `Alt + C / V / X`：复制 / 粘贴 / 剪切
    *   `Alt + Z / Y`：撤销 / 重做
    *   `Alt + A`：全选
    *   `Alt + S`：保存
    *   `Alt + F`：查找
    *   `Alt + N`：新建窗口
    *   `Alt + O`：打开文件
    *   `Alt + P`：打印
    *   `Alt + W`：关闭标签页
    *   `Alt + Q`：关闭窗口 (Alt+F4)
    *   `Alt + H / M`：最小化窗口
*   **文本导航**：
    *   `Alt + ← / →`：行首 / 行尾
    *   `Alt + ↑ / ↓`：文档顶部 / 底部
*   **编辑**：
    *   `Alt + Backspace`：删除至行首
    *   `Alt + /`：注释代码 (Ctrl+/)

## ⚙️ 配置说明

在脚本同目录下会自动生成 `settings.ini` 文件，你可以修改以下配置：

```ini
[General]
; 长按判定时间 (毫秒)，默认 150ms
HoldTimeout=150
; 鼠标移动速度，默认 10
MouseSpeed=10

[ExcludedApps]
; 黑名单程序（逗号分隔），在这些程序中脚本会自动失效
; 例如：玩游戏时禁用
ProcessNames=csgo.exe,overwatch.exe,valorant.exe
```

## 🚀 安装与运行

1.  确保已安装 [AutoHotkey v2](https://www.autohotkey.com/v2/)。
2.  下载本项目。
3.  双击运行 `LinuxKey2.0.ahk`。

## 📝 更新日志 (v2.0)

*   **重构**：代码全面升级至 AHK v2，逻辑更清晰。
*   **性能**：重写 Shift 和 CapsLock 逻辑，消除输入延迟，响应极快。
*   **新功能**：
    *   新增鼠标模拟功能。
    *   新增大量 macOS 风格快捷键。
    *   新增输入法切换视觉提示（跟随光标）。
    *   新增配置文件 (`settings.ini`) 和黑名单功能。
