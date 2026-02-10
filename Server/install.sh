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
DATEUPDATED="08.02.2026"
VERSIONS=("Intel" "AppleSilicon")

INSTALL_URLS=(
    "https://xmaptools.ch/releases/XMapToolsInstaller_macOS_Intel.zip"
    "https://xmaptools.ch/releases/XMapToolsInstaller_macOS_AppleSilicon.zip"
)

UPDATE_URLS=(
    "https://xmaptools.ch/releases/XMapTools_macOS_Intel.zip"
    "https://xmaptools.ch/releases/XMapTools_macOS_AppleSilicon.zip"
)

TMP_DIR="/tmp/xmaptools_task"
INSTALL_DIR="/Applications/XMapTools"
UPDATE_TARGET_DIR="$INSTALL_DIR/application"
MCR_DIR="/Applications/MATLAB/MATLAB_Runtime"
# ----------------------------------------------------------------------------

# ---- Helper functions ------------------------------------------------------

cleanup() {
    if [ -d "$TMP_DIR" ]; then
        sudo rm -rf "$TMP_DIR"
    fi
}

print_banner() {
    echo ""
    echo "  -------------------------------------------------------------------"
    echo "  | XMapTools macOS bootstrap script for installation and updates   |"
    echo "  |            https://xmaptools.ch - P. Lanari, 2025-2026          |"
    echo "  |                Shell script version: $DATEUPDATED                 |"
    echo "  -------------------------------------------------------------------"
    echo ""
}

print_info() {
    print_banner

    echo "  Available versions:"
    echo ""
    for i in "${!VERSIONS[@]}"; do
        echo "    ${VERSIONS[$i]}"
        echo "      Installer: ${INSTALL_URLS[$i]}"
        print_remote_timestamp "${INSTALL_URLS[$i]}"
        echo "      Update:    ${UPDATE_URLS[$i]}"
        print_remote_timestamp "${UPDATE_URLS[$i]}"
        echo ""
    done

    echo "  Detected MATLAB Runtime installations:"
    echo ""
    if [ -d "$MCR_DIR" ]; then
        found=0
        for dir in "$MCR_DIR"/*; do
            [ -d "$dir" ] || continue
            base=$(basename "$dir")
            case "$base" in
                v99)
                    echo "    v99  (R2020b, Intel)"
                    found=1
                    ;;

                R2025a)
                    echo "    R2025a (Apple Silicon native)"
                    found=1
                    ;;
                *)
                    echo "    $base (unknown/unsupported version)"
                    found=1
                    ;;
            esac
        done
        if [ $found -eq 0 ]; then
            echo "    [WARNING] No supported MATLAB Runtime version found."
        fi
    else
        echo "    [WARNING] No MATLAB Runtime directory found at $MCR_DIR"
    fi
    echo ""

    echo "  Usage:"
    echo ""
    echo "    curl -fsSL https://xmaptools.ch/install.sh | bash -s -- <arguments>"
    echo ""
    echo "    Arguments:"
    echo "      --install [Intel|AppleSilicon]   Full installation"
    echo "      --update  [Intel|AppleSilicon]   Update the app bundle only"
    echo "      --info                           Show this information"
    echo ""
    echo "  Notes:"
    echo ""
    echo "    - If no architecture is specified, the script will attempt to detect"
    echo "      it automatically (Apple Silicon is preferred when available)."
    echo "    - The script may prompt for your password to perform privileged tasks."
    echo "    - If XMapTools reports an invalid MCR version after updating, please"
    echo "      perform a full reinstallation using the --install option."
    echo ""
    exit 0
}

check_mcr() {
    echo "  Checking MATLAB Runtime ..."
    if [ -d "$MCR_DIR" ]; then
        echo "    MATLAB Runtime found."
    else
        echo "    [WARNING] MATLAB Runtime not found."
        echo "    A full installation is required to set up the runtime:"
        echo "      curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --install"
    fi
    echo ""
}

print_remote_timestamp() {
    local url="$1"
    local ts
    ts=$(curl -sI "$url" | grep -i '^Last-Modified:' | sed 's/^[Ll]ast-[Mm]odified: *//')
    if [ -n "$ts" ]; then
        echo "    ** XMapTools version: $ts"
    else
        echo "  [WARNING] Could not retrieve remote file timestamp."
    fi
}

setup_terminal_command() {
    local wrapper="/usr/local/bin/xmaptools"
    local app_path="$UPDATE_TARGET_DIR/XMapTools.app"

    echo "  Setting up terminal command ..."

    sudo mkdir -p /usr/local/bin

    sudo tee "$wrapper" > /dev/null <<EOF
#!/usr/bin/env bash
# Launch XMapTools from the terminal
open "$app_path" "\$@"
EOF

    sudo chmod +x "$wrapper"
    echo "    Terminal command installed: $wrapper"
    echo "    You can now launch XMapTools by typing 'XMapTools' or 'xmaptools' in your terminal."

    # Ensure /usr/local/bin is on the PATH for the current user's shell
    local shell_rc=""
    case "$(basename "$SHELL")" in
        zsh)  shell_rc="$HOME/.zshrc" ;;
        bash) shell_rc="$HOME/.bash_profile" ;;
        *)    shell_rc="$HOME/.profile" ;;
    esac

    if [ -n "$shell_rc" ]; then
        if ! grep -qF '/usr/local/bin' "$shell_rc" 2>/dev/null; then
            echo '' >> "$shell_rc"
            echo '# Added by XMapTools installer' >> "$shell_rc"
            echo 'export PATH="/usr/local/bin:$PATH"' >> "$shell_rc"
            echo "    Updated $shell_rc to include /usr/local/bin in PATH."
        fi
    fi
    echo ""
}

