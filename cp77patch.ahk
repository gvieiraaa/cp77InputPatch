#NoEnv
#KeyHistory 0
#SingleInstance, Force
ListLines, Off
Process, Priority, , A
SetBatchLines, -1

MsgBox, 0x4, CyberPunk 2077 Patch, % "This program will ask for your game's .exe location,`ntry to patch it to fix virtual inputs and make a backup`nin the same folder.`n`n`nThis may take a minute.`n`nContinue?"
IfMsgBox, No
	ExitApp

FileSelectFile, File, 3, Cyberpunk2077.exe, Select your CyberPunk 2077 exe file, *.exe

if !File
	ExitApp

RegExMatch(File, "O)(?<folder>.*\\)(?<file>.*)\.(?<ext>.*)",Path)

oFile := FileOpen(File,"r")
FileSize := oFile.Length
VarSetCapacity(RawFile, FileSize)
oFile.RawRead(RawFile, FileSize)
VarSetCapacity(b,8,0)
NumPut(0x2675C0855424448B, b, 0, "UInt64")

Loop % FileSize {
	if (DllCall("ntdll.dll\RtlCompareMemory", "ptr", &RawFile + (A_Index-1), "ptr", &b, "UInt64", 8) == 8) {
		Debug("Found at " A_Index)
		Debug("Making Backup")
		FileCopy, % Path.folder . Path.file "." Path.ext, % Path.folder . Path.file "_bkp_" A_Now "." Path.ext, 1
		NumPut(0x2675C08590078B36,RawFile, A_Index - 1, "UInt64")
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
