# Sacred2MouselookDEV2

AutoHotkey v2 GUI configurator for Sacred 2 mouselook settings.

## Language & Runtime

- AutoHotkey v2.0 (not v1). Syntax is incompatible with v1 — never use v1 patterns.

## Code Style

- **Indentation: 2 spaces.** Never use tabs.
- Opening braces on the same line as the block header (`if (...) {`, `FuncName(...) {`).
- Variable names: PascalCase for globals and GUI controls, camelCase for locals.
- Comments use `;` (single-line only in AHK).

## AHK v2 Key Rules

- Event callbacks use fat-arrow or named functions bound with `.OnEvent()` or `OnMessage()`.
- No `StringLen`, `IfEqual`, or other v1 legacy commands.

## GUI Layout Pattern

This project uses a running vertical cursor (`Y`) to stack rows:

```ahk
Y := 20                          ; initial top margin
AddTitle(MyGui, "Section")       ; advances Y internally
AddRow(MyGui, "Label", ...)      ; advances Y by 40 per row
Y += 25                          ; manual spacer between sections
MyGui.Show("w" WindowWidth " h" Y)
```

Each helper function (`AddTitle`, `AddSubtitle`, `AddRow`) reads and mutates `Y` via `global Y`.
