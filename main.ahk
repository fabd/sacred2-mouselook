#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent()
#Include Lib\WebView2\WebViewToo.ahk
#Include Lib\JSON.ahk

SetWorkingDir(A_ScriptDir)

; === Misc Script Config ===
; use absolute screen coordinates for all mouse-related commands (not relative to active window)
CoordMode "Mouse", "Screen"

; === Config globals & defaults ===
global MlookRMB := true
global MlookHybrid := true
global Key_LookLeft := "a"
global Key_LookRight := "d"
global Key_Forward := "w"
global Key_Backwards := "s"
global Key_MoveLeft := "u"
global Key_MoveRight := "o"
global Key_CombatArt := ""
global Key_VanityCam := "f10"
global RuneMaster := false

; === Runemaster feature ===
global RuneX := 2125
global RuneY := 530
global RuneXInc := 80
global RuneSlots := 4
global RuneEmptyRGB := 0x1a1a1a
global RuneEmptyRGBVar := 0x181818

global MyGui
global GUI_WIN_SIZE := "w540 h760"

IniPath := A_ScriptDir "\Sacred2Mouselook.ini"

LoadConfig()

ApplyHotkeys()

A_TrayMenu.Delete()
A_TrayMenu.Add("Open Configurator", OpenConfigurator)
A_TrayMenu.Add()
A_TrayMenu.Add("Reload", (*) => Reload())
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
  global Key_CombatArt, Key_VanityCam, RuneMaster, IniPath
  if (!FileExist(IniPath))
    return
  MlookRMB := IniRead(IniPath, "Config", "MlookRMB", "1") = "1"
  MlookHybrid := IniRead(IniPath, "Config", "MlookHybrid", "1") = "1"
  Key_LookLeft := IniRead(IniPath, "Config", "Key_LookLeft", "a")
  Key_LookRight := IniRead(IniPath, "Config", "Key_LookRight", "d")
  Key_Forward := IniRead(IniPath, "Config", "Key_Forward", "w")
  Key_Backwards := IniRead(IniPath, "Config", "Key_Backwards", "s")
  Key_MoveLeft := IniRead(IniPath, "Config", "Key_MoveLeft", "u")
  Key_MoveRight := IniRead(IniPath, "Config", "Key_MoveRight", "o")
  Key_CombatArt := IniRead(IniPath, "Config", "Key_CombatArt", "")
  Key_VanityCam := IniRead(IniPath, "Config", "Key_VanityCam", "f10")
  RuneMaster := IniRead(IniPath, "Config", "RuneMaster", "0") = "1"
}

SaveConfig(cfg) {
  global MlookRMB, MlookHybrid, Key_LookLeft, Key_LookRight
  global Key_Forward, Key_Backwards, Key_MoveLeft, Key_MoveRight
  global Key_CombatArt, Key_VanityCam, RuneMaster, IniPath
  MlookRMB := cfg["mlook-rmb"] = "1"
  MlookHybrid := cfg["mlook-hybrid"] = "1"
  Key_LookLeft := cfg["key-look-left"]
  Key_LookRight := cfg["key-look-right"]
  Key_Forward := cfg["key-forward"]
  Key_Backwards := cfg["key-backwards"]
  Key_MoveLeft := cfg["key-move-left"]
  Key_MoveRight := cfg["key-move-right"]
  Key_CombatArt := cfg["key-combat-art"]
  Key_VanityCam := cfg["key-vanity-cam"]
  RuneMaster := cfg["rune-master"] = "1"
  IniWrite(MlookRMB ? "1" : "0", IniPath, "Config", "MlookRMB")
  IniWrite(MlookHybrid ? "1" : "0", IniPath, "Config", "MlookHybrid")
  IniWrite(Key_LookLeft, IniPath, "Config", "Key_LookLeft")
  IniWrite(Key_LookRight, IniPath, "Config", "Key_LookRight")
  IniWrite(Key_Forward, IniPath, "Config", "Key_Forward")
  IniWrite(Key_Backwards, IniPath, "Config", "Key_Backwards")
  IniWrite(Key_MoveLeft, IniPath, "Config", "Key_MoveLeft")
  IniWrite(Key_MoveRight, IniPath, "Config", "Key_MoveRight")
  IniWrite(Key_CombatArt, IniPath, "Config", "Key_CombatArt")
  IniWrite(Key_VanityCam, IniPath, "Config", "Key_VanityCam")
  IniWrite(RuneMaster ? "1" : "0", IniPath, "Config", "RuneMaster")
}

