#!/usr/bin/env bash
#
# XMapTools – macOS bootstrap script
# Usage examples:
#   curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --install AppleSilicon
#   curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --update Rosetta
#   curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --info
# ----------------------------------------------------------------------------

set -euo pipefail

# ---- Configuration ---------------------------------------------------------
DATEUPDATED="02.10.2025"
VERSIONS=("Intel" "Rosetta" "AppleSilicon")

INSTALL_URLS=(
    "https://xmaptools.ch/releases/XMapToolsInstaller_macOS_Intel.zip"
    "https://xmaptools.ch/releases/XMapToolsInstaller_macOS_Rosetta.zip"
    "https://xmaptools.ch/releases/XMapToolsInstaller_macOS_AppleSilicon.zip"
)

UPDATE_URLS=(
    "https://xmaptools.ch/releases/XMapTools_macOS_Intel.zip"
    "https://xmaptools.ch/releases/XMapTools_macOS_Rosetta.zip"
    "https://xmaptools.ch/releases/XMapTools_macOS_AppleSilicon.zip"
)

TMP_DIR="/tmp/xmaptools_task"
INSTALL_DIR="/Applications/XMapTools"
UPDATE_TARGET_DIR="$INSTALL_DIR/application"
MCR_DIR="/Applications/MATLAB/MATLAB_Runtime"
# ----------------------------------------------------------------------------

# ---- Helper functions ------------------------------------------------------

