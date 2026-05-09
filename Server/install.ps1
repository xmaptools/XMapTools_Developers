 #
# XMapTools – Windows bootstrap script (PowerShell)
# Usage examples:
#   iex "& { $(irm https://xmaptools.ch/install.ps1) } --install"
#   iex "& { $(irm https://xmaptools.ch/install.ps1) } --update"
#   iex "& { $(irm https://xmaptools.ch/install.ps1) } --install-dev"
#   iex "& { $(irm https://xmaptools.ch/install.ps1) } --update-dev"
#   iex "& { $(irm https://xmaptools.ch/install.ps1) } --info"
# ----------------------------------------------------------------------------

$ErrorActionPreference = "Stop"

# ---- Configuration ---------------------------------------------------------
$DateUpdated   = "11.02.2026"

$InstallUrl    = "https://xmaptools.ch/releases/XMapToolsInstaller_Windows.zip"
$UpdateUrl     = "https://xmaptools.ch/releases/XMapTools_Windows.zip"

$DevInstallUrl = "https://xmaptools.ch/dev-releases/XMapToolsInstaller_Windows.zip"
$DevUpdateUrl  = "https://xmaptools.ch/dev-releases/XMapTools_Windows.zip"

$TmpDir        = "$env:TEMP\xmaptools_task"
$InstallDir    = "C:\Program Files\XMapTools"
$TargetDir     = "$InstallDir\application"
$MCRDir        = "C:\Program Files\MATLAB\MATLAB Runtime"
$AnalyticsUrl  = "https://xmaptools.ch/api/count.php"
# ----------------------------------------------------------------------------

# ---- Helper functions ------------------------------------------------------

function Send-TrackEvent {
    param(
        [string]$Action,
        [string]$Arch = "Windows"
    )
    try {
        $uri = "${AnalyticsUrl}?action=${Action}&arch=${Arch}&os=Windows&v=${DateUpdated}"
        Invoke-WebRequest -Uri $uri -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue | Out-Null
    } catch {
        # Analytics failure must never block the script
    }
}

function Remove-TmpDir {
    if (Test-Path $TmpDir) {
        Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
    }
}

function Write-Banner {
    Write-Host ""
    Write-Host "  -------------------------------------------------------------------"
    Write-Host "  | XMapTools Windows bootstrap script for installation and updates |"
    Write-Host "  |            https://xmaptools.ch - P. Lanari, 2025-2026          |"
    Write-Host "  |                Shell script version: $DateUpdated                 |"
    Write-Host "  -------------------------------------------------------------------"
    Write-Host ""
}

function Write-Info {
    Write-Banner

    Write-Host "  Available version:"
    Write-Host ""
    Write-Host "    Windows (v99 / R2020b)"
    Write-Host "      Stable installer: $InstallUrl"
    Get-RemoteTimestamp $InstallUrl
    Write-Host "      Stable update:    $UpdateUrl"
    Get-RemoteTimestamp $UpdateUrl
    Write-Host "      Dev installer:    $DevInstallUrl"
    Get-RemoteTimestamp $DevInstallUrl
    Write-Host "      Dev update:       $DevUpdateUrl"
    Get-RemoteTimestamp $DevUpdateUrl
    Write-Host ""

    Write-Host "  Detected MATLAB Runtime installations:"
    Write-Host ""
    if (Test-Path $MCRDir) {
        $found = $false
        Get-ChildItem -Path $MCRDir -Directory | ForEach-Object {
            switch ($_.Name) {
                "v99"    { Write-Host "    v99  (R2020b) [supported]"; $found = $true }
                default  { Write-Host "    $($_.Name) (unsupported version)"; $found = $true }
            }
        }
        if (-not $found) {
            Write-Host "    [WARNING] No supported MATLAB Runtime version found."
        }
    } else {
        Write-Host "    [WARNING] No MATLAB Runtime directory found at $MCRDir"
    }
    Write-Host ""

    Write-Host "  Usage:"
    Write-Host ""
    Write-Host "    iex ""& { `$(irm https://xmaptools.ch/install.ps1) } <arguments>"""
    Write-Host ""
    Write-Host "    Arguments:"
    Write-Host "      --install       Full installation (stable)"
    Write-Host "      --update        Update the application files only (stable)"
    Write-Host "      --install-dev   Full installation (developer)"
    Write-Host "      --update-dev    Update the application files only (developer)"
    Write-Host "      --info          Show this information"
    Write-Host ""
    Write-Host "  Notes:"
    Write-Host ""
    Write-Host "    - You may need to run PowerShell as Administrator."
    Write-Host "    - If XMapTools reports an invalid MCR version after updating,"
    Write-Host "      please perform a full reinstallation using --install."
    Write-Host "    - Developer versions (--install-dev / --update-dev) are for testing"
    Write-Host "      purposes and may be unstable."
    Write-Host ""
}

