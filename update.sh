#!/usr/bin/env bash
#
# XMapTools – Updater for macOS
# Replaces the existing XMapTools.app inside the application folder
# ----------------------------------------------------------------------------

# Avoid treating unset variables as errors
set +u  # Disable "unbound variable" error temporarily
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

# ---- Configuration Debugging ------------------------------------------------
echo "DEBUG: TARGET_DIR = '${TARGET_DIR}'"
echo "DEBUG: TARGET_APP_PATH = '${TARGET_APP_PATH}'"

# ---- Prepare temporary workspace -----------------------------------------
echo "🔧 Preparing temporary workspace…"
if [ -d "$TMP_DIR" ]; then
    echo "🧹 Removing leftovers from a previous update…"
    sudo rm -rf "$TMP_DIR"
fi
sudo mkdir -p "$TMP_DIR"

# ---- Download and Unzip ----------------------------------------------------
echo "📥 Downloading latest version of XMapTools…"
# Download the zip file with `sudo curl`
sudo curl -L "$ZIP_URL" -o "$ZIP_PATH"

echo "📦 Unzipping app…"
sudo unzip -q "$ZIP_PATH" -d "$TMP_DIR"

if [ ! -d "$EXTRACTED_APP_PATH" ]; then
    echo "❌ ERROR: Expected $APP_NAME inside the ZIP archive."
    exit 1
fi

# ---- Check TARGET_DIR exists before proceeding ---------------------------
echo "🔧 Checking permissions on $TARGET_DIR"
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ ERROR: Target directory does not exist: $TARGET_DIR"
    exit 1
fi

# Ensure we can write to the target directory
if [ ! -w "$TARGET_DIR" ]; then
    echo "❌ ERROR: No write permission to $TARGET_DIR. You may need elevated permissions."
    exit 1
fi

# ---- Remove existing version if present ---------------------------------
echo "🗑️  Removing existing XMapTools.app from target location…"
if [ -d "$TARGET_APP_PATH" ]; then
    echo "✅ Existing app found, removing…"
    sudo rm -rf "$TARGET_APP_PATH"
else
    echo "ℹ️  No previous version found — installing fresh."
fi

# ---- Install new version --------------------------------------------------
echo "📁 Moving new version to $TARGET_DIR…"
if [ -d "$EXTRACTED_APP_PATH" ]; then
    sudo mv "$EXTRACTED_APP_PATH" "$TARGET_DIR"
    echo "✅ XMapTools.app moved."
else
    echo "❌ ERROR: Extracted application not found!"
    exit 1
fi

# ---- Clear Gatekeeper quarantine flag -----------------------------------
echo "🔓 Clearing Gatekeeper quarantine flag…"
sudo xattr -c "$TARGET_APP_PATH" || true

echo ""
echo "✅ XMapTools has been updated successfully!"
exit 0