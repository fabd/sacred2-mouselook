#Requires AutoHotkey v2.0
#SingleInstance Force

; === Configuration & Styling ===
MainColor := "FDF9F3"
TextColor := "242220"
TitleFont := "Georgia"
LabelFont := "Georgia"

WindowWidth := 420
WindowHeight := 520
ColRight := WindowWidth - 85

; === Window Setup ===
MyGui := Gui("-MinimizeBox", "Sacred 2 Mouselook Configurator")
MyGui.BackColor := MainColor
MyGui.SetFont("s10 c" TextColor)

; === Main Options ===
MyGui.SetFont("s18 w700", TitleFont)
MyGui.Add("Text", "Center w" WindowWidth " y20", "~~~ Main Options ~~~")

MyGui.SetFont("s12 w400", LabelFont)
AddRow(MyGui, "Mouselook with Right Mouse Button", "Checkbox", "vRClick", "Checked", 70)
AddRow(MyGui, "Mouselook while Moving", "Checkbox", "vMoveLook", "Checked", 110)
AddRow(MyGui, "Combat Art Key", "Edit", "vCAKey", "R", 150)
AddRow(MyGui, "RuneMaster (Alt + Shift + LMB)", "Checkbox", "vRuneMaster", "Checked", 190)

; === In-Game Controls ===
MyGui.SetFont("s18 w700", TitleFont)
MyGui.Add("Text", "Center w" WindowWidth " y255", "~~~ In-Game Controls ~~~")

MyGui.SetFont("s10 italic")
MyGui.Add("Text", "Center w" WindowWidth " y290", "* Make sure these match your in-game keybinds! *")

MyGui.SetFont("s12 w400", LabelFont)
AddRow(MyGui, "Key_LookLeft",  "Edit", "vLookL", "a", 325)
AddRow(MyGui, "Key_LookRight", "Edit", "vLookR", "d", 355)
AddRow(MyGui, "Key_Forward",   "Edit", "vMoveF", "w", 385)
AddRow(MyGui, "Key_Backwards", "Edit", "vMoveB", "s", 415)

; === Update Button ===
MyGui.SetFont("s14 w700", TitleFont)
BtnUpdate := MyGui.Add("Button", "Default w" WindowWidth-40 " h65 x20 y460", "UPDATE SCRIPT")

MyGui.Show("w" WindowWidth " h" WindowHeight)

; ====================== FUNCTIONS ======================

AddRow(GuiObj, Label, Type, VarName, Default, YPos) {
    global ColRight, WindowWidth

    ; Divider
    ;GuiObj.Add("Text", "x0 y" YPos " w" WindowWidth " h1 +0x10")
    GuiObj.Add("Progress", "x0 y" YPos " w" WindowWidth " h1 cDDD9D3 BackgroundDDD9D3 -Smooth", 100)

    ; Label
    GuiObj.Add("Text", "x20 y" YPos+10 " w260", Label)

    ; Control
    if (Type = "Checkbox") {
        GuiObj.Add("Checkbox", "x" ColRight " y" YPos+5 " " VarName " " Default)
    } else {
        GuiObj.Add("Edit", "x" ColRight " y" YPos+2 " w45 Center " VarName, Default)
    }
}
