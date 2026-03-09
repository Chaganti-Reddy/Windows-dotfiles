# ============================================================
#  PS5 Profile — WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#  Opened by: powershell.exe
#  Limited features — upgrade to pwsh for full experience
# ============================================================

oh-my-posh init pwsh --config "$env:USERPROFILE\OneDrive - Hexagon\Documents\backup\robbyrussell.omp.json" | Invoke-Expression

Import-Module Terminal-Icons -ErrorAction SilentlyContinue
Import-Module PSReadLine
Import-Module z              -ErrorAction SilentlyContinue

Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 10000
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -Colors @{
    Command          = 'Cyan'
    Parameter        = 'DarkCyan'
    String           = 'Yellow'
    Operator         = 'Magenta'
    Variable         = 'Green'
    Comment          = 'DarkGray'
    InlinePrediction = [System.ConsoleColor]::DarkGray
}

Set-PSReadLineKeyHandler -Key Tab               -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow           -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow         -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key 'Ctrl+RightArrow' -Function ForwardWord
Set-PSReadLineKeyHandler -Key 'Ctrl+LeftArrow'  -Function BackwardWord
Set-PSReadLineKeyHandler -Key 'Ctrl+Backspace'  -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key 'Ctrl+d'          -Function DeleteChar
Set-PSReadLineKeyHandler -Key 'Ctrl+z'          -Function Undo

function ..   { Set-Location .. }
function ...  { Set-Location ../.. }
function ~    { Set-Location $HOME }
function l    { ls @args }
function gs   { git status -sb @args }
function ga   { git add @args }
function gaa  { git add -A }
function gcm  { param([string]$msg) git commit -m $msg }
function gp   { git push @args }
function gpb  { git push -u origin @args }
function gl   { git log --oneline --graph --decorate --all @args }
function gd   { git diff @args }
function gco  { git checkout @args }
function gb   { git branch @args }
function clr  { Clear-Host }
function q    { exit }
function reload { . $PROFILE; Write-Host "✅ Reloaded" -ForegroundColor Green }