wait_and_fix_permissions() {
    local config_file="$UPDATE_TARGET_DIR/XMapTools.app/Contents/Resources/XMapTools_mcr/XMapTools/config_xmaptools.mat"
    local timeout=600   # wait up to 10 minutes for the installer to finish
    local elapsed=0
    local interval=5

    while [ $elapsed -lt $timeout ]; do
        if [ -f "$config_file" ]; then
            sudo chown "$(logname)" "$config_file" 2>/dev/null || true
            sudo chmod 644 "$config_file" 2>/dev/null || true
            echo "  [OK] Write permissions set on config_xmaptools.mat"
            return 0
        fi
        sleep $interval
        elapsed=$((elapsed + interval))
    done

    echo "  [WARNING] Timed out waiting for config_xmaptools.mat to appear."
    echo "  You may need to fix permissions manually after installation:"
    echo "    sudo chmod 644 \"$config_file\""
    return 1
}

detect_arch_index() {
    local arch
    arch=$(uname -m)
    if [[ "$arch" == "arm64" ]]; then
        echo 1   # Apple Silicon
    else
        echo 0   # Intel
    fi
}

resolve_index() {
    local choice="${1:-auto}"
    case "$choice" in
        Intel) echo 0 ;;
        AppleSilicon) echo 1 ;;
        auto) detect_arch_index ;;
        *)
            echo "[ERROR] Unknown version: $choice" >&2
            echo "Valid options: Intel | AppleSilicon" >&2
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
        print_banner
        echo "  Installing XMapTools (${VERSIONS[$IDX]}) ..."
        print_remote_timestamp "$ZIP_URL"
        echo ""

        echo "  Preparing temporary workspace ..."
        sudo rm -rf "$TMP_DIR"
        sudo mkdir -p "$TMP_DIR"

        if [ -d "$INSTALL_DIR" ]; then
            echo "  Removing previous installation ..."
            sudo rm -rf "$INSTALL_DIR"
        fi

        print_remote_timestamp "$ZIP_URL"
        echo ""
        echo "  Downloading installer ..."
        echo "    $ZIP_URL"
        sudo curl -fSL "$ZIP_URL" -o "$ZIP_PATH"
        echo ""

        echo "  Extracting installer ..."
        sudo unzip -q "$ZIP_PATH" -d "$TMP_DIR"

        echo "  Setting execute permissions on installer binary ..."
        sudo chmod +x "$APP_PATH/Contents/MacOS/"* || true
        sudo find "$APP_PATH" -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

        echo "  Clearing Gatekeeper quarantine flags ..."
        sudo xattr -cr "$APP_PATH" || true

        echo "  Re-signing installer bundle (ad-hoc) ..."
        sudo codesign --force --deep --sign - "$APP_PATH" 2>/dev/null || true

        echo "  Launching graphical installer ..."
        open "$APP_PATH"
        echo ""

        setup_terminal_command

        check_mcr

        echo "  [OK] The XMapTools installer window should now be open."
        echo "  Follow the on-screen instructions to complete the installation."
        echo ""
        echo "  Waiting in background for installation to finish to fix permissions ..."
        wait_and_fix_permissions &
        disown
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
        print_banner
        echo "  Updating XMapTools (${VERSIONS[$IDX]}) ..."
        print_remote_timestamp "$ZIP_URL"
        echo ""

        echo "  Verifying existing installation ..."
        if [ ! -d "$TARGET_DIR" ]; then
            echo ""
            echo "  [ERROR] Target directory does not exist: $TARGET_DIR"
            echo "  XMapTools does not appear to be installed. Please run a full"
            echo "  installation first:"
            echo "    curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --install"
            exit 1
        fi

        echo "  Preparing temporary workspace ..."
        sudo rm -rf "$TMP_DIR"
        sudo mkdir -p "$TMP_DIR"

        echo ""
        echo "  Downloading latest version ..."
        echo "    $ZIP_URL"
        print_remote_timestamp "$ZIP_URL"
        sudo curl -fSL "$ZIP_URL" -o "$ZIP_PATH"
        echo ""

        echo "  Extracting archive ..."
        sudo unzip -q "$ZIP_PATH" -d "$TMP_DIR"

        if [ ! -d "$EXTRACTED_APP_PATH" ]; then
            echo "  [ERROR] Expected $APP_NAME inside the archive, but it was not found."
            cleanup
            exit 1
        fi

        echo "  Removing previous app bundle ..."
        sudo rm -rf "$TARGET_APP_PATH"

        echo "  Installing new app bundle ..."
        sudo mv "$EXTRACTED_APP_PATH" "$TARGET_DIR"

        echo "  Setting execute permissions on app binary ..."
        sudo chmod +x "$TARGET_APP_PATH/Contents/MacOS/"* || true
        sudo find "$TARGET_APP_PATH" -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

        echo "  Clearing Gatekeeper quarantine flags ..."
        sudo xattr -cr "$TARGET_APP_PATH" || true

        echo "  Re-signing app bundle (ad-hoc) ..."
        sudo codesign --force --deep --sign - "$TARGET_APP_PATH" 2>/dev/null || true

        echo "  Setting write permissions on user configuration files ..."
        sudo chown "$(logname)" "$TARGET_APP_PATH/Contents/Resources/XMapTools_mcr/XMapTools/config_xmaptools.mat"
        sudo chmod 644 "$TARGET_APP_PATH/Contents/Resources/XMapTools_mcr/XMapTools/config_xmaptools.mat"
        echo ""

        cleanup

        setup_terminal_command

        check_mcr

        echo "  [OK] XMapTools has been updated successfully."
        echo ""
        exit 0
        ;;

    *)
        print_info
        ;;
esac