#!/bin/sh
# thermo-use installer: puts the `thermo` CLI (and its `thermo-use` alias) on PATH.
#   curl -fsSL https://raw.githubusercontent.com/leeguooooo/thermo-use/main/install.sh | sh
#
# The CLI ships inside Thermo.app (Contents/Helpers/thermo), signed and notarized, and updates
# with the app (Sparkle). If Thermo.app is missing, this downloads the DMG from
# app.leeguoo.com/thermo, checks its Developer ID team, copies the app to /Applications (or
# ~/Applications) and links the CLI into ~/.local/bin. No account, no token.
set -eu

TEAM="6ZPXG4KVVS"
DMG_URL="${THERMO_DMG_URL:-https://app.leeguoo.com/thermo/download}"
BIN_DIR="${THERMO_USE_INSTALL_DIR:-$HOME/.local/bin}"

[ "$(uname -s)" = Darwin ] || { echo "thermo-use needs macOS (it reads the Mac's SMC sensors)" >&2; exit 1; }

find_app() {
  for a in /Applications/Thermo.app "$HOME/Applications/Thermo.app"; do
    [ -x "$a/Contents/Helpers/thermo" ] && { echo "$a"; return 0; }
  done
  return 1
}

team_of() { codesign -dv "$1" 2>&1 | sed -n 's/^TeamIdentifier=//p'; }

app=$(find_app || true)
if [ -z "$app" ]; then
  tmp=$(mktemp -d)
  mnt="$tmp/mnt"
  trap 'hdiutil detach "$mnt" -quiet 2>/dev/null || true; rm -rf "$tmp"' EXIT
  echo "downloading Thermo from $DMG_URL"
  curl -fsSL --retry 2 -o "$tmp/Thermo.dmg" "$DMG_URL"
  mkdir -p "$mnt"
  hdiutil attach "$tmp/Thermo.dmg" -nobrowse -readonly -mountpoint "$mnt" -quiet
  src="$mnt/Thermo.app"
  [ -d "$src" ] || { echo "no Thermo.app in the download" >&2; exit 1; }
  # Fail closed: only the developer's own signed, notarized build is installed.
  codesign --verify --deep --strict "$src" || { echo "Thermo.app signature is not valid" >&2; exit 1; }
  [ "$(team_of "$src")" = "$TEAM" ] || { echo "Thermo.app is not signed by team $TEAM" >&2; exit 1; }
  spctl --assess --type execute "$src" 2>/dev/null || { echo "Gatekeeper rejected Thermo.app" >&2; exit 1; }
  dest=/Applications
  [ -w "$dest" ] || { dest="$HOME/Applications"; mkdir -p "$dest"; }
  ditto "$src" "$dest/Thermo.app"
  app="$dest/Thermo.app"
  echo "installed: $app"
fi

cli="$app/Contents/Helpers/thermo"
mkdir -p "$BIN_DIR"
ln -sf "$cli" "$BIN_DIR/thermo"
ln -sf "$cli" "$BIN_DIR/thermo-use"
echo "linked: $BIN_DIR/thermo and $BIN_DIR/thermo-use -> $cli"
"$BIN_DIR/thermo" --version

case ":$PATH:" in *":$BIN_DIR:"*) ;; *) echo "note: add $BIN_DIR to PATH" ;; esac
# `thermo pulse` arrived after 1.1.1; older apps update themselves (Thermo → Settings → Check for Updates).
"$BIN_DIR/thermo" pulse --json >/dev/null 2>&1 || echo "note: this Thermo has no \`thermo pulse\` yet; it arrives with the next update"
echo "fan control needs Thermo's helper: open Thermo once and allow it under System Settings → Login Items"