function Get-RemoteTimestamp {
    param([string]$Url)
    try {
        $response = Invoke-WebRequest -Uri $Url -Method Head -UseBasicParsing
        $lastModified = $response.Headers["Last-Modified"]
        if ($lastModified) {
            Write-Host "    ** XMapTools version: $lastModified"
        } else {
            Write-Host "  [WARNING] Could not retrieve remote file timestamp."
        }
    } catch {
        Write-Host "  [WARNING] Could not retrieve remote file timestamp."
    }
}

function Test-MCR {
    Write-Host "  Checking MATLAB Runtime ..."
    if (Test-Path $MCRDir) {
        Write-Host "    MATLAB Runtime found."
    } else {
        Write-Host "    [WARNING] MATLAB Runtime not found."
        Write-Host "    A full installation is required to set up the runtime:"
        Write-Host "      iex ""& { `$(irm https://xmaptools.ch/install.ps1) } --install"""
    }
    Write-Host ""
}

# ---- Install function ------------------------------------------------------
function Invoke-Install {
    param(
        [string]$Url = $InstallUrl,
        [string]$Action = "install"
    )
    $ZipPath       = "$TmpDir\XMapToolsInstaller.zip"
    $InstallerName = "XMapToolsInstaller_Windows.exe"
    $InstallerPath = "$TmpDir\$InstallerName"

    Clear-Host
    Write-Banner
    Write-Host "  Installing XMapTools ..."
    Send-TrackEvent -Action $Action
    Write-Host ""

    Write-Host "  Preparing temporary workspace ..."
    Remove-TmpDir
    New-Item -ItemType Directory -Path $TmpDir | Out-Null

    if (Test-Path $InstallDir) {
        Write-Host "  Removing previous installation ..."
        Remove-Item -Recurse -Force $InstallDir
    }

    Get-RemoteTimestamp $Url
    Write-Host ""
    Write-Host "  Downloading installer ..."
    Write-Host "    $Url"
    Invoke-WebRequest -Uri $Url -OutFile $ZipPath -UseBasicParsing
    Write-Host ""

    Write-Host "  Extracting installer ..."
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $TmpDir -Force

    if (-not (Test-Path $InstallerPath)) {
        Write-Host "  [ERROR] Expected $InstallerName inside the archive, but it was not found."
        Remove-TmpDir
        Read-Host "  Press Enter to close this window"
        exit 1
    }

    Write-Host "  Launching graphical installer ..."
    Start-Process -FilePath $InstallerPath
    Write-Host ""

    Test-MCR

    Write-Host "  [OK] The request to launch the XMapTools installer was sent successfully."
    Write-Host "  Please be patient, the installer window may take a few minutes to appear."
    Write-Host "  Follow the on-screen instructions to complete the installation."
    Write-Host ""
}

