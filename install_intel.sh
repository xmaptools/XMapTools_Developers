#!/usr/bin/env bash
#
# XMapTools – macOS Apple-silicon bootstrap installer
# Usage: curl -fsSL https://xmaptools.ch/install_intel.sh | bash
# ----------------------------------------------------------------------------

set -euo pipefail

# ---- Configuration ---------------------------------------------------------
ZIP_URL="https://xmaptools.ch/releases/XMapToolsInstaller_macOS_Intel.zip"

TMP_DIR="/tmp/xmaptools_installer"
ZIP_PATH="$TMP_DIR/XMapToolsInstaller.zip"
APP_NAME="XMapToolsInstaller_macOS_Intel.app"
APP_PATH="$TMP_DIR/$APP_NAME"
# ----------------------------------------------------------------------------

# ---- Clear the terminal screen before starting ----------------------------
clear

echo "> Preparing temporary workspace (/tmp/xmaptools_installer):"
if [ -d "$TMP_DIR" ]; then
    echo "    - Removing remnants of a previous installation"
    echo "      (this may require your admin password)"
    rm -rf "$TMP_DIR"
fi
echo "    - Creating temporary workspace"
mkdir -p "$TMP_DIR"
echo ""

echo ">  Removing old XMapTools installation (if any)"
if [ -d "/Applications/XMapTools" ]; then
    sudo rm -rf "/Applications/XMapTools"
    echo "    - Removed previous version from /Applications/XMapTools"
else
    echo "    - No previous version found in /Applications/XMapTools"
fi
echo ""

echo "> Downloading XMapTools installer:"
echo ""
curl -L "$ZIP_URL" -o "$ZIP_PATH"
echo ""

echo "> Unzipping installer"
unzip -q "$ZIP_PATH" -d "$TMP_DIR"
echo ""

echo "> Clearing Gatekeeper quarantine flag"
xattr -c "$APP_PATH" || true   # ignore if already clean
echo ""

echo "> Launching the graphical installer"
open "$APP_PATH"

echo ""
echo "✅ The XMapTools installer window is now open."
echo "   Please follow the on-screen instructions to finish installation."
echo "   When you're done, you can close this Terminal window."
echo ""
exit 0