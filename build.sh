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
set -uo pipefail
cd "$(dirname "$0")"

# Override these if your AutoHotkey install lives elsewhere.
AHK2EXE="${AHK2EXE:-/c/Apps/AutoHotkey/Compiler/Ahk2Exe.exe}"
BASE="${BASE:-/c/Apps/AutoHotkey/v2/AutoHotkey64.exe}"   # 64-bit base
OUT="dist/Better-Mouse-Controls.exe"

# ----- colors (disabled when not a TTY or when NO_COLOR is set) -----
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  RED=$'\033[1;31m'; GREEN=$'\033[1;32m'; YELLOW=$'\033[1;33m'
  CYAN=$'\033[1;36m'; DIM=$'\033[2m'; RESET=$'\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; CYAN=''; DIM=''; RESET=''
fi

ok()    { printf '%s\n' "${GREEN}✔${RESET} $*"; }
info()  { printf '%s\n' "${CYAN}▸${RESET} $*"; }
fail()  { printf '%s\n' "${RED}✖${RESET} ${RED}$*${RESET}" >&2; }

die() { fail "$*"; exit 1; }

# ----- preflight checks -----
[ -f "$AHK2EXE" ] || die "Ahk2Exe not found: $AHK2EXE (set AHK2EXE=... to override)"
[ -f "$BASE" ]    || die "Base exe not found: $BASE (set BASE=... to override)"
[ -f gui/app.ico ] || die "gui/app.ico not found — generate it (see header) then retry."

printf '%s\n' "${CYAN}Building ${OUT}...${RESET}"
info "compiler: ${DIM}${AHK2EXE}${RESET}"
info "base:     ${DIM}${BASE}${RESET}"

# ----- compile (capture output + exit code, note time to confirm a fresh build) -----
before=$(date +%s)
output="$("$AHK2EXE" //in main.ahk //base "$BASE" //icon gui/app.ico //out "$OUT" 2>&1)"
status=$?

[ -n "$output" ] && printf '%s\n' "${DIM}${output}${RESET}"

# Success requires a zero exit AND a freshly-written exe (Ahk2Exe doesn't always
# report failures via its exit code, so we also verify the output was rebuilt).
if [ "$status" -eq 0 ] && [ -f "$OUT" ] && [ "$(stat -c %Y "$OUT")" -ge "$before" ]; then
  size=$(du -h "$OUT" | cut -f1)
  printf '\n%s\n' "${GREEN}BUILD SUCCEEDED${RESET}  →  ${OUT} ${DIM}(${size})${RESET}"
  exit 0
fi

printf '\n'
if [ "$status" -ne 0 ]; then
  die "BUILD FAILED  (Ahk2Exe exit code ${status})"
else
  die "BUILD FAILED  (no fresh ${OUT} was produced)"
fi
