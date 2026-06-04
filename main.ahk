#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent()
#Include lib\WebView2\WebViewToo.ahk
#Include lib\JSON.ahk

SetWorkingDir(A_ScriptDir)

TraySetIcon(A_ScriptDir "\gui\img\trayicon.png")

A_IconTip := "Better Mouselook Controls"

; === Misc Script Config ===
; use absolute screen coordinates for all mouse-related commands (not relative to active window)
CoordMode "Mouse", "Screen"

; === Config globals & defaults ===
global MlookRMB := true
global MlookHybrid := false
global Key_LookLeft := "a"
global Key_LookRight := "d"
global Key_Forward := "w"
global Key_Backwards := "s"
global Key_MoveLeft := "u"
global Key_MoveRight := "o"
global Key_CombatArt := ""
global Key_VanityCam := "f10"
global RuneMaster := false
global RuneMasterX := 0
global RuneMasterY := 0

; === Look hotkey state ===
global LookLeftActiveKey := ""   ; key currently held down by the look-left hotkey ("" = none)
global LookRightActiveKey := ""  ; key currently held down by the look-right hotkey ("" = none)

; === Runemaster feature ===
global RuneXInc := 80
global RuneSlots := 4
global RuneEmptyRGB := 0x1a1a1a
global RuneEmptyRGBVar := 0x181818

global MyGui
global GUI_WIN_SIZE := "w980 h620"

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

; Register the NavigationStarting event
MyGui.NavigationStarting(OnNavigationStarting)

MyGui.NavigationCompleted(OnNavigationCompleted)
MyGui.WebMessageReceived(OnWebMessage)
MyGui.Navigate("gui/index.html")

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

; Handle links clicked in the webview, open them in user's browser.
OnNavigationStarting(wvObj, args) {
  ; Get the URL that the webview is attempting to load
  targetUrl := args.Uri

  ; Allow the local app page (served from the virtual host), the initial
  ; blank page and inline data URIs to load normally inside the webview.
  if (InStr(targetUrl, "://ahk.localhost/")
  || targetUrl == "about:blank"
  || InStr(targetUrl, "data:text/html")) {
    return
  }

  ; Anything else is an external link - cancel the in-webview navigation
  ; and open the URL in the user's default web browser instead.
  args.Cancel := true
  Run(targetUrl)
}

LoadConfig() {
  global MlookRMB, MlookHybrid, Key_LookLeft, Key_LookRight
  global Key_Forward, Key_Backwards, Key_MoveLeft, Key_MoveRight
  global Key_CombatArt, Key_VanityCam, RuneMaster, RuneMasterX, RuneMasterY, IniPath
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
  RuneMasterX := Integer(IniRead(IniPath, "Config", "RuneX", "0"))
  RuneMasterY := Integer(IniRead(IniPath, "Config", "RuneY", "0"))
}

SaveConfig(cfg) {
  global MlookRMB, MlookHybrid, Key_LookLeft, Key_LookRight
  global Key_Forward, Key_Backwards, Key_MoveLeft, Key_MoveRight
  global Key_CombatArt, Key_VanityCam, RuneMaster, RuneMasterX, RuneMasterY, IniPath
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
  IniWrite(RuneMasterX, IniPath, "Config", "RuneX")
  IniWrite(RuneMasterY, IniPath, "Config", "RuneY")
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
    Hotkey "$" Key_LookLeft, LookLeftDown, "On"
    Hotkey "$" Key_LookLeft " up", LookLeftUp, "On"
    Hotkey "$" Key_LookRight, LookRightDown, "On"
    Hotkey "$" Key_LookRight " up", LookRightUp, "On"
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
    Hotkey "$!LButton", RuneMasterShortcut, "On"
    Hotkey "$!F10", RuneMasterConfig, "On"
  }
}

IsMlookHybridActive(*) {
  return MlookHybrid
    && (GetKeyState(Key_Forward, "P")
    || GetKeyState(Key_Backwards, "P"))
}

IsMlookClassicActive(*) {
  return GetKeyState("RButton", "P")
}

RButtonDown(*) {
  Send "{MButton down}"
}

RButtonUp(*) {
  if (IsMlookHybridActive()) {
    return
  }
  Send "{MButton up}"
}

