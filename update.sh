#!/usr/bin/env bash
#
# XMapTools – Updater for macOS
# Replaces the existing XMapTools.app inside the application folder
# ----------------------------------------------------------------------------

# ---- Configuration ---------------------------------------------------------
ZIP_URL="${ZIP_URL:-https://xmaptools.ch/releases/XMapTools_macOS.zip}"  # Default value if ZIP_URL is not set
TMP_DIR="${TMP_DIR:-/tmp/xmaptools_update}"
ZIP_PATH="${ZIP_PATH:-$TMP_DIR/XMapTools_macOS.zip}"
APP_NAME="${APP_NAME:-XMapTools.app}"
EXTRACTED_APP_PATH="${EXTRACTED_APP_PATH:-$TMP_DIR/$APP_NAME}"
TARGET_DIR="${TARGET_DIR:-/Applications/XMapTools/application}"
TARGET_APP_PATH="${TARGET_APP_PATH:-$TARGET_DIR/$APP_NAME}"
# ----------------------------------------------------------------------------

# ---- Clear the terminal screen before starting ----------------------------
clear

echo "> Checking if XMapTools is installed:"

if [ ! -d "$TARGET_DIR" ]; then
    echo ""
    echo "❌ ERROR: Target directory does not exist: $TARGET_DIR"
    echo ""
    echo "Please install XMapTools first using the installer script."
    echo "You can do this by running the following command:"
    echo "curl -fsSL https://xmaptools.ch/install.sh | bash"
    echo ""
    exit 1
fi
echo "    - Done"
echo ""

# ---- Prepare temporary workspace -----------------------------------------
echo "> Preparing temporary workspace (/tmp/xmaptools_update):"
if [ -d "$TMP_DIR" ]; then
    echo "    - Removing remnants of a previous update"
    echo "      (this may require your admin password)"
    sudo rm -rf "$TMP_DIR"
fi
echo "    - Creating temporary workspace"
echo "      (this may require your admin password)"
sudo mkdir -p "$TMP_DIR"
echo ""

# ---- Download and Unzip ----------------------------------------------------
echo "> Downloading latest version of XMapTools:"
echo "    - Downloading ZIP archive from $ZIP_URL"
echo ""
sudo curl -L "$ZIP_URL" -o "$ZIP_PATH"
echo ""

echo "   - Unzipping archive to $TMP_DIR"
sudo unzip -q "$ZIP_PATH" -d "$TMP_DIR"

if [ ! -d "$EXTRACTED_APP_PATH" ]; then
    echo "❌ ERROR: Expected $APP_NAME inside the ZIP archive."
    exit 1
fi
echo ""

# ---- Check TARGET_DIR exists before proceeding ---------------------------
echo "> Checking permissions on $TARGET_DIR"
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ ERROR: Target directory does not exist: $TARGET_DIR"
    exit 1
fi

if [ ! -w "$TARGET_DIR" ]; then
    echo "❌ ERROR: No write permission to $TARGET_DIR. You may need elevated permissions."
    exit 1
fi
echo ""

# ---- Remove existing version if present ---------------------------------
echo "> Removing existing XMapTools.app from target location"
echo "  (this may require your admin password)"
if [ -d "$TARGET_APP_PATH" ]; then
    sudo rm -rf "$TARGET_APP_PATH"
fi
echo ""

# ---- Install new version --------------------------------------------------
echo "> Moving new version to $TARGET_DIR"
if [ -d "$EXTRACTED_APP_PATH" ]; then
    sudo mv "$EXTRACTED_APP_PATH" "$TARGET_DIR"
else
    echo "❌ ERROR: Extracted application not found!"
    exit 1
fi
echo ""

# ---- Clear Gatekeeper quarantine flag -----------------------------------
echo "> Clearing Gatekeeper quarantine flag"
sudo xattr -c "$TARGET_APP_PATH" || true
echo ""

# ---- Give write permissions to the app bundle ----------------------------
echo "> Giving write permissions to the app bundle for user configuration files"
sudo chmod 666 /Applications/XMapTools/application/XMapTools.app/Contents/Resources/XMapTools_mcr/XMapTools/config_xmaptools.mat
echo ""

echo "✅ XMapTools has been updated successfully!"
echo ""

exit 0