#!/usr/bin/env bash
#
# XMapTools – macOS bootstrap script
# Usage examples:
#   curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --install
#   curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --update
#   curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --install-dev
#   curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --update-dev
#   curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --info
# ----------------------------------------------------------------------------

set -euo pipefail

# ---- Configuration ---------------------------------------------------------
DATEUPDATED="13.02.2026"
VERSIONS=("Intel" "AppleSilicon")

INSTALL_URLS=(
    "https://xmaptools.ch/releases/XMapToolsInstaller_macOS_Intel.zip"
    "https://xmaptools.ch/releases/XMapToolsInstaller_macOS_AppleSilicon.zip"
)

UPDATE_URLS=(
    "https://xmaptools.ch/releases/XMapTools_macOS_Intel.zip"
    "https://xmaptools.ch/releases/XMapTools_macOS_AppleSilicon.zip"
)

DEV_INSTALL_URLS=(
    "https://xmaptools.ch/dev-releases/XMapToolsInstaller_macOS_Intel.zip"
    "https://xmaptools.ch/dev-releases/XMapToolsInstaller_macOS_AppleSilicon.zip"
)

DEV_UPDATE_URLS=(
    "https://xmaptools.ch/dev-releases/XMapTools_macOS_Intel.zip"
    "https://xmaptools.ch/dev-releases/XMapTools_macOS_AppleSilicon.zip"
)

ANALYTICS_URL="https://xmaptools.ch/api/count.php"
TMP_DIR="/tmp/xmaptools_task"
INSTALL_DIR="/Applications/XMapTools"
UPDATE_TARGET_DIR="$INSTALL_DIR/application"
MCR_DIR="/Applications/MATLAB/MATLAB_Runtime"
# ----------------------------------------------------------------------------

# ---- Helper functions ------------------------------------------------------

track_event() {
    local action="$1" arch="$2"
    curl -fsSL -o /dev/null -m 5 \
        "${ANALYTICS_URL}?action=${action}&arch=${arch}&os=macOS&v=${DATEUPDATED}" \
        2>/dev/null || true
}

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
        echo "      Stable installer: ${INSTALL_URLS[$i]}"
        print_remote_timestamp "${INSTALL_URLS[$i]}"
        echo "      Stable update:    ${UPDATE_URLS[$i]}"
        print_remote_timestamp "${UPDATE_URLS[$i]}"
        echo "      Dev installer:    ${DEV_INSTALL_URLS[$i]}"
        print_remote_timestamp "${DEV_INSTALL_URLS[$i]}"
        echo "      Dev update:       ${DEV_UPDATE_URLS[$i]}"
        print_remote_timestamp "${DEV_UPDATE_URLS[$i]}"
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
    echo "      --install     [Intel|AppleSilicon]   Full installation (stable)"
    echo "      --update      [Intel|AppleSilicon]   Update the app bundle only (stable)"
    echo "      --install-dev [Intel|AppleSilicon]   Full installation (developer)"
    echo "      --update-dev  [Intel|AppleSilicon]   Update the app bundle only (developer)"
    echo "      --info                               Show this information"
    echo ""
    echo "  Notes:"
    echo ""
    echo "    - If no architecture is specified, the script will attempt to detect"
    echo "      it automatically (Apple Silicon is preferred when available)."
    echo "    - The script may prompt for your password to perform privileged tasks."
    echo "    - If XMapTools reports an invalid MCR version after updating, please"
    echo "      perform a full reinstallation using the --install option."
    echo "    - Developer versions (--install-dev / --update-dev) are for testing"
    echo "      purposes and may be unstable."
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

# ---- Install function ------------------------------------------------------
do_install() {
    local idx="$1"
    local zip_url="${2:-${INSTALL_URLS[$idx]}}"
    local action="${3:-install}"
    local zip_path="$TMP_DIR/XMapToolsInstaller.zip"
    local app_name="XMapToolsInstaller_macOS.app"
    local app_path="$TMP_DIR/$app_name"

    clear
    print_banner
    echo "  Installing XMapTools (${VERSIONS[$idx]}) ..."
    track_event "$action" "${VERSIONS[$idx]}"
    print_remote_timestamp "$zip_url"
    echo ""

    echo "  Preparing temporary workspace (you might have to type your password)..."
    sudo rm -rf "$TMP_DIR"
    sudo mkdir -p "$TMP_DIR"

    if [ -d "$INSTALL_DIR" ]; then
        echo "  Removing previous installation ..."
        sudo rm -rf "$INSTALL_DIR"
    fi

    print_remote_timestamp "$zip_url"
    echo ""
    echo "  Downloading installer ..."
    echo "    $zip_url"
    sudo curl -fSL "$zip_url" -o "$zip_path"
    echo ""

    echo "  Extracting installer ..."
    sudo unzip -q "$zip_path" -d "$TMP_DIR"

    echo "  Setting execute permissions on installer binary ..."
    sudo chmod +x "$app_path/Contents/MacOS/"* || true
    sudo find "$app_path" -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

    echo "  Clearing Gatekeeper quarantine flags ..."
    sudo xattr -cr "$app_path" || true

    echo "  Re-signing installer bundle (ad-hoc) ..."
    sudo codesign --force --deep --sign - "$app_path" 2>/dev/null || true

    echo "  Launching graphical installer ..."
    open "$app_path"
    echo ""

    setup_terminal_command

    check_mcr

    echo "  [OK] The XMapTools installer window should now be open."
    echo "  Follow the on-screen instructions to complete the installation."
    echo ""
    echo "  Waiting in background for installation to finish to fix permissions ..."
    wait_and_fix_permissions &
    disown
}

