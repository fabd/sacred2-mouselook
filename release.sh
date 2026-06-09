#!/usr/bin/env bash
# =========================================================
# Release Script
#
#   Usage:
#     ./release.sh
#
#   Creates the git tag, pushes it, and publishes a GitHub
#   release with the built exe attached.
#
#   Bump VERSION below before each release (match the
#   ;@Ahk2Exe-SetVersion directive in main.ahk).
# =========================================================
set -euo pipefail
cd "$(dirname "$0")"

# ----- edit this for each release -----
VERSION="2.1.0"

# ----- derived/config -----
TAG="v${VERSION}"
EXE="dist/Better-Mouse-Controls.exe"
REPO="fabd/sacred2-mouselook"

[ -f "$EXE" ] || { echo "✖ $EXE not found — run ./build.sh first." >&2; exit 1; }

gh release create "$TAG" \
  "${EXE}#Better-Mouselook-Controls-v2-1.exe" \
  --repo "$REPO" \
  --title "Better Mouselook Controls for Sacred 2 Remaster ${TAG}" \
  --notes "(edit draft on the website)" \
  --latest \
  --verify-tag=false \
  --draft

