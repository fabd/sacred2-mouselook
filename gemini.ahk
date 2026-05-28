#Requires AutoHotkey v2.0
#SingleInstance Force

; === Configuration & Styling ===
MainColor := "FDF9F3"
TextColor := "242220"
TitleFont := "Arial"
LabelFont := "Arial"

WindowWidth := 475
ColRight := WindowWidth - 65

; === Window Setup ===
MyGui := Gui("-MinimizeBox", "Sacred 2 Mouselook Configurator")
MyGui.BackColor := MainColor
MyGui.SetFont("s10 c" TextColor)

; Running vertical position. Each element advances it. Bump it to add spacing.
Y := 20

; === Main Options ===
AddTitle(MyGui, "~~~ Main Options ~~~")
Y += 20
AddRow(MyGui, "Mouselook with Right Mouse Button", "Checkbox", "vRClick", "Checked")
AddRow(MyGui, "Mouselook while Moving Forward/Backwards", "Checkbox", "vMoveLook", "Checked")
AddRow(MyGui, "Combat Art Key", "Edit", "vCAKey", "R")
AddRow(MyGui, "RuneMaster (Alt + Shift + LMB)", "Checkbox", "vRuneMaster", "Checked")

Y += 25

; === In-Game Controls ===
AddTitle(MyGui, "~~~ In-Game Controls ~~~")
AddSubtitle(MyGui, "* Make sure these match your in-game keybinds! *")
Y += 10
AddRow(MyGui, "Key_LookLeft",  "Edit", "vLookL", "a")
AddRow(MyGui, "Key_LookRight", "Edit", "vLookR", "d")
AddRow(MyGui, "Key_Forward",   "Edit", "vMoveF", "w")
AddRow(MyGui, "Key_Backwards", "Edit", "vMoveB", "s")

Y += 25

; === Update Button ===
MyGui.SetFont("s14 w700", TitleFont)
BtnUpdate := MyGui.Add("Button", "Default w" WindowWidth-40 " h65 x20 y" Y, "UPDATE SCRIPT")
Y += 65 + 20

MyGui.Show("w" WindowWidth " h" Y)

; ====================== FUNCTIONS ======================

AddTitle(GuiObj, Text) {
    global Y, WindowWidth, TitleFont
    GuiObj.SetFont("s18 w700", TitleFont)
    GuiObj.Add("Text", "Center w" WindowWidth " y" Y, Text)
    Y += 45
}

AddSubtitle(GuiObj, Text) {
    global Y, WindowWidth
    GuiObj.SetFont("s10 italic")
    GuiObj.Add("Text", "Center w" WindowWidth " y" Y, Text)
    Y += 30
}

AddRow(GuiObj, Label, Type, VarName, Default) {
    global Y, ColRight, WindowWidth, LabelFont
    GuiObj.SetFont("s12 w400", LabelFont)

    ; Divider
    GuiObj.Add("Progress", "x0 y" Y " w" WindowWidth " h1 cCDC9C3 BackgroundCDC9C3 -Smooth", 100)

    ; Label
    GuiObj.Add("Text", "x20 y" Y+10 " w" ColRight, Label)

    ; Control
    if (Type = "Checkbox") {
        GuiObj.Add("Checkbox", "x" ColRight " y" Y+5 " " VarName " " Default)
    } else {
        GuiObj.Add("Edit", "x" ColRight " y" Y+7 " w45 Center " VarName, Default)
    }

    Y += 40
}
