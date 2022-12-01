#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%
;https://github.com/scarletkc/CrossfireCheat
mouse_sendinput_xy(x2, y2, Absolute := False)
{
    global Mon_Width, Mon_Hight, gmok
    
    static SysX, SysY
    SysX := 65535 // Mon_Width, SysY := 65535 // Mon_Hight
    static INPUT_MOUSE := 0, MOUSEEVENTF_MOVE := 0x0001, MOUSEEVENTF_ABSOLUTEMOVE := 0x8001
    Origin_Status := SPI_GETMOUSE(), PrevSpeed := SPI_GETMOUSESPEED()
    StructSize := A_PtrSize + 4*4 + A_PtrSize*2
    VarSetCapacity(MouseInput_Move, StructSize)
    NumPut(INPUT_MOUSE, MouseInput_Move, "UInt")

    If Absolute
        x2 *= SysX, y2 *= SysY
    Else
    {
        DPI_Ratio := Round(A_ScreenDPI / 96, 3)
        x2 := (x2 != 0) ? (x2 / Abs(x2) * Ceil(Abs(x2) / DPI_Ratio)) : 0
        y2 := (y2 != 0) ? (y2 / Abs(y2) * Ceil(Abs(y2) / DPI_Ratio)) : 0

        Random, RandXY, -1, 1
        If (x2 = 0) && (y2 > 2)
            x2 := RandXY
        Else If (y2 = 0) && (x2 > 2)
            y2 := RandXY
    }

    NumPut(x2, MouseInput_Move, A_PtrSize, "UInt")
    NumPut(y2, MouseInput_Move, A_PtrSize + 4, "UInt")
    If Absolute
        NumPut(MOUSEEVENTF_ABSOLUTEMOVE, MouseInput_Move, A_PtrSize + 4*3, "UInt")
    Else
        NumPut(MOUSEEVENTF_MOVE, MouseInput_Move, A_PtrSize + 4*3, "UInt")

    If Origin_Status
        SPI_SETMOUSE(0)
    If PrevSpeed != 10
        SPI_SETMOUSESPEED()

    If gmok
        DllCall("ghub_mouse.dll\Mach_Move", "Char", x2, "Char", y2, "Int", 0)
    Else
        DllCall("SendInput", "UInt", 1, "Ptr", &MouseInput_Move, "Int", StructSize)
    VarSetCapacity(MouseInput_Move, 0) 

    If Origin_Status
        SPI_SETMOUSE(1)
    If PrevSpeed != 10
        SPI_SETMOUSESPEED(PrevSpeed)
}
mouseXY(x1, y1, Absolute := False, sendinput_method := True)
{
    If sendinput_method
    {
        mouse_sendinput_xy(x1, y1, Absolute)
        Return
    }
    global Mon_Width, Mon_Hight
    static SysX, SysY
    SysX := 65535 // Mon_Width, SysY := 65535 // Mon_Hight
    static MOUSEEVENTF_MOVE := 0x0001, MOUSEEVENTF_ABSOLUTEMOVE := 0x8000
    dwFlags := (!Absolute ? MOUSEEVENTF_MOVE : MOUSEEVENTF_ABSOLUTEMOVE)
    Origin_Status := SPI_GETMOUSE()
    PrevSpeed := SPI_GETMOUSESPEED()

    If Absolute
        x1 *= SysX, y1 *= SysY
    Else
    {
        DPI_Ratio := Round(A_ScreenDPI / 96, 3)
        x1 := (x1 != 0) ? (x1 / Abs(x1) * Ceil(Abs(x1) / DPI_Ratio)) : 0
        y1 := (y1 != 0) ? (y1 / Abs(y1) * Ceil(Abs(y1) / DPI_Ratio)) : 0

        Random, RandXY, -1, 1
        If (x1 = 0) && (y1 > 2)
            x1 := RandXY
        Else If (y1 = 0) && (x1 > 2)
            y1 := RandXY
    }

    If Origin_Status
        SPI_SETMOUSE(0)
    If PrevSpeed != 10
        SPI_SETMOUSESPEED()

    DllCall("mouse_event", "UInt", dwFlags, "Int", x1, "Int", y1, "UInt", 0, "Int", 0)

    If Origin_Status
        SPI_SETMOUSE(1)
    If PrevSpeed != 10
        SPI_SETMOUSESPEED(PrevSpeed)
}
SPI_GETMOUSESPEED()
{
    PrevSpeed :=
    DllCall("SystemParametersInfo", "UInt", 0x70, "UInt", 0, "UIntP", PrevSpeed, "UInt", 0)
    Return PrevSpeed
}
SPI_SETMOUSESPEED(MOUSESPEED := 10)
{
    DllCall("SystemParametersInfo", "UInt", 0x71, "UInt", 0, "Ptr", MOUSESPEED, "UInt", 0)
}
SPI_GETMOUSE()
{
    VarSetCapacity(SpeedValue, 12)
    If !DllCall("SystemParametersInfo", "Uint", 3, "Uint", 0, "Uint", &SpeedValue, "Uint", 0)
        Return False 
    Return NumGet(SpeedValue, 4) 
}
SPI_SETMOUSE(accel, low := "", high := "", fWinIni := 0)
{
    VarSetCapacity(SpeedValue, 12)
    , NumPut(accel
    , NumPut(high != "" ? high : accel ? 10 : 0
    , NumPut(low != "" ? low : accel ? 6 : 0, SpeedValue)))
    Return 0 != DllCall("SystemParametersInfo", "Uint", 4, "Uint", 0, "Uint", &SpeedValue, "Uint", 0)
}
~lbutton::
trigger:=0
Loop,{
if not GetKeyState("lbutton", "P"){
returnValue:=32*trigger
mouseXY(0, -returnValue)
send,{LCtrl up}
Random, randXY, 60, 100 
mouseXY(0, randXY)
break
}
if(trigger=3){
send,{LCtrl down}
Random, randXY, -60, -100 
mouseXY(0, randXY)
}
if(trigger<10){
trigger:=trigger+1
mouseXY(0, 32)
}
send,{lbutton down}
Random, randB, 21, 65
Sleep, randB
send,{lbutton up}
Random, randA, 38, 74
Sleep, randA
}
return
~RButton::suspend on
~MButton::suspend off

;https://github.com/scarletkc/CrossfireCheat