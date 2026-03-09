# ============================================================
#  PS7 Profile — PowerShell\Microsoft.PowerShell_profile.ps1
#  Launch with: pwsh.exe -NoLogo  (removes "PowerShell 7.5.4" header)
# ============================================================

# ── Prompt: simple robbyrussell, always green ❯ ──────────────
function global:prompt {
    $dir = Split-Path -Leaf (Get-Location)
    if ($dir -eq '\' -or $dir -eq '/') { $dir = (Get-Location).Drive.Name + ':' }

    Write-Host "❯" -ForegroundColor Green -NoNewline
    Write-Host " $dir" -ForegroundColor Cyan -NoNewline

    # Detect git repo using filesystem only — no git calls, no LASTEXITCODE pollution
    $gitRoot = $PWD.Path
    $isRepo  = $false
    while ($gitRoot -and $gitRoot -ne (Split-Path $gitRoot -Parent)) {
        if (Test-Path (Join-Path $gitRoot '.git')) { $isRepo = $true; break }
        $gitRoot = Split-Path $gitRoot -Parent
    }

    if ($isRepo) {
        $headFile = Join-Path $gitRoot '.git\HEAD'
        $branch   = 'HEAD'
        if (Test-Path $headFile) {
            $headContent = Get-Content $headFile -Raw
            if ($headContent -match 'ref: refs/heads/(.+)') { $branch = $Matches[1].Trim() }
        }

        # Dirty indicator: * if index changed (staged), ~ if working tree dirty
        $indexFile  = Join-Path $gitRoot '.git\index'
        $mergeFile  = Join-Path $gitRoot '.git\MERGE_HEAD'
        $rebaseDir  = Join-Path $gitRoot '.git
ebase-merge'

        $indicator = ''
        if (Test-Path $mergeFile)  { $indicator = ' ~merge~' }
        elseif (Test-Path $rebaseDir) { $indicator = ' ~rebase~' }
        elseif ((Test-Path $indexFile) -and
                (Get-Item $indexFile).LastWriteTime -gt (Get-Item $headFile).LastWriteTime) {
            $indicator = ' *'
        }

        Write-Host " git:(" -ForegroundColor Blue -NoNewline
        Write-Host "$branch" -ForegroundColor Cyan -NoNewline
        Write-Host ")" -ForegroundColor Blue -NoNewline
        if ($indicator) { Write-Host $indicator -ForegroundColor Yellow -NoNewline }
    }

    return " "
}

# ── Modules ──────────────────────────────────────────────────
Import-Module PSReadLine
# Force load PSFzf from known location
$_psfzf = "$env:USERPROFILE\OneDrive - Hexagon\Documents\PowerShell\Modules\PSFzf\PSFzf.psd1"
if (Test-Path $_psfzf) { Import-Module $_psfzf -ErrorAction SilentlyContinue }
else { Import-Module PSFzf -ErrorAction SilentlyContinue }
Import-Module z     -ErrorAction SilentlyContinue

# ── PSReadLine ───────────────────────────────────────────────
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 10000
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -Colors @{
    Command                = [System.ConsoleColor]::Cyan
    Parameter              = [System.ConsoleColor]::DarkCyan
    String                 = [System.ConsoleColor]::Yellow
    Operator               = [System.ConsoleColor]::Magenta
    Variable               = [System.ConsoleColor]::Green
    Comment                = [System.ConsoleColor]::DarkGray
    Keyword                = [System.ConsoleColor]::Blue
    Error                  = [System.ConsoleColor]::Red
    InlinePrediction       = [System.ConsoleColor]::DarkGray
    ListPrediction         = [System.ConsoleColor]::DarkCyan
    ListPredictionSelected = [System.ConsoleColor]::Cyan
}

Set-PSReadLineKeyHandler -Key Tab               -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow           -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow         -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key 'Ctrl+Spacebar'   -Function MenuComplete
Set-PSReadLineKeyHandler -Key 'F2'              -Function SwitchPredictionView
Set-PSReadLineKeyHandler -Key 'Ctrl+RightArrow' -Function ForwardWord
Set-PSReadLineKeyHandler -Key 'Ctrl+LeftArrow'  -Function BackwardWord
Set-PSReadLineKeyHandler -Key 'Ctrl+Backspace'  -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key 'Ctrl+z'          -Function Undo

# Ctrl+D: exit if line empty, else delete char
Set-PSReadLineKeyHandler -Key 'Ctrl+d' -ScriptBlock {
    $line = $null; $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($line.Length -eq 0) {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert('exit')
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::DeleteChar()
    }
}

# ── fzf config + key bindings ───────────────────────────────
$env:FZF_DEFAULT_OPTS = '--height=50% --layout=reverse --border=rounded --padding=1,2 --info=inline --bind=esc:abort'

if (Get-Module PSFzf) {
    Set-PsFzfOption -PSReadLineChordReverseHistory 'Ctrl+r'
    Set-PsFzfOption -PSReadLineChordProvider       'Ctrl+t'
} else {
    # Fallback: raw fzf if PSFzf failed to load
    Set-PSReadLineKeyHandler -Key 'Ctrl+r' -ScriptBlock {
        $cmd = Get-Content (Get-PSReadLineOption).HistorySavePath |
            Sort-Object -Unique | fzf --tac --height=50% --layout=reverse --border=rounded 2>$null
        if ($cmd) { [Microsoft.PowerShell.PSConsoleReadLine]::Insert($cmd) }
    }
    Set-PSReadLineKeyHandler -Key 'Ctrl+t' -ScriptBlock {
        $f = fzf --height=50% --layout=reverse --border=rounded 2>$null
        if ($f) { [Microsoft.PowerShell.PSConsoleReadLine]::Insert($f) }
    }
}

# ── Navigation ───────────────────────────────────────────────
function ..   { Set-Location .. }
function ...  { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ~    { Set-Location $HOME }

# ── Listing ──────────────────────────────────────────────────
# eza: use cyan for dirs instead of bold blue (matches terminal theme better)
$env:EZA_COLORS = "di=36:ex=32:fi=0:ln=35"

if (Get-Command eza -EA SilentlyContinue) {
    function ls  { eza -l  --color=always --icons --group-directories-first @args }
    function la  { eza -al --color=always --icons --group-directories-first @args }
    function ll  { eza -a  --color=always --icons --group-directories-first @args }
    function lt  { eza -aT --color=always --icons --group-directories-first --level=2 @args }
    function ltt { eza -aT --color=always --icons --group-directories-first @args }
} else {
    function ls { Get-ChildItem @args }
    function la { Get-ChildItem -Force @args }
}
function l { ls @args }

# ── Git: rich UI ─────────────────────────────────────────────
function gs {
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    if (-not $branch) { Write-Host "  Not a git repo" -ForegroundColor Red; return }

    $ahead  = (git rev-list "@{upstream}..HEAD" 2>$null | Measure-Object -Line).Lines
    $behind = (git rev-list "HEAD..@{upstream}" 2>$null | Measure-Object -Line).Lines

    Write-Host ""
    Write-Host "  󰊢  $branch " -ForegroundColor Cyan -NoNewline
    if ($ahead  -gt 0) { Write-Host "⇡$ahead "  -ForegroundColor Green -NoNewline }
    if ($behind -gt 0) { Write-Host "⇣$behind " -ForegroundColor Red   -NoNewline }
    Write-Host ""
    Write-Host "  $('─' * 40)" -ForegroundColor DarkGray

    $status = git status --porcelain=v1 2>$null
    if (-not $status) { Write-Host "  ✓  nothing to commit, working tree clean`n" -ForegroundColor Green; return }

    $staged    = $status | Where-Object { $_ -match '^[MADRC]' }
    $unstaged  = $status | Where-Object { $_ -match '^.[MD]' }
    $untracked = $status | Where-Object { $_ -match '^\?\?' }
    $conflicts = $status | Where-Object { $_ -match '^(DD|AU|UD|UA|DU|AA|UU)' }

    if ($conflicts) {
        Write-Host "`n  ✖  Conflicts:" -ForegroundColor Red
        $conflicts | ForEach-Object { Write-Host "     $($_.Substring(3))" -ForegroundColor Red }
    }
    if ($staged) {
        Write-Host "`n  ●  Staged:" -ForegroundColor Green
        $staged | ForEach-Object {
            $label = switch ($_.Substring(0,1)) {
                'A' {'  added   '} 'M' {'  modified'} 'D' {'  deleted '}
                'R' {'  renamed '} 'C' {'  copied  '} default {'  changed '}
            }
            Write-Host "    $label " -ForegroundColor Green -NoNewline
            Write-Host $_.Substring(3) -ForegroundColor White
        }
    }
    if ($unstaged) {
        Write-Host "`n  ○  Not staged:" -ForegroundColor Yellow
        $unstaged | ForEach-Object {
            $label = switch ($_.Substring(1,1)) {
                'M' {'  modified'} 'D' {'  deleted '} default {'  changed '}
            }
            Write-Host "    $label " -ForegroundColor Yellow -NoNewline
            Write-Host $_.Substring(3) -ForegroundColor White
        }
    }
    if ($untracked) {
        Write-Host "`n  ?  Untracked:" -ForegroundColor DarkGray
        $untracked | ForEach-Object {
            Write-Host "     untracked  " -ForegroundColor DarkGray -NoNewline
            Write-Host $_.Substring(3) -ForegroundColor White
        }
    }
    Write-Host ""
}

function gl {
    git log --graph --color=always `
        --format="%C(yellow)%h%C(reset) %C(cyan)%<(12,trunc)%ar%C(reset) %C(white)%s%C(reset) %C(dim white)— %an%C(reset)%C(auto)%d" `
        --all @args | less -RX
}

function gll {
    git log --color=always `
        --format="%C(yellow bold)%h%C(reset) %C(white bold)%s%C(reset)%n  %C(cyan)%ar%C(reset) by %C(green)%an%C(reset) <%ae>%n  %C(dim)%H%C(reset)%n" `
        @args | less -RX
}

function gd  { git diff --color=always --word-diff=color @args | less -RX }
function gds { git diff --cached --color=always --word-diff=color @args | less -RX }
function gb  { git branch -vv --color=always @args }
function gba { git branch -avv --color=always @args }

function gsh {
    param([string]$ref = "HEAD")
    git show --color=always --stat --word-diff=color $ref @args | less -RX
}

function gstash {
    $stashes = git stash list 2>$null
    if (-not $stashes) { Write-Host "  No stashes" -ForegroundColor DarkGray; return }
    Write-Host "`n  📦  Stashes:`n  $('─' * 40)" -ForegroundColor Cyan
    $stashes | ForEach-Object {
        if ($_ -match 'stash@\{(\d+)\}: (.+)') {
            Write-Host "  [$($Matches[1])] " -ForegroundColor Yellow -NoNewline
            Write-Host $Matches[2] -ForegroundColor White
        }
    }
    Write-Host ""
}

function ginfo {
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    if (-not $branch) { Write-Host "  Not a git repo" -ForegroundColor Red; return }
    $remote  = git remote get-url origin 2>$null
    $commits = git rev-list --count HEAD 2>$null
    $tags    = (git tag 2>$null | Measure-Object -Line).Lines
    $stashes = (git stash list 2>$null | Measure-Object -Line).Lines
    $root    = git rev-parse --show-toplevel 2>$null
    Write-Host ""
    Write-Host "  ╭─  Repo Info  ──────────────────────────╮" -ForegroundColor Cyan
    Write-Host "  │  󰊢  Branch  : " -NoNewline -ForegroundColor Cyan; Write-Host $branch  -ForegroundColor Yellow
    Write-Host "  │    Root    : " -NoNewline -ForegroundColor Cyan; Write-Host $root    -ForegroundColor White
    Write-Host "  │    Remote  : " -NoNewline -ForegroundColor Cyan; Write-Host $remote  -ForegroundColor Green
    Write-Host "  │    Commits : " -NoNewline -ForegroundColor Cyan; Write-Host $commits -ForegroundColor White
    Write-Host "  │    Tags    : " -NoNewline -ForegroundColor Cyan; Write-Host $tags    -ForegroundColor White
    Write-Host "  │  📦  Stashes : " -NoNewline -ForegroundColor Cyan; Write-Host $stashes -ForegroundColor White
    Write-Host "  ╰────────────────────────────────────────╯" -ForegroundColor Cyan
    Write-Host ""
}

function ga    { git add @args }
function gaa   { git add -A }
function gcm   { param([string]$msg) git commit -m $msg }
function gca   { git commit --amend --no-edit }
function gc    { git clone @args }
function gp    { git push @args }
function gpb   { git push -u origin @args }
function gpl   { git pull @args }
function gco   { git checkout @args }
function gsw   { git switch @args }
function gst   { git stash @args }
function gstp  { git stash pop }
function gsta  { git stash apply @args }
function grb   { git rebase @args }
function grbi  { param([string]$n = "HEAD~3") git rebase -i $n }
function grepo { git count-objects -vH }

# ── Utilities ────────────────────────────────────────────────
function mkcd {
    param([string]$dir)
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Set-Location $dir
}
function which   { param($cmd) (Get-Command $cmd -EA SilentlyContinue).Source }
function path    { $env:PATH -split ';' }
function ports   { netstat -ano | findstr LISTENING }
function myip    { (Invoke-WebRequest -Uri 'https://ifconfig.me' -UseBasicParsing).Content.Trim() }
function clr     { Clear-Host }
function q       { exit }
function reload  { . $PROFILE; Write-Host "  ✅  Profile reloaded" -ForegroundColor Green }
function profile { code $PROFILE }

function touch {
    param([string]$file)
    if (Test-Path $file) { (Get-Item $file).LastWriteTime = Get-Date }
    else { New-Item -ItemType File -Path $file | Out-Null }
}

function grep {
    param([string]$pattern, [string]$path = ".")
    Select-String -Pattern $pattern -Path (Join-Path $path "*") -Recurse
}

function sysinfo {
    $os   = Get-CimInstance Win32_OperatingSystem
    $cpu  = (Get-CimInstance Win32_Processor).Name
    $ram  = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $free = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    $used = [math]::Round($ram - $free, 1)
    $up   = (Get-Date) - $os.LastBootUpTime
    $ups  = "{0}d {1}h {2}m" -f $up.Days, $up.Hours, $up.Minutes
    Write-Host ""
    Write-Host "  ╭─  System  ─────────────────────────────╮" -ForegroundColor Magenta
    Write-Host "  │    Host   : " -NoNewline -ForegroundColor Magenta; Write-Host $env:COMPUTERNAME         -ForegroundColor White
    Write-Host "  │    User   : " -NoNewline -ForegroundColor Magenta; Write-Host $env:USERNAME             -ForegroundColor White
    Write-Host "  │    OS     : " -NoNewline -ForegroundColor Magenta; Write-Host $os.Caption               -ForegroundColor White
    Write-Host "  │    CPU    : " -NoNewline -ForegroundColor Magenta; Write-Host $cpu                      -ForegroundColor White
    Write-Host "  │    RAM    : " -NoNewline -ForegroundColor Magenta; Write-Host "${used}GB / ${ram}GB"    -ForegroundColor White
    Write-Host "  │    Uptime : " -NoNewline -ForegroundColor Magenta; Write-Host $ups                      -ForegroundColor White
    Write-Host "  │    PS     : " -NoNewline -ForegroundColor Magenta; Write-Host $PSVersionTable.PSVersion -ForegroundColor White
    Write-Host "  ╰────────────────────────────────────────╯" -ForegroundColor Magenta
    Write-Host ""
}

function halp {
    Write-Host ""
    Write-Host "  ╭─  Commands  ────────────────────────────────────────────────────╮" -ForegroundColor Cyan
    Write-Host "  │  NAVIGATE    ..  ...  ....  ~                                   │" -ForegroundColor White
    Write-Host "  │  LIST        ls  la  ll  lt  ltt                                │" -ForegroundColor White
    Write-Host "  │  GIT         gs  gl  gll  gd  gds  gb  gba  gsh  gstash  ginfo │" -ForegroundColor White
    Write-Host "  │              ga  gaa  gcm  gca  gp  gpb  gpl  gco  gsw          │" -ForegroundColor White
    Write-Host "  │              gst  gstp  grbi                                    │" -ForegroundColor White
    Write-Host "  │  TOOLS       sysinfo  mkcd  which  path  ports  myip            │" -ForegroundColor White
    Write-Host "  │              touch  grep  reload  profile                       │" -ForegroundColor White
    Write-Host "  │  KEYS        ↑↓ history  Ctrl+R fzf  Ctrl+T files              │" -ForegroundColor White
    Write-Host "  │              F2 toggle list/inline  Ctrl+D exit/delete          │" -ForegroundColor White
    Write-Host "  ╰────────────────────────────────────────────────────────────────╯" -ForegroundColor Cyan
    Write-Host ""
}