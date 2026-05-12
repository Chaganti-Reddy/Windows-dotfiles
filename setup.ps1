# =============================================================================
# setup.ps1 — Migrate from Komorebi to GlazeWM + Zebar
# Run in PowerShell as Administrator:
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   .\setup.ps1
# =============================================================================

$dotfiles = "D:\Git\Windows-dotfiles"

Write-Host "Creating config directories and symlinks..." -ForegroundColor Cyan

$glazewmSrc = "$dotfiles\glazewm"
$zebarSrc   = "$dotfiles\yasb"

$glazewmDst = "$env:USERPROFILE\.glzr\glazewm"
$zebarDst   = "$env:USERPROFILE\.config/yasb"

# Create source dirs if they don't exist
New-Item -ItemType Directory -Force -Path $glazewmSrc | Out-Null
New-Item -ItemType Directory -Force -Path $zebarSrc   | Out-Null

# Create target parent dirs
New-Item -ItemType Directory -Force -Path $glazewmDst | Out-Null
New-Item -ItemType Directory -Force -Path $zebarDst   | Out-Null

# Helper: create symlink, removing existing file/link first
function Link($src, $dst) {
    if (Test-Path $dst) { Remove-Item $dst -Force -Recurse }
    New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
    Write-Host "  Linked: $dst -> $src" -ForegroundColor Gray
}

# GlazeWM
Link "$glazewmSrc\config.yaml"    "$glazewmDst\config.yaml"

# Zebar (one symlink per file so you can still add other files in the folder)
Link "$zebarSrc\config.yaml"      "$zebarDst\config.yaml"
Link "$zebarSrc\styles.css"    "$zebarDst\styles.css"

Write-Host "`nDone! Starting GlazeWM..." -ForegroundColor Green

# Launch GlazeWM
Start-Process "C:\Program Files\glzr.io\GlazeWM\cli\glazewm.exe" -WindowStyle Hidden -ErrorAction SilentlyContinue

Write-Host @"

Your dotfiles structure:
  $dotfiles\
    glazewm\
      config.yaml
    yasb\
      config.yaml      
      styles.css

GlazeWM reads from:  %USERPROFILE%\.glzr\glazewm\config.yaml  (symlinked)
Zebar reads from:    %USERPROFILE%\.config\yash\               (symlinked)