SyncToWebView() {
  global MlookRMB, MlookHybrid, Key_LookLeft, Key_LookRight
  global Key_Forward, Key_Backwards, Key_MoveLeft, Key_MoveRight
  global Key_CombatArt, Key_VanityCam, RuneMaster, MyGui
  cfg := Map(
    "mlook-rmb", MlookRMB ? "1" : "0",
    "mlook-hybrid", MlookHybrid ? "1" : "0",
    "key-look-left", Key_LookLeft,
    "key-look-right", Key_LookRight,
    "key-forward", Key_Forward,
    "key-backwards", Key_Backwards,
    "key-move-left", Key_MoveLeft,
    "key-move-right", Key_MoveRight,
    "key-combat-art", Key_CombatArt,
    "key-vanity-cam", Key_VanityCam,
    "rune-master", RuneMaster ? "1" : "0"
  )
  MyGui.PostWebMessageAsJson(JSON.Stringify(cfg))
}

IsMlookRMBActive(*) => MlookRMB && WinActive("ahk_class The Forge")

ApplyHotkeys() {
  global Key_VanityCam

  if (Key_VanityCam != "") {
    HotIfWinActive "ahk_class The Forge"
    Hotkey Key_VanityCam, ToggleDrag, "On"
    HotIfWinActive
  }

  if (Key_CombatArt != "") {
    HotIfWinActive "ahk_class The Forge"
    Hotkey Key_CombatArt, CombatArtShortcut, "On"
    HotIfWinActive
  }

  if (MlookHybrid || MlookRMB) {
    HotIfWinActive "ahk_class The Forge"
    Hotkey "$" Key_LookLeft, LookLeft, "On"
    Hotkey "$" Key_LookRight, LookRight, "On"
    HotIfWinActive
  }

  if (MlookHybrid) {
    HotIfWinActive "ahk_class The Forge"
    Hotkey "$~" Key_Forward, MoveForwardDown, "On"
    Hotkey "$~" Key_Forward " up", MoveForwardUp, "On"
    Hotkey "$~" Key_Backwards, MoveForwardDown, "On"
    Hotkey "$~" Key_Backwards " up", MoveForwardUp, "On"
    HotIfWinActive
  }

  HotIf IsMlookRMBActive
  Hotkey "$RButton", RButtonDown, "On"
  Hotkey "$RButton up", RButtonUp, "On"
  HotIf

  if (RuneMaster) {
    Hotkey "$!+LButton", RuneMasterShortcut, "On"
    Hotkey "$!+F10", RuneMasterConfig, "On"
  }
}

RButtonDown(*) {
  Send "{MButton down}"
}

RButtonUp(*) {
  if (MlookHybrid
    && (GetKeyState(Key_Forward, "P")
    || GetKeyState(Key_Backwards, "P"))) {
    return
  }
  Send "{MButton up}"
}

MoveForwardDown(*) {
  Send "{MButton down}"
}

MoveForwardUp(*) {
  if (MlookHybrid == 1
    && (GetKeyState("RButton", "P")
    || GetKeyState(Key_MoveLeft)
    || GetKeyState(Key_MoveRight))) {
    return
  }

  Send "{MButton up}"
}

