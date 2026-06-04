#!/usr/bin/env bash
# =========================================================
# Build Script made by Claude Code
#
#   Usage:
#     ./build.sh
#
#   Pay attention to the //flags the double-slash is because of Git Bash
#   converting /slash flags to Windows paths! So //flag is escaped /flag.
# 
#   App Icon is generated with ImageMagick:
#
#     winget install ImageMagick.ImageMagick
#     magick gui/img/trayicon.png -define icon:auto-resize=16,24,32,48,64 gui/app.ico
#
# =========================================================
set -euo pipefail
cd "$(dirname "$0")"

# Override these if your AutoHotkey install lives elsewhere.
AHK2EXE="${AHK2EXE:-/c/Apps/AutoHotkey/Compiler/Ahk2Exe.exe}"
BASE="${BASE:-/c/Apps/AutoHotkey/v2/AutoHotkey64.exe}"   # 64-bit base
OUT="Sacred2-BMC.exe"

[ -f gui/app.ico ] || { echo "ERROR: app.ico not found."; exit 1; }

"$AHK2EXE" //in main.ahk //out "$OUT" //base "$BASE" //icon gui/app.ico
echo "Built: $OUT"
