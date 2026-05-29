#Requires AutoHotkey v2.0
#SingleInstance Force
#Include WebView2\WebViewToo.ahk

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
  try msg := args.TryGetWebMessageAsString()
  catch
    return
  if (msg = "reload") {
    Reload()
    return
  }
  SaveConfig(msg)
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

SaveConfig(raw) {
  global MlookRMB, MlookHybrid, Key_LookLeft, Key_LookRight
  global Key_Forward, Key_Backwards, Key_MoveLeft, Key_MoveRight
  global Key_CombatArt, RuneMaster, IniPath
  cfg := ParseData(raw)
  MlookRMB    := GetVal(cfg, "rclick")    = "1"
  MlookHybrid := GetVal(cfg, "movelook")  = "1"
  Key_LookLeft  := GetVal(cfg, "lookLeft",  "a")
  Key_LookRight := GetVal(cfg, "lookRight", "d")
  Key_Forward   := GetVal(cfg, "forward",   "w")
  Key_Backwards := GetVal(cfg, "backwards", "s")
  Key_MoveLeft  := GetVal(cfg, "moveLeft",  "u")
  Key_MoveRight := GetVal(cfg, "moveRight", "o")
  Key_CombatArt := GetVal(cfg, "combatArtKey", "")
  RuneMaster    := GetVal(cfg, "runeMaster") = "1"
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
  q := Chr(34)
  json := "{"
  json .= q "rclick"       q ":" q (MlookRMB    ? "1" : "0") q ","
  json .= q "movelook"     q ":" q (MlookHybrid ? "1" : "0") q ","
  json .= q "lookLeft"     q ":" q Key_LookLeft  q ","
  json .= q "lookRight"    q ":" q Key_LookRight q ","
  json .= q "forward"      q ":" q Key_Forward   q ","
  json .= q "backwards"    q ":" q Key_Backwards q ","
  json .= q "moveLeft"     q ":" q Key_MoveLeft  q ","
  json .= q "moveRight"    q ":" q Key_MoveRight q ","
  json .= q "combatArtKey" q ":" q Key_CombatArt q ","
  json .= q "runeMaster"   q ":" q (RuneMaster   ? "1" : "0") q
  json .= "}"
  MyGui.PostWebMessageAsJson(json)
}

ParseData(raw) {
  result := Map()
  loop parse, raw, "|" {
    pos := InStr(A_LoopField, "=")
    if (pos > 0)
      result[SubStr(A_LoopField, 1, pos - 1)] := SubStr(A_LoopField, pos + 1)
  }
  return result
}

GetVal(cfg, key, default := "") {
  return cfg.Has(key) ? cfg[key] : default
}
