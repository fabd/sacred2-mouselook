#Requires AutoHotkey v2.0
#SingleInstance Force
#Include WebView2\WebViewToo.ahk
#Include Lib\JSON.ahk

SetWorkingDir(A_ScriptDir)

; === Config globals & defaults ===
global MlookRMB    := true
global MlookHybrid := true
global Key_LookLeft  := "a"
global Key_LookRight := "d"
global Key_Forward   := "w"
global Key_Backwards := "s"
global Key_MoveLeft  := "u"
global Key_MoveRight := "o"
global Key_CombatArt := ""
global RuneMaster    := false

IniPath := A_ScriptDir "\Sacred2Mouselook.ini"

LoadConfig()
  
MyGui := WebViewGui(, "Better Mouselook Controls Configurator")
  
MyGui.NavigationCompleted(OnNavigationCompleted)
MyGui.WebMessageReceived(OnWebMessage)
MyGui.Navigate("ui/index.html")
MyGui.Show("w540 h760")

OnNavigationCompleted(wv, args) {
  SyncToWebView()
}

OnWebMessage(wv, args) {
  cfg := JSON.Parse(args.WebMessageAsJson)
  if (cfg["type"] = "reload-ahk") {
    Reload()
    return
  }
  if (cfg["type"] = "save-settings") {
    SaveConfig(cfg)
    return
  }
}

LoadConfig() {
  global MlookRMB, MlookHybrid, Key_LookLeft, Key_LookRight
  global Key_Forward, Key_Backwards, Key_MoveLeft, Key_MoveRight
  global Key_CombatArt, RuneMaster, IniPath
  if (!FileExist(IniPath))
    return
  MlookRMB    := IniRead(IniPath, "Config", "MlookRMB",    "1") = "1"
  MlookHybrid := IniRead(IniPath, "Config", "MlookHybrid", "1") = "1"
  Key_LookLeft  := IniRead(IniPath, "Config", "Key_LookLeft",  "a")
  Key_LookRight := IniRead(IniPath, "Config", "Key_LookRight", "d")
  Key_Forward   := IniRead(IniPath, "Config", "Key_Forward",   "w")
  Key_Backwards := IniRead(IniPath, "Config", "Key_Backwards", "s")
  Key_MoveLeft  := IniRead(IniPath, "Config", "Key_MoveLeft",  "u")
  Key_MoveRight := IniRead(IniPath, "Config", "Key_MoveRight", "o")
  Key_CombatArt := IniRead(IniPath, "Config", "Key_CombatArt", "")
  RuneMaster    := IniRead(IniPath, "Config", "RuneMaster",    "0") = "1"
}

SaveConfig(cfg) {
  global MlookRMB, MlookHybrid, Key_LookLeft, Key_LookRight
  global Key_Forward, Key_Backwards, Key_MoveLeft, Key_MoveRight
  global Key_CombatArt, RuneMaster, IniPath
  MlookRMB      := cfg["rclick"]       = "1"
  MlookHybrid   := cfg["movelook"]     = "1"
  Key_LookLeft  := cfg["lookLeft"]
  Key_LookRight := cfg["lookRight"]
  Key_Forward   := cfg["forward"]
  Key_Backwards := cfg["backwards"]
  Key_MoveLeft  := cfg["moveLeft"]
  Key_MoveRight := cfg["moveRight"]
  Key_CombatArt := cfg["combatArtKey"]
  RuneMaster    := cfg["runeMaster"]   = "1"
  IniWrite(MlookRMB    ? "1" : "0", IniPath, "Config", "MlookRMB")
  IniWrite(MlookHybrid ? "1" : "0", IniPath, "Config", "MlookHybrid")
  IniWrite(Key_LookLeft,  IniPath, "Config", "Key_LookLeft")
  IniWrite(Key_LookRight, IniPath, "Config", "Key_LookRight")
  IniWrite(Key_Forward,   IniPath, "Config", "Key_Forward")
  IniWrite(Key_Backwards, IniPath, "Config", "Key_Backwards")
  IniWrite(Key_MoveLeft,  IniPath, "Config", "Key_MoveLeft")
  IniWrite(Key_MoveRight, IniPath, "Config", "Key_MoveRight")
  IniWrite(Key_CombatArt, IniPath, "Config", "Key_CombatArt")
  IniWrite(RuneMaster    ? "1" : "0", IniPath, "Config", "RuneMaster")
}

SyncToWebView() {
  global MlookRMB, MlookHybrid, Key_LookLeft, Key_LookRight
  global Key_Forward, Key_Backwards, Key_MoveLeft, Key_MoveRight
  global Key_CombatArt, RuneMaster, MyGui
  cfg := Map(
    "rclick",       MlookRMB    ? "1" : "0",
    "movelook",     MlookHybrid ? "1" : "0",
    "lookLeft",     Key_LookLeft,
    "lookRight",    Key_LookRight,
    "forward",      Key_Forward,
    "backwards",    Key_Backwards,
    "moveLeft",     Key_MoveLeft,
    "moveRight",    Key_MoveRight,
    "combatArtKey", Key_CombatArt,
    "runeMaster",   RuneMaster   ? "1" : "0"
  )
  MyGui.PostWebMessageAsJson(JSON.Stringify(cfg))
}