; Note: without down/up it doesn't work
LookLeft(*) {
  if (GetKeyState("MButton", "P")
  || GetKeyState("RButton", "P")
  || GetKeyState(Key_Forward, "P")
  || GetKeyState(Key_Backwards, "P")) {
    SendInput "{" Key_MoveLeft " down}"
    KeyWait Key_LookLeft
    SendInput "{" Key_MoveLeft " up}"
  } else {
    SendInput "{" Key_LookLeft " down}"
    KeyWait Key_LookLeft
    SendInput "{" Key_LookLeft " up}"
  }
}

LookRight(*) {
  if (GetKeyState("MButton", "P")
  || GetKeyState("RButton", "P")
  || GetKeyState(Key_Forward, "P")
  || GetKeyState(Key_Backwards, "P")) {
    SendInput "{" Key_MoveRight " down}"
    KeyWait Key_LookRight
    SendInput "{" Key_MoveRight " up}"
  } else {
    SendInput "{" Key_LookRight " down}"
    KeyWait Key_LookRight
    SendInput "{" Key_LookRight " up}"
  }
}

; Sends a right mouse button click when Key_CombatArt is pressed
CombatArtShortcut(*) {
  SendInput "{RButton down}"
  KeyWait Key_CombatArt
  SendInput "{RButton up}"
}

global dragging := false
global dragTimer := false

#HotIf WinActive("ahk_class The Forge") && dragging
Escape:: ToggleDrag()

#HotIf  ; end the context

ToggleDrag(*) {
  global dragging, dragTimer

  if dragging {
    dragging := false
    if dragTimer
      SetTimer dragTimer, 0
    Click "Middle Up"
    Sleep 100
    MouseMove A_ScreenWidth / 2, A_ScreenHeight / 2, 0
    return
  }

  dragging := true
  y := A_ScreenHeight - 1
  Sleep 50
  MouseMove 0, y, 1
  Sleep 50
  Click "Middle Down"

  dragTimer := DragAcrossScreen.Bind(y)
  SetTimer dragTimer, 16
}

DragAcrossScreen(y) {
  static x := 0
  global dragging

  if !dragging {
    x := 0
    return false  ; stop timer
  }

  x += 1
  MouseMove x, y, 0

  if x >= A_ScreenWidth - 1 {
    Click "Middle Up"
    Sleep 10
    MouseMove 0, y, 0
    Sleep 10
    Click "Middle Down"
    x := 0
  }
}

RuneMasterConfig(*) {
  MouseGetPos &coordX, &coordY
  SoundBeep
  MsgBox "RuneX " coordX " RuneY " coordY
}

RuneMasterShortcut(*) {
  MouseGetPos &runePickX, &runePickY

  ;BlockInput "MouseMove"

  ; Pick up the rune
  LeftMouseClick()
  Sleep 50

  targetR := (RuneEmptyRGB >> 16) & 0xFF
  targetG := (RuneEmptyRGB >> 8) & 0xFF
  targetB := RuneEmptyRGB & 0xFF

  tolR := (RuneEmptyRGBVar >> 16) & 0xFF
  tolG := (RuneEmptyRGBVar >> 8) & 0xFF
  tolB := RuneEmptyRGBVar & 0xFF

  loop RuneSlots {
    slotX := RuneX + (A_Index - 1) * RuneXInc

    pixColor := PixelGetColor(slotX, RuneY, "RGB")

    pixR := (pixColor >> 16) & 0xFF
    pixG := (pixColor >> 8) & 0xFF
    pixB := pixColor & 0xFF

    if (Abs(pixR - targetR) <= tolR
    && Abs(pixG - targetG) <= tolG
    && Abs(pixB - targetB) <= tolB) {
      MouseMove slotX, RuneY, 0
      Sleep 10
      LeftMouseClick()
      Sleep 100

      MouseMove runePickX, runePickY, 0
      BlockInput "MouseMoveOff"
      return
    }
  }

  ;BlockInput "MouseMoveOff"

  SoundBeep
}

LeftMouseClick(*) {
  Click "LButton down"
  Sleep 10
  Click "LButton up"
}