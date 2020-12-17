#NoEnv
#KeyHistory 0
#Persistent
#SingleInstance, Force
ListLines, Off
Process, Priority, , A
SetBatchLines, -1

FileSelectFile, File, 3, Cyberpunk2077.exe, Select your CyberPunk 2077 exe file, *.exe

if !File
	ExitApp

RegExMatch(File, "O)(?<folder>.*\\)(?<file>.*)\.(?<ext>.*)",Path)

MsgBox, 0x4, CyberPunk 2077 Patch, % "This program will backup your game file and try`nto patch the executable to fix virtual inputs.`n`nThis may take a minute.`n`nContinue?"
IfMsgBox, No
	ExitApp

oFile := FileOpen(File,"r")
FileSize := oFile.Length
VarSetCapacity(RawFile, FileSize)
oFile.RawRead(RawFile, FileSize)
VarSetCapacity(b,8,0)
NumPut(2771332824591254667, b, 0, "UInt64")

Loop % FileSize {
	if (DllCall("ntdll.dll\RtlCompareMemory", "ptr", &RawFile + (A_Index-1), "ptr", &b, "UInt64", 8) == 8) {
		FileCopy, % Path.folder . Path.file "." Path.ext, % Path.folder . Path.file "_bkp_" A_Now "." Path.ext, 1
		NumPut(2771332825596005174,RawFile, A_Index - 1, "UInt64")
		NewFile := Path.folder . Path.file "." Path.ext
		oNewFile := FileOpen(NewFile,"w")
		oNewFile.RawWrite(RawFile, FileSize)
		Found := true
	}
}
if Found
	MsgBox % "Data found and patched. Backup Saved.`nPress OK to exit."
else
	MsgBox % "Data not found. No actions were taken.`nPress OK to exit."
ExitApp