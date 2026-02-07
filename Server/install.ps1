 #
# XMapTools – Windows bootstrap script (PowerShell)
# Usage examples:
#   iex "& { $(irm https://xmaptools.ch/install.ps1) } --install"
#   iex "& { $(irm https://xmaptools.ch/install.ps1) } --update"
#   iex "& { $(irm https://xmaptools.ch/install.ps1) } --info" 
# ----------------------------------------------------------------------------

$ErrorActionPreference = "Stop"

# ---- Configuration ---------------------------------------------------------
$DateUpdated   = "06.02.2026"

$InstallUrl    = "https://xmaptools.ch/releases/XMapToolsInstaller_Windows.zip"
$UpdateUrl     = "https://xmaptools.ch/releases/XMapTools_Windows.zip"

$TmpDir        = "$env:TEMP\xmaptools_task"
$InstallDir    = "C:\Program Files\XMapTools"
$TargetDir     = "$InstallDir\application"
$MCRDir        = "C:\Program Files\MATLAB\MATLAB Runtime"
# ----------------------------------------------------------------------------

# ---- Helper functions ------------------------------------------------------

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
    Write-Host "  |                    last update: $DateUpdated                      |"
    Write-Host "  -------------------------------------------------------------------"
    Write-Host ""
}

function Write-Info {
    Write-Banner

    Write-Host "  Available version:"
    Write-Host ""
    Write-Host "    Windows (R2025a)"
    Write-Host "      Installer: $InstallUrl"
    Get-RemoteTimestamp $InstallUrl
    Write-Host "      Update:    $UpdateUrl"
    Get-RemoteTimestamp $UpdateUrl
    Write-Host ""

    Write-Host "  Detected MATLAB Runtime installations:"
    Write-Host ""
    if (Test-Path $MCRDir) {
        $found = $false
        Get-ChildItem -Path $MCRDir -Directory | ForEach-Object {
            switch ($_.Name) {
                "v99"    { Write-Host "    v99  (R2020b)"; $found = $true }
                "v912"   { Write-Host "    v912 (R2022a)"; $found = $true }
                "R2025a" { Write-Host "    R2025a"; $found = $true }
                default  { Write-Host "    $($_.Name) (unknown/unsupported version)"; $found = $true }
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
    Write-Host "      --install   Full installation (includes MATLAB Runtime)"
    Write-Host "      --update    Update the application files only"
    Write-Host "      --info      Show this information"
    Write-Host ""
    Write-Host "  Notes:"
    Write-Host ""
    Write-Host "    - You may need to run PowerShell as Administrator."
    Write-Host "    - If XMapTools reports an invalid MCR version after updating,"
    Write-Host "      please perform a full reinstallation using --install."
    Write-Host ""
}

function Get-RemoteTimestamp {
    param([string]$Url)
    try {
        $response = Invoke-WebRequest -Uri $Url -Method Head -UseBasicParsing
        $lastModified = $response.Headers["Last-Modified"]
        if ($lastModified) {
            Write-Host "      Version: $lastModified"
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

# ---- Main logic ------------------------------------------------------------
$Mode = if ($args.Count -gt 0) { $args[0] } else { "" }

switch ($Mode) {

    "--info" {
        Write-Info
    }

    "--install" {
        $ZipPath       = "$TmpDir\XMapToolsInstaller.zip"
        $InstallerName = "XMapToolsInstaller_Windows.exe"
        $InstallerPath = "$TmpDir\$InstallerName"

        Clear-Host
        Write-Banner
        Write-Host "  Installing XMapTools ..."
        Write-Host ""

        Write-Host "  Preparing temporary workspace ..."
        Remove-TmpDir
        New-Item -ItemType Directory -Path $TmpDir | Out-Null

        if (Test-Path $InstallDir) {
            Write-Host "  Removing previous installation ..."
            Remove-Item -Recurse -Force $InstallDir
        }

        Get-RemoteTimestamp $InstallUrl
        Write-Host ""
        Write-Host "  Downloading installer ..."
        Write-Host "    $InstallUrl"
        Invoke-WebRequest -Uri $InstallUrl -OutFile $ZipPath -UseBasicParsing
        Write-Host ""

        Write-Host "  Extracting installer ..."
        Expand-Archive -LiteralPath $ZipPath -DestinationPath $TmpDir -Force

        if (-not (Test-Path $InstallerPath)) {
            Write-Host "  [ERROR] Expected $InstallerName inside the archive, but it was not found."
            Remove-TmpDir
            exit 1
        }

        Write-Host "  Launching graphical installer ..."
        Start-Process -FilePath $InstallerPath
        Write-Host ""

        Test-MCR

        Write-Host "  [OK] The XMapTools installer window should now be open."
        Write-Host "  Follow the on-screen instructions to complete the installation."
        Write-Host ""
    }

    "--update" {
        $ZipPath      = "$TmpDir\XMapTools_Windows.zip"
        $ExtractedDir = "$TmpDir\XMapTools"
        $ExeName      = "XMapTools.exe"
        $SplashName   = "splash.png"

        Clear-Host
        Write-Banner
        Write-Host "  Updating XMapTools ..."
        Write-Host ""

        Write-Host "  Verifying existing installation ..."
        if (-not (Test-Path $TargetDir)) {
            Write-Host ""
            Write-Host "  [ERROR] Target directory does not exist: $TargetDir"
            Write-Host "  XMapTools does not appear to be installed. Please run a full"
            Write-Host "  installation first:"
            Write-Host "    iex ""& { `$(irm https://xmaptools.ch/install.ps1) } --install"""
            exit 1
        }

        Write-Host "  Preparing temporary workspace ..."
        Remove-TmpDir
        New-Item -ItemType Directory -Path $TmpDir | Out-Null

        Get-RemoteTimestamp $UpdateUrl
        Write-Host ""
        Write-Host "  Downloading latest version ..."
        Write-Host "    $UpdateUrl"
        Invoke-WebRequest -Uri $UpdateUrl -OutFile $ZipPath -UseBasicParsing
        Write-Host ""

        Write-Host "  Extracting archive ..."
        Expand-Archive -LiteralPath $ZipPath -DestinationPath $ExtractedDir -Force

        $SrcExe    = "$ExtractedDir\$ExeName"
        $SrcSplash = "$ExtractedDir\$SplashName"

        if (-not (Test-Path $SrcExe)) {
            Write-Host "  [ERROR] Expected $ExeName inside the archive, but it was not found."
            Remove-TmpDir
            exit 1
        }

        Write-Host "  Replacing application files ..."
        Copy-Item -Path $SrcExe -Destination "$TargetDir\$ExeName" -Force
        if (Test-Path $SrcSplash) {
            Copy-Item -Path $SrcSplash -Destination "$TargetDir\$SplashName" -Force
        }

        Write-Host "  Cleaning up temporary files ..."
        Remove-TmpDir
        Write-Host ""

        Test-MCR

        Write-Host "  [OK] XMapTools has been updated successfully."
        Write-Host ""
    }

    default {
        Write-Info
    }
}