# ---- Update function -------------------------------------------------------
function Invoke-Update {
    param(
        [string]$Url = $UpdateUrl,
        [string]$Action = "update",
        [string]$FallbackInstallUrl = $InstallUrl,
        [string]$FallbackInstallAction = "install"
    )
    $ZipPath      = "$TmpDir\XMapTools_Windows.zip"
    $ExtractedDir = "$TmpDir\XMapTools"
    $ExeName      = "XMapTools.exe"
    $SplashName   = "splash.png"

    Clear-Host
    Write-Banner
    Write-Host "  Updating XMapTools ..."
    Send-TrackEvent -Action $Action
    Write-Host ""

    Write-Host "  Verifying existing installation ..."
    if (-not (Test-Path $TargetDir)) {
        Write-Host ""
        Write-Host "  [ERROR] Target directory does not exist: $TargetDir"
        Write-Host "  XMapTools does not appear to be installed. Please run a full"
        Write-Host "  installation first:"
        Write-Host "    iex ""& { `$(irm https://xmaptools.ch/install.ps1) } --install"""
        Read-Host "  Press Enter to close this window"
        exit 1
    }

    Write-Host "  Checking MATLAB Runtime ..."
    $MCRv99 = "$MCRDir\v99"
    if (-not (Test-Path $MCRv99)) {
        Write-Host ""
        Write-Host "  [WARNING] MATLAB Runtime v99 (R2020b) is not installed."
        Write-Host "  XMapTools 4.5 requires MATLAB Runtime v99 to run."
        Write-Host ""
        $answer = Read-Host "  Would you like to run a full installation instead? (y/n)"
        if ($answer -eq "y" -or $answer -eq "Y") {
            Invoke-Install -Url $FallbackInstallUrl -Action $FallbackInstallAction
            return
        } else {
            Write-Host ""
            Write-Host "  Update cancelled."
            Read-Host "  Press Enter to close this window"
            exit 1
        }
    }
    Write-Host "    MATLAB Runtime v99 (R2020b) found."
    Write-Host ""

    Write-Host "  Preparing temporary workspace ..."
    Remove-TmpDir
    New-Item -ItemType Directory -Path $TmpDir | Out-Null

    Get-RemoteTimestamp $Url
    Write-Host ""
    Write-Host "  Downloading latest version ..."
    Write-Host "    $Url"
    Invoke-WebRequest -Uri $Url -OutFile $ZipPath -UseBasicParsing
    Write-Host ""

    Write-Host "  Extracting archive ..."
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $ExtractedDir -Force

    $SrcExe    = "$ExtractedDir\$ExeName"
    $SrcSplash = "$ExtractedDir\$SplashName"

    if (-not (Test-Path $SrcExe)) {
        Write-Host "  [ERROR] Expected $ExeName inside the archive, but it was not found."
        Remove-TmpDir
        Read-Host "  Press Enter to close this window"
        exit 1
    }

    Write-Host "  Replacing application files ..."
    Copy-Item -Path $SrcExe -Destination "$TargetDir\$ExeName" -Force
    Write-Host "    $TargetDir\$ExeName"
    if (Test-Path $SrcSplash) {
        Copy-Item -Path $SrcSplash -Destination "$TargetDir\$SplashName" -Force
        Write-Host "    $TargetDir\$SplashName"
    }

    Write-Host "  Cleaning up temporary files ..."
    Remove-TmpDir
    Write-Host ""

    Test-MCR

    Write-Host "  [OK] XMapTools has been updated successfully."
    Write-Host ""
}

# ---- Main logic ------------------------------------------------------------
$Mode = if ($args.Count -gt 0) { $args[0] } else { "" }

switch ($Mode) {

    "--info" {
        Write-Info
    }

    "--install" {
        Invoke-Install -Url $InstallUrl -Action "install"
    }

    "--install-dev" {
        Invoke-Install -Url $DevInstallUrl -Action "install-dev"
    }

    "--update" {
        Invoke-Update -Url $UpdateUrl -Action "update" -FallbackInstallUrl $InstallUrl -FallbackInstallAction "install"
    }

    "--update-dev" {
        Invoke-Update -Url $DevUpdateUrl -Action "update-dev" -FallbackInstallUrl $DevInstallUrl -FallbackInstallAction "install-dev"
    }

    default {
        Write-Info
    }
}
