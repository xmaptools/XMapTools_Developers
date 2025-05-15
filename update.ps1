# XMapTools – Updater for Windows
# Replaces the existing XMapTools.exe and splash.png inside the application folder
# ----------------------------------------------------------------------------

# ---- Configuration ---------------------------------------------------------
$ZipUrl      = "https://xmaptools.ch/releases/XMapTools_Windows.zip"
$TmpDir      = "$env:TEMP\xmaptools_update"
$ZipPath     = "$TmpDir\XMapTools_Windows.zip"
$ExtractedDir = "$TmpDir\XMapTools"
$TargetDir   = "C:\Program Files\XMapTools\application"
$ExeName     = "XMapTools.exe"
$SplashName  = "splash.png"
# ----------------------------------------------------------------------------

# ---- Clear the terminal screen before starting -----------------------------
Clear-Host

Write-Host "> Preparing temporary workspace ($TmpDir):"
try {
    if (Test-Path $TmpDir) {
        Write-Host "    - Removing remnants of a previous update"
        Remove-Item -Recurse -Force $TmpDir
    }
    New-Item -ItemType Directory -Path $TmpDir | Out-Null
    Write-Host "    - Workspace created"
} catch {
    Write-Host "ERROR: Failed to create temporary workspace"
    Write-Host $_.Exception.Message
    Read-Host "Press Enter to exit..."
    exit 1
}
Write-Host ""

# ---- Download and Unzip ----------------------------------------------------
Write-Host "> Downloading latest version of XMapTools:"
try {
    Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath -UseBasicParsing
    Write-Host "    - Download completed"
} catch {
    Write-Host "ERROR: Failed to download ZIP archive"
    Write-Host $_.Exception.Message
    Read-Host "Press Enter to exit..."
    exit 1
}
Write-Host ""

Write-Host "> Unzipping archive to ${TmpDir}:"
try {
    Expand-Archive -Path $ZipPath -DestinationPath $ExtractedDir -Force
    Write-Host "    - Unzip successful"
} catch {
    Write-Host "ERROR: Failed to unzip the archive"
    Write-Host $_.Exception.Message
    Read-Host "Press Enter to exit..."
    exit 1
}
Write-Host ""

# ---- Check if target directory exists --------------------------------------
Write-Host "> Checking if XMapTools is installed:"
if (-Not (Test-Path $TargetDir)) {
    Write-Host "ERROR: Target directory does not exist: $TargetDir"
    Write-Host "Please install XMapTools first using the installer script."
    Read-Host "Press Enter to exit..."
    exit 1
}
Write-Host "    - Found installation directory"
Write-Host ""

# ---- Copy new files over ---------------------------------------------------
Write-Host "> Copying new files to ${TargetDir}:"
try {
    Copy-Item -Path "$ExtractedDir\$ExeName" -Destination "$TargetDir\$ExeName" -Force
    Copy-Item -Path "$ExtractedDir\$SplashName" -Destination "$TargetDir\$SplashName" -Force
    Write-Host "    - Files copied successfully"
} catch {
    Write-Host "ERROR: Failed to copy files"
    Write-Host $_.Exception.Message
    Read-Host "Press Enter to exit..."
    exit 1
}
Write-Host ""

# ---- Cleanup temporary workspace -------------------------------------------
Write-Host "> Cleaning up temporary files:"
try {
    Remove-Item -Recurse -Force $TmpDir
    Write-Host "    - Temporary files removed"
} catch {
    Write-Host "WARNING: Failed to clean up temporary files"
    Write-Host $_.Exception.Message
}
Write-Host ""

# ---- Final message ---------------------------------------------------------
Write-Host "XMapTools has been updated successfully."
Write-Host ""
Read-Host "Press Enter to exit..."
exit 0