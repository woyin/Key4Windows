LShift::
    keyWait, LShift, T-1.01
    if (ErrorLevel) {
        startTime := A_TickCount
        while GetKeyState("LShift", "P") {
            if ((A_TickCount - startTime) > ShiftThreshold) {
                SendInput, {LShift down}
                KeyWait, LShift
                SendInput, {LShift up}
                return
            }
        }
        Send, {(}
    }
return

RShift::
    keyWait, RShift, T-1.01
    if (ErrorLevel) {
        startTime := A_TickCount
        while GetKeyState("RShift", "P") {
            if ((A_TickCount - startTime) > ShiftThreshold) {
                SendInput, {RShift down}
                KeyWait, RShift
                SendInput, {RShift up}
                return
            }
        }
        Send, {)}
    }
return