MoveForwardDown(*) {
  Send "{MButton down}"
}

MoveForwardUp(*) {
  if (MlookHybrid == 1
    && (IsMlookClassicActive()
    || GetKeyState(Key_MoveLeft)
    || GetKeyState(Key_MoveRight))) {
    return
  }

  Send "{MButton up}"
}

; True when we should steer with movement keys instead of look keys
; (mouse-look active, or hybrid forward/back movement in progress)
InMouselookMode() {
  return GetKeyState("MButton", "P")
  || IsMlookClassicActive()
  || IsMlookHybridActive()
}

LookLeftDown(*) {
  global LookLeftActiveKey
  if (LookLeftActiveKey != "")          ; already held (OS auto-repeat) - ignore
    return
  LookLeftActiveKey := InMouselookMode() ? Key_MoveLeft : Key_LookLeft
  SendInput "{" LookLeftActiveKey " down}"
}

LookLeftUp(*) {
  global LookLeftActiveKey
  if (LookLeftActiveKey = "")
    return
  SendInput "{" LookLeftActiveKey " up}"
  LookLeftActiveKey := ""

  if (!IsMlookHybridActive() && !IsMlookClassicActive()) {
    Send "{MButton up}"
  }
}

LookRightDown(*) {
  global LookRightActiveKey
  if (LookRightActiveKey != "")
    return
  LookRightActiveKey := InMouselookMode() ? Key_MoveRight : Key_LookRight
  SendInput "{" LookRightActiveKey " down}"
}

LookRightUp(*) {
  global LookRightActiveKey
  if (LookRightActiveKey = "")
    return
  SendInput "{" LookRightActiveKey " up}"
  LookRightActiveKey := ""

  if (!IsMlookHybridActive() && !IsMlookClassicActive()) {
    Send "{MButton up}"
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
  global RuneMasterX, RuneMasterY
  MouseGetPos &coordX, &coordY
  SoundBeep
  RuneMasterX := coordX
  RuneMasterY := coordY
  MsgBox "RuneMaster Shortcut configured.`n`nUse Alt Left click to move runes from your inventory.`n`nRemember to click the Save button!",
    "Better Mouselook Controls"
}

RuneMasterShortcut(*) {
  MouseGetPos &runePickX, &runePickY

  ;BlockInput "MouseMove"

  ; Pick up the rune
  LeftMouseClick()
  Sleep 16

  loop RuneSlots {
    slotX := RuneMasterX + (A_Index - 1) * RuneXInc

    if (IsRuneSlotEmpty(slotX, RuneMasterY)) {
      MouseMove slotX, RuneMasterY, 16
      Sleep 50 ; let the slot register hover
      LeftMouseClick() ; drop
      Sleep 50

      MouseMove runePickX, runePickY, 0
      BlockInput "MouseMoveOff"
      return
    }
  }

  ;BlockInput "MouseMoveOff"

  SoundBeep
}

; Returns true if all three sampled pixels at (x, y), (x - 10, y) and (x + 10, y)
; match RuneEmptyRGB within RuneEmptyRGBVar tolerance
IsRuneSlotEmpty(x, y) {
  global RuneEmptyRGB, RuneEmptyRGBVar

  targetR := (RuneEmptyRGB >> 16) & 0xFF
  targetG := (RuneEmptyRGB >> 8) & 0xFF
  targetB := RuneEmptyRGB & 0xFF

  tolR := (RuneEmptyRGBVar >> 16) & 0xFF
  tolG := (RuneEmptyRGBVar >> 8) & 0xFF
  tolB := RuneEmptyRGBVar & 0xFF

  PixelMatches(px, py) {
    pixColor := PixelGetColor(px, py, "RGB")

    pixR := (pixColor >> 16) & 0xFF
    pixG := (pixColor >> 8) & 0xFF
    pixB := pixColor & 0xFF

    return (Abs(pixR - targetR) <= tolR
    && Abs(pixG - targetG) <= tolG
    && Abs(pixB - targetB) <= tolB)
  }

  return (PixelMatches(x, y)
  && PixelMatches(x - 10, y)
  && PixelMatches(x + 10, y))
}

LeftMouseClick(*) {
  Click "LButton down"
  Sleep 50
  Click "LButton up"
}
