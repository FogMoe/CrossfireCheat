#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%
~lbutton::
Loop,{
if not GetKeyState("lbutton", "P")
break
send,{lbutton down}
Random, randA, 38, 74
Sleep, randA
send,{lbutton up}
Random, randB, 21, 65
Sleep, randB
}
return
NumpadSub::suspend on
NumpadAdd::suspend off