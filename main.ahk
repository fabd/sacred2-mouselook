#Requires AutoHotkey v2.0
#SingleInstance Force
#Include WebView2\WebViewToo.ahk

SetWorkingDir(A_ScriptDir)

MyGui := WebViewGui(, "Better Mouselook Controls Configurator")
MyGui.Navigate("ui/index.html")
MyGui.Show("w540 h760")