print_info() {
    echo ""
    echo "     -----------------------------------------------------------------"
    echo "     | XMapTools macOS bootstrap script for installation and updates |"
    echo "     |          https://xmaptools.ch - P. Lanari, 2025-2026          |"
    echo "     |                   last update: $DATEUPDATED                     |"
    echo "     -----------------------------------------------------------------"
    echo ""
    echo "> Sources of available versions:"
    for i in "${!VERSIONS[@]}"; do
        echo "Target: ${VERSIONS[$i]}"
        echo "  Installer: ${INSTALL_URLS[$i]}"
        echo "  Updater:   ${UPDATE_URLS[$i]}"
        echo ""
    done

    echo "> Detected MATLAB Runtime installations:"
    if [ -d "$MCR_DIR" ]; then
        found=0
        for dir in "$MCR_DIR"/*; do
            [ -d "$dir" ] || continue
            base=$(basename "$dir")
            case "$base" in
                v99)
                    echo "  - v99  (R2020b, Intel)"
                    found=1
                    ;;
                v912)
                    echo "  - v912 (R2022a, Rosetta)"
                    found=1
                    ;;
                R2025a)
                    echo "  - R2025a (Apple Silicon native)"
                    found=1
                    ;;
                *)
                    echo "  - $base (Unknown / unsupported version)"
                    found=1
                    ;;
            esac
        done
        if [ $found -eq 0 ]; then
            echo "  ❌ No supported MATLAB Runtime version found."
        fi
    else
        echo "  ❌ No MATLAB Runtime directory found at $MCR_DIR"
    fi
    echo ""
    echo "> Usage:"
    echo " curl -fsSL https://xmaptools.ch/install.sh | bash -s -- arguments"
    echo ""
    echo "  Arguments:"
    echo "    --install [Intel|Rosetta|AppleSilicon]   Install via graphical installer"
    echo "    --update  [Intel|Rosetta|AppleSilicon]   Update only the app bundle"
    echo "    --info                                   Show versions & installed MCR"
    echo ""
    echo "> Note:"
    echo "   - If no architecture is specified, the script will try to detect it"
    echo "     automatically (Apple Silicon preferred if available)."
    echo "   - The script may ask for your password to perform installation tasks."
    echo "   - If you receive a message saying that the MCR version is invalid after "
    echo "     updating, please re-install XMapTools using the --install option."
    echo ""
    exit 0
}

check_mcr() {
    echo "> Checking for MATLAB Runtime..."
    if [ -d "$MCR_DIR" ]; then
        echo "    - MATLAB Runtime found"
    else
        echo "    - MATLAB Runtime NOT found!"
        echo "      Please install XMapTools using the installation script:"
        echo "        curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --install"
    fi
    echo ""
}

detect_arch_index() {
    local arch
    arch=$(uname -m)
    if [[ "$arch" == "arm64" ]]; then
        echo 2   # Apple Silicon
    elif [[ "$arch" == "x86_64" ]]; then
        echo 0   # Intel
    else
        echo 1   # fallback Rosetta
    fi
}

resolve_index() {
    local choice="${1:-auto}"
    case "$choice" in
        Intel) echo 0 ;;
        Rosetta) echo 1 ;;
        AppleSilicon) echo 2 ;;
        auto) detect_arch_index ;;
        *)
            echo "❌ Unknown version: $choice"
            echo "Valid options: Intel | Rosetta | AppleSilicon"
            exit 1
            ;;
    esac
}

# ---- Main logic ------------------------------------------------------------
MODE="${1:-}"

case "$MODE" in
    --info)
        print_info
        ;;

    --install)
        ARCH="${2:-auto}"
        IDX=$(resolve_index "$ARCH")
        ZIP_URL="${INSTALL_URLS[$IDX]}"
        ZIP_PATH="$TMP_DIR/XMapToolsInstaller.zip"
        APP_NAME="XMapToolsInstaller_macOS.app"
        APP_PATH="$TMP_DIR/$APP_NAME"

        clear
        echo "> Preparing temporary workspace ($TMP_DIR)"
        sudo rm -rf "$TMP_DIR"
        sudo mkdir -p "$TMP_DIR"
        echo ""

        echo "> Removing old XMapTools installation (if any)"
        if [ -d "$INSTALL_DIR" ]; then
            sudo rm -rf "$INSTALL_DIR"
            echo "    - Removed previous version"
        else
            echo "    - No previous version found"
        fi
        echo ""

        echo "> Downloading XMapTools installer:"
        echo "  $ZIP_URL"
        sudo curl -L "$ZIP_URL" -o "$ZIP_PATH"
        echo ""

        echo "> Unzipping installer"
        sudo unzip -q "$ZIP_PATH" -d "$TMP_DIR"
        echo ""

        echo "> Clearing Gatekeeper quarantine flag"
        xattr -c "$APP_PATH" || true
        echo ""

        echo "> Launching the graphical installer"
        open "$APP_PATH"
        echo ""

        check_mcr

        echo "✅ The XMapTools installer window is now open."
        exit 0
        ;;

    --update)
        ARCH="${2:-auto}"
        IDX=$(resolve_index "$ARCH")
        ZIP_URL="${UPDATE_URLS[$IDX]}"
        ZIP_PATH="$TMP_DIR/XMapTools.zip"
        APP_NAME="XMapTools.app"
        EXTRACTED_APP_PATH="$TMP_DIR/$APP_NAME"
        TARGET_DIR="$UPDATE_TARGET_DIR"
        TARGET_APP_PATH="$TARGET_DIR/$APP_NAME"

        clear
        echo "> Checking if XMapTools is installed:"
        if [ ! -d "$TARGET_DIR" ]; then
            echo ""
            echo "❌ ERROR: Target directory does not exist: $TARGET_DIR"
            echo "Please install XMapTools first using the installer script:"
            echo "  curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --install"
            exit 1
        fi
        echo "    - Done"
        echo ""

        echo "> Preparing temporary workspace ($TMP_DIR)"
        sudo rm -rf "$TMP_DIR"
        sudo mkdir -p "$TMP_DIR"
        echo ""

        echo "> Downloading latest version of XMapTools:"
        echo "  $ZIP_URL"
        sudo curl -L "$ZIP_URL" -o "$ZIP_PATH"
        echo ""

        echo "> Unzipping archive to $TMP_DIR"
        sudo unzip -q "$ZIP_PATH" -d "$TMP_DIR"

        if [ ! -d "$EXTRACTED_APP_PATH" ]; then
            echo "❌ ERROR: Expected $APP_NAME inside the ZIP archive."
            exit 1
        fi
        echo ""

        echo "> Removing existing XMapTools.app from target location"
        sudo rm -rf "$TARGET_APP_PATH"
        echo ""

        echo "> Installing new version"
        sudo mv "$EXTRACTED_APP_PATH" "$TARGET_DIR"
        echo ""

        echo "> Clearing Gatekeeper quarantine flag"
        sudo xattr -c "$TARGET_APP_PATH" || true
        echo ""

        echo "> Giving write permissions to the app bundle for user configuration files"
        sudo chmod 666 "$TARGET_APP_PATH/Contents/Resources/XMapTools_mcr/XMapTools/config_xmaptools.mat"
        echo ""

        check_mcr

        echo "✅ XMapTools has been updated successfully!"
        exit 0
        ;;

    *)
        print_info
        ;;
esac