# ---- Update function -------------------------------------------------------
do_update() {
    local idx="$1"
    local zip_url="$2"
    local action="${3:-update}"
    local install_url="${4:-${INSTALL_URLS[$idx]}}"
    local install_action="${5:-install}"
    local zip_path="$TMP_DIR/XMapTools.zip"
    local app_name="XMapTools.app"
    local extracted_app_path="$TMP_DIR/$app_name"
    local target_dir="$UPDATE_TARGET_DIR"
    local target_app_path="$target_dir/$app_name"

    clear
    print_banner
    echo "  Updating XMapTools (${VERSIONS[$idx]}) ..."
    track_event "$action" "${VERSIONS[$idx]}"
    print_remote_timestamp "$zip_url"
    echo ""

    echo "  Verifying existing installation ..."
    if [ ! -d "$target_dir" ]; then
        echo ""
        echo "  [ERROR] Target directory does not exist: $target_dir"
        echo "  XMapTools does not appear to be installed. Please run a full"
        echo "  installation first:"
        echo "    curl -fsSL https://xmaptools.ch/install.sh | bash -s -- --${install_action}"
        exit 1
    fi

    echo "  Checking MATLAB Runtime ..."
    local mcr_expected mcr_label
    if [ "$idx" -eq 0 ]; then
        mcr_expected="$MCR_DIR/v99"
        mcr_label="v99 (R2020b, Intel)"
    else
        mcr_expected="$MCR_DIR/R2025a"
        mcr_label="R2025a (Apple Silicon)"
    fi

    if [ ! -d "$mcr_expected" ]; then
        echo ""
        echo "  [WARNING] MATLAB Runtime $mcr_label is not installed."
        echo "  XMapTools requires this runtime version to run."
        echo ""
        read -rp "  Would you like to run a full installation instead? (y/n) " answer < /dev/tty
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            do_install "$idx" "$install_url" "$install_action"
            exit 0
        else
            echo ""
            echo "  Update cancelled."
            exit 1
        fi
    fi
    echo "    MATLAB Runtime $mcr_label found."
    echo ""

    echo "  Preparing temporary workspace (you might have to type your password) ..."
    sudo rm -rf "$TMP_DIR"
    sudo mkdir -p "$TMP_DIR"

    echo ""
    echo "  Downloading latest version ..."
    echo "    $zip_url"
    print_remote_timestamp "$zip_url"
    sudo curl -fSL "$zip_url" -o "$zip_path"
    echo ""

    echo "  Extracting archive ..."
    sudo unzip -q "$zip_path" -d "$TMP_DIR"

    if [ ! -d "$extracted_app_path" ]; then
        echo "  [ERROR] Expected $app_name inside the archive, but it was not found."
        cleanup
        exit 1
    fi

    echo "  Removing previous app bundle ..."
    sudo rm -rf "$target_app_path"

    echo "  Installing new app bundle ..."
    sudo mv "$extracted_app_path" "$target_dir"

    echo "  Setting execute permissions on app binary ..."
    sudo chmod +x "$target_app_path/Contents/MacOS/"* || true
    sudo find "$target_app_path" -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

    echo "  Clearing Gatekeeper quarantine flags ..."
    sudo xattr -cr "$target_app_path" || true

    echo "  Re-signing app bundle (ad-hoc) ..."
    sudo codesign --force --deep --sign - "$target_app_path" 2>/dev/null || true

    echo "  Setting write permissions on user configuration files ..."
    sudo chown "$(logname)" "$target_app_path/Contents/Resources/XMapTools_mcr/XMapTools/config_xmaptools.mat"
    sudo chmod 644 "$target_app_path/Contents/Resources/XMapTools_mcr/XMapTools/config_xmaptools.mat"
    echo ""

    cleanup

    setup_terminal_command

    check_mcr

    echo "  [OK] XMapTools has been updated successfully."
    echo ""
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
        do_install "$IDX" "${INSTALL_URLS[$IDX]}" "install"
        exit 0
        ;;

    --install-dev)
        ARCH="${2:-auto}"
        IDX=$(resolve_index "$ARCH")
        do_install "$IDX" "${DEV_INSTALL_URLS[$IDX]}" "install-dev"
        exit 0
        ;;

    --update)
        ARCH="${2:-auto}"
        IDX=$(resolve_index "$ARCH")
        do_update "$IDX" "${UPDATE_URLS[$IDX]}" "update" "${INSTALL_URLS[$IDX]}" "install"
        exit 0
        ;;

    --update-dev)
        ARCH="${2:-auto}"
        IDX=$(resolve_index "$ARCH")
        do_update "$IDX" "${DEV_UPDATE_URLS[$IDX]}" "update-dev" "${DEV_INSTALL_URLS[$IDX]}" "install-dev"
        exit 0
        ;;

    *)
        print_info
        ;;
esac
