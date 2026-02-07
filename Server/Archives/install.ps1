#
# XMapTools – Windows Bootstrap Installer
# Usage: Run this in PowerShell:
#   iex ((New-Object System.Net.WebClient).DownloadString('https://xmaptools.ch/install.ps1'))
# Alternate usage:
#   Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://xmaptools.ch/install.ps1'))
# ----------------------------------------------------------------------------

$ErrorActionPreference = "Stop"

# ---- Configuration ---------------------------------------------------------
$zipUrl = "https://xmaptools.ch/releases/XMapToolsInstaller_Windows.zip"
$tempDir = "$env:TEMP\XMapToolsInstaller"
$zipPath = "$tempDir\XMapToolsInstaller.zip"
$installerName = "XMapToolsInstaller_Windows.exe"
$installerPath = "$tempDir\$installerName"
# ----------------------------------------------------------------------------

# ---- Clear screen ----------------------------------------------------------
Clear-Host

Write-Host "> Preparing temporary workspace ($tempDir):" -ForegroundColor Cyan
if (Test-Path $tempDir) {
    Write-Host "    - Removing remnants of a previous installation" -ForegroundColor Yellow
    Remove-Item -Recurse -Force $tempDir
}
Write-Host "    - Creating temporary workspace"
New-Item -ItemType Directory -Path $tempDir | Out-Null
Write-Host ""

Write-Host "> Downloading XMapTools installer:" -ForegroundColor Cyan
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
Write-Host ""

Write-Host "> Unzipping installer" -ForegroundColor Cyan
Expand-Archive -LiteralPath $zipPath -DestinationPath $tempDir -Force
Write-Host ""

Write-Host "> Launching the graphical installer" -ForegroundColor Cyan
Start-Process -FilePath $installerPath

Write-Host ""
Write-Host "++ The XMapTools installer window is now open." -ForegroundColor Green
Write-Host "   Please follow the on-screen instructions to finish installation."
Write-Host "   When you're done, you can close this PowerShell window."
Write-Host ""