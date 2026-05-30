#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent()
#Include Lib\WebView2\WebViewToo.ahk
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

global MyGui
global GUI_WIN_SIZE := "w540 h760"

IniPath := A_ScriptDir "\Sacred2Mouselook.ini"

LoadConfig()

A_TrayMenu.Delete()
A_TrayMenu.Add("Open Configurator", OpenConfigurator)
A_TrayMenu.Add()
A_TrayMenu.Add("Quit", (*) => ExitApp())
A_TrayMenu.Default := "Open Configurator"
A_TrayMenu.ClickCount := 1 ; use single-click to show the window

MyGui := WebViewGui("-Caption", "Better Mouselook Controls Configurator")

MyGui.NavigationCompleted(OnNavigationCompleted)
MyGui.WebMessageReceived(OnWebMessage)
MyGui.Navigate("ui/index.html")

if (!FileExist(IniPath))
  MyGui.Show(GUI_WIN_SIZE)

OpenConfigurator(*) {
  global MyGui, GUI_WIN_SIZE
  MyGui.Show(GUI_WIN_SIZE)
}

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
  MlookRMB      := cfg["mlook-rmb"]    = "1"
  MlookHybrid   := cfg["mlook-hybrid"] = "1"
  Key_LookLeft  := cfg["key-look-left"]
  Key_LookRight := cfg["key-look-right"]
  Key_Forward   := cfg["key-forward"]
  Key_Backwards := cfg["key-backwards"]
  Key_MoveLeft  := cfg["key-move-left"]
  Key_MoveRight := cfg["key-move-right"]
  Key_CombatArt := cfg["key-combat-art"]
  RuneMaster    := cfg["rune-master"]  = "1"
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
    "mlook-rmb",     MlookRMB    ? "1" : "0",
    "mlook-hybrid",  MlookHybrid ? "1" : "0",
    "key-look-left",  Key_LookLeft,
    "key-look-right", Key_LookRight,
    "key-forward",   Key_Forward,
    "key-backwards", Key_Backwards,
    "key-move-left",  Key_MoveLeft,
    "key-move-right", Key_MoveRight,
    "key-combat-art", Key_CombatArt,
    "rune-master",   RuneMaster   ? "1" : "0"
  )
  MyGui.PostWebMessageAsJson(JSON.Stringify(cfg))
}

