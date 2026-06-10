#Requires AutoHotkey v2.0

; Автоматический перезапуск от имени администратора для работы в системных окнах
if not A_IsAdmin {
    try {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '"'
        else
            Run '*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"'
    }
    ExitApp
}

#SingleInstance Force

; Переключение между RU и EN по Ctrl+Shift (в любом порядке нажатия)
~*LCtrl::TrySwitch()
~*RCtrl::TrySwitch()
~*LShift::TrySwitch()
~*RShift::TrySwitch()

TrySwitch() {
    static lastTick := 0
    if !(GetKeyState("Ctrl", "P") && GetKeyState("Shift", "P"))
        return
    
    ; Защита от двойного срабатывания при одновременных событиях клавиш
    now := A_TickCount
    if (now - lastTick < 150)
        return
    lastTick := now
    
    ToggleRuEn()
}

ToggleRuEn() {
    static RU := 0x0419
    static EN := 0x0409
    
    ; Находим окно, у которого сейчас фокус ввода (это надежнее для системных окон)
    focusedHWND := ControlGetFocus("A")
    hwnd := focusedHWND ? focusedHWND : WinExist("A")
    
    if !hwnd
        return
    
    ; Получаем ID потока активного окна
    threadId := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "UInt*", 0, "UInt")
    hkl := DllCall("GetKeyboardLayout", "UInt", threadId, "UPtr")
    langId := hkl & 0xFFFF
    
    target := (langId = RU) ? EN : RU
    
    ; Мощный системный способ отправки сообщения (подходит для любых типов окон)
    DllCall("PostMessage", "Ptr", hwnd, "UInt", 0x0050, "Ptr", 1, "Ptr", target)
}