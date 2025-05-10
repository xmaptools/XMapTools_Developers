#!/usr/bin/env bash
#
# XMapTools – macOS Apple-silicon bootstrap installer
# Usage: curl -fsSL https://xmaptools.ch/install.sh | bash
# ----------------------------------------------------------------------------

set -euo pipefail

# ---- Configuration ---------------------------------------------------------
ZIP_URL="https://xmaptools.ch/releases/XMapToolsInstaller_macOS.zip"

TMP_DIR="/tmp/xmaptools_installer"
ZIP_PATH="$TMP_DIR/XMapToolsInstaller.zip"
APP_NAME="XMapToolsInstaller_macOS.app"
APP_PATH="$TMP_DIR/$APP_NAME"
# ----------------------------------------------------------------------------

echo "🔧 Preparing temporary workspace…"
if [ -d "$TMP_DIR" ]; then
    echo "🧹 Removing leftovers from a previous attempt…"
    rm -rf "$TMP_DIR"
fi
mkdir -p "$TMP_DIR"

echo "🗑️  Removing old XMapTools installation (if any)…"
if [ -d "/Applications/XMapTools" ]; then
    sudo rm -rf "/Applications/XMapTools"
    echo "✅ Removed previous version from /Applications/XMapTools"
else
    echo "ℹ️  No previous version found in /Applications/XMapTools"
fi

echo "📥 Downloading XMapTools installer…"
curl -L "$ZIP_URL" -o "$ZIP_PATH"

echo "📦 Unzipping installer…"
unzip -q "$ZIP_PATH" -d "$TMP_DIR"

echo "🔓 Clearing Gatekeeper quarantine flag…"
xattr -c "$APP_PATH" || true   # ignore if already clean

echo "🚀 Launching the graphical installer…"
open "$APP_PATH"

echo ""
echo "⏳ The XMapTools installer window is now open."
echo "➡️  Please follow the on-screen instructions to finish installation."
echo "✅ When you're done, you can close this Terminal window."
echo ""
exit 0