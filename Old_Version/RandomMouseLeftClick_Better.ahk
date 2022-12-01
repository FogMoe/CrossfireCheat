#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%
~lbutton::
Loop,{
if not GetKeyState("lbutton", "P")
break
send,{LCtrl}
send,{lbutton down}
Sleep, 10
send,{LCtrl}
send,{lbutton up}
Sleep, 10
}
return
NumpadSub::suspend on
NumpadAdd::suspend off