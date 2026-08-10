# ============================================================
#  .zshrc — Native Windows, Git Bash + Zsh
# ============================================================

# ── Completion system ────────────────────────────────────────
autoload -Uz compinit
if [[ ! -f ~/.zcompdump || ~/.zcompdump -ot ~/.zshrc ]]; then
  compinit -d ~/.zcompdump
else
  compinit -C -d ~/.zcompdump
fi
fpath+=~/.zfunc

# ── Cursor: blinking bar ─────────────────────────────────────
precmd() { printf '\e[5 q'; }

# ============================================================
#  EXPORTS
# ============================================================
export LANG=en_US.UTF-8
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='bat'
export STARSHIP_LOG="error"
export MANPAGER="bat -l man -p"

export PATH="$HOME/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.config/scripts:$PATH"

# Java — uncomment and adjust path
# export JAVA_HOME="/c/Program Files/Java/jdk-21"
# export PATH="$JAVA_HOME/bin:$PATH"

# FZF
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git 2>/dev/null || find . -not -path '*/.git/*'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git 2>/dev/null || find . -type d -not -path '*/.git/*'"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {} 2>/dev/null || cat {}'"
export FZF_ALT_C_OPTS="--preview 'ls -al {}'"

# ============================================================
#  OH-MY-ZSH
# ============================================================
eval "$(starship init zsh)"

# ============================================================
#  PLUGINS
#  Install:
#    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
#    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
# ============================================================
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888888"
export ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(forward-word)  # Ctrl+Right — word-by-word
[[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]         && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf
if command -v fzf &>/dev/null; then
  if fzf --zsh &>/dev/null 2>&1; then
    eval "$(fzf --zsh)"
  else
    [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
  fi
fi

# zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Starship — uncomment to replace OMZ prompt
# command -v starship &>/dev/null && eval "$(starship init zsh)"

# ============================================================
#  ZSH OPTIONS
# ============================================================
# stty -ixon removed — can cause issues in Windows Terminal / ConEmu
setopt AUTO_CD HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY CORRECT
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# ============================================================
#  ALIASES
# ============================================================

# Navigation — Git Bash mounts drives as /c /d not /mnt/c /mnt/d
alias cd='z'
alias cdi='zi'
alias d='cd'
alias pdw='pwd'
alias down='cd /c/Users/vchagant/Downloads' 

# Listing — eza preferred, exa fallback
if command -v eza &>/dev/null; then
  alias la='eza -al --colour=always --icons --group-directories-first'
  alias ll='eza -a  --colour=always --icons --group-directories-first'
  alias ls='eza -l  --colour=always --icons --group-directories-first'
  alias lt='eza -aT --colour=always --icons --group-directories-first'
elif command -v exa &>/dev/null; then
  alias la='exa -al --colour=always --icons --group-directories-first'
  alias ll='exa -a  --colour=always --icons --group-directories-first'
  alias ls='exa -l  --colour=always --icons --group-directories-first'
  alias lt='exa -aT --colour=always --icons --group-directories-first'
fi
alias l='ls'
alias l.="ls -A | grep -E '^\\.'"

# Editor
alias n='nvim'

# Git
alias gs='git status'
alias ga='git add'
alias gcm='git commit -m'
alias gc='git clone'
alias gp='git push'
alias gpb='git push -u origin'
alias reposize='git count-objects -vH'

# pretty git log graph
function glog() {
  git log --oneline --graph --decorate --all | head -${1:-30}
}

# show what changed in last N commits (default 1)
function gdiff() {
  git diff HEAD~${1:-1} HEAD
}

# search through all commit messages
function gsearch() {
  [[ -z "$1" ]] && { echo "Usage: gsearch <term>"; return 1; }
  git log --all --oneline --grep="$1"
}

# show all files changed in last N commits
function gfiles() {
  git diff --name-only HEAD~${1:-1} HEAD
}

# undo last N commits but keep changes staged
# function gundo() {
#   git reset --soft HEAD~${1:-1}
# }

# stash with a message
# function gst() {
#   [[ -z "$1" ]] && git stash || git stash push -m "$1"
# }

# list stashes and pick one to apply with fzf
# function gsp() {
#   local stash
#   stash=$(git stash list | fzf | cut -d: -f1)
#   [[ -n "$stash" ]] && git stash pop "$stash"
# }

# switch branches with fzf
function gbp() {
  local branch
  branch=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | fzf) || return
  echo "→ $branch"
  git checkout "${branch#origin/}"
}

# File ops
alias cp='cp -i'
alias mv='mv -i'
alias cat='bat --style=header,snip,changes'
alias df='df -h'
alias rg='rg --sort path'

# Grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Windows clipboard & open
alias pbcopy='clip.exe'
alias pbpaste='powershell.exe -command "Get-Clipboard"'
alias open='start'    

# Misc
alias cls='clear'
alias fman='man $(man -k . | fzf | awk "{print \$1}") 2>/dev/null'
alias please='fc -s'
alias lastarg='echo $_'

# YouTube (requires yt-dlp installed and on PATH)
alias yta-mp3='yt-dlp --extract-audio --audio-format mp3 --embed-thumbnail'
alias yta-flac='yt-dlp --extract-audio --audio-format flac --embed-thumbnail'
alias yta-best='yt-dlp --extract-audio --audio-format best --embed-thumbnail'
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --embed-thumbnail --merge-output-format mp4"

# ============================================================
#  FUNCTIONS
# ============================================================

# Sparkline — works as:  spark 1 2 3   AND   echo "1 2 3" | spark
function spark() {
  local -a nums
  if [[ $# -gt 0 ]]; then
    nums=("$@")
  else
    local line
    while IFS= read -r line; do
      for word in $line; do nums+=("$word"); done
    done
  fi
  printf "%s\n" "${nums[@]}" | awk '
    BEGIN { n = split("▁ ▂ ▃ ▄ ▅ ▆ ▇ █", b, " "); count = 0 }
    /^-?[0-9.]+$/ {
      data[count++] = $1
      if (count==1 || $1<mn) mn=$1
      if (count==1 || $1>mx) mx=$1
    }
    END {
      s = (mx==mn) ? 1 : (mx-mn)/(n-1)
      for (i=0; i<count; i++) {
        idx = (s==0) ? 1 : int((data[i]-mn)/s)+1
        if (idx<1) idx=1; if (idx>n) idx=n
        printf "%s", b[idx]
      }
      print ""
    }
  '
}

# Ctrl+L — clear + sparkline
function fancy_clear() {
  clear
  seq 1 "$(tput cols)" | shuf | spark
  echo
  zle reset-prompt
}
zle -N fancy_clear
# bindkey '^L' fancy_clear

# Git commits info
function commits() {
  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo
    echo "  usage: commits [author] [branch] [since]"
    echo
    echo "  all args are optional and smart — pass in any order:"
    echo "    author  — name string matched against git log  (default: git config user.name)"
    echo "    branch  — any valid branch or ref              (default: current branch)"
    echo "    since   — any git date string                  (default: '1 year ago')"
    echo
    echo "  examples:"
    echo "    commits"
    echo "    commits main"
    echo "    commits \"3 months ago\""
    echo "    commits main \"3 months ago\""
    echo "    commits \"John\" main \"6 months ago\""
    echo
    return 0
  fi

  local author=""
  local since="1 year ago"
  local branch=$(git rev-parse --abbrev-ref HEAD)

  for arg in "$@"; do
    if git rev-parse --verify "$arg" &>/dev/null 2>&1; then
      branch="$arg"
    elif [[ "$arg" =~ ^[0-9]+\ +(second|minute|hour|day|week|month|year)s?\ +ago$ || "$arg" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      since="$arg"
    else
      author="$arg"
    fi
  done

  # fallback to git config if no author arg given
  [[ -z "$author" ]] && author=$(git config user.name)

  local total=$(git log "$branch" --author="$author" --since="$since" --oneline | wc -l | tr -d ' ')

  echo
  echo "  author : $author"
  echo "  repo   : $(basename $(git rev-parse --show-toplevel))"
  echo "  branch : $branch"
  echo "  since  : $since"
  echo "  total  : $total commits"
  echo

  echo "  daily activity:"
  git log "$branch" --author="$author" --since="$since" --format=format:%ad --date=short \
    | uniq -c | awk '{print $1}' | spark
  echo

  echo "  top days:"
  git log "$branch" --author="$author" --since="$since" --format=format:%ad --date=short \
    | sort | uniq -c | sort -rn | head -5 \
    | awk '{printf "    %s  →  %s commits\n", $2, $1}'
  echo

  echo "  recent commits:"
  git log "$branch" --author="$author" --since="$since" --format=format:"    %ad  %s" --date=short | head -10
  echo
}

# Letter frequency sparkline
function letters() {
  command cat "$@" \
    | awk -vFS='' '{for(i=1;i<=NF;i++) if($i~/[a-zA-Z]/) w[tolower($i)]++}
        END{for(i in w) print i,w[i]}' \
    | sort | cut -c3- \
    | spark
  echo "abcdefghijklmnopqrstuvwxyz"
}

function wordfreq() {
  command cat "$@" | tr -s '[:space:]' '\n' | tr '[:upper:]' '[:lower:]' \
    | grep -v '^$' | sort | uniq -c | sort -rn | head -20 \
    | awk '{printf "  %5d  %s\n", $1, $2}'
}

# Open/create file with nvim, auto-making parent dirs
function nv() {
  [[ -z "$1" ]] && { echo "Usage: nv path/to/file"; return 1; }
  local file="${1/#\~/$HOME}"
  [[ "$file" != /* ]] && file="$PWD/$file"
  local dir="${file%/*}"
  [[ "$dir" != "$file" && ! -d "$dir" ]] && \
    { mkdir -p "$dir" || { echo "Failed to create: $dir"; return 2; }; }
  nvim "$file"
}

function ex() {
  [[ ! -f "$1" ]] && { echo "'$1' is not a valid file"; return 1; }
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xf  "$1" ;;
    *.tar.zst) tar xf  "$1" ;;
    *.tar)     tar xf  "$1" ;;
    *.gz)      gunzip  "$1" ;;
    *.zip)     unzip   "$1" ;;
    *.7z)      7z x    "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.rar)     7z x    "$1" ;;
    *)         echo "'$1' cannot be extracted via ex()" ;;
  esac
}

function comp() {
  [[ -z "$1" ]] && { echo "Usage: comp <file_or_directory>"; return 1; }
  local input="$1"
  local options=("tar.gz" "zip" "7z" "tar.xz" "tar.zst" "tar.bz2" "tar" "gz")
  echo "Select format:"; for i in {1..${#options[@]}}; do echo "$i) ${options[$i]}"; done
  echo -n "Choice: "; read choice
  [[ "$choice" -lt 1 || "$choice" -gt ${#options[@]} ]] && { echo "Invalid."; return 1; }
  local fmt="${options[$choice]}" out="${input}.${options[$choice]}"
  case $fmt in
    tar.gz)  tar czf "$out" "$input" ;;
    tar.bz2) tar cjf "$out" "$input" ;;
    tar.xz)  tar cJf "$out" "$input" ;;
    tar.zst) tar --zstd -cf "$out" "$input" ;;
    tar)     tar cf  "$out" "$input" ;;
    gz)      gzip -k "$input" ;;
    zip)     zip -r  "$out" "$input" ;;
    7z)      7z a    "$out" "$input" ;;
  esac
  echo "Done: $out"
}

# Compile + time C/C++
function ctime() {
  local f="$1"
  [[ $f != *.c ]] && f="$1.c"
  local o="${f%.c}"
  g++ -std=c++17 "$f" -o "$o" && { time ./"$o"; }
}
function cpptime() {
  local f="$1"
  [[ $f != *.cpp ]] && f="$1.cpp"
  local o="${f%.cpp}"
  g++ -std=c++17 "$f" -o "$o" && { time ./"$o"; }
}

# Cheat sheet
function cheat() { curl cht.sh/"$1"; }

# Backup a file
function backup() { cp "$1" "$1.bak"; }

# Smart recursive copy
function copy() { [[ $# -eq 2 && -d "$1" ]] && cp -r "${1%/}" "$2" || cp "$@"; }

# Pipeline utils
function coln() { while read -r line; do echo "$line" | awk "{ print \$$1 }"; done; }
function rown()  { sed -n "${1}p"; }
function skip()  { tail -n +"$(( $1 + 1 ))"; }
function take()  { head -n "$1"; }

# ============================================================
#  Smart Directory Picker (zoxide + filesystem + fzf)
# ============================================================
function fcd() {
  local dir

  dir=$(
    {
      # 1. zoxide learned dirs (FAST)
      zoxide query -l 2>/dev/null

      # 2. fallback filesystem scan (COMPLETE)
      find ~ -type d -maxdepth 5 -not -path '*/.git/*' 2>/dev/null
    } | awk '!seen[$0]++' | fzf \
        --height 60% \
        --border \
        --preview 'eza -la --icons {} 2>/dev/null || ls -al {}' \
        --bind 'ctrl-/:toggle-preview'
  ) || return

  # use zoxide jump (keeps learning behavior)
  z "$dir"
}

# fzf file finder that opens in nvim
function fzf-edit() {
  local file
  file=$(fzf --preview 'bat --color=always {}') && nvim "$file"
}

bindkey -s '^F' 'fcd\n'   # Ctrl+F for fuzzy directory picker

# show disk usage of current dir sorted
function dsize() {
  du -sh ${1:-.}/* 2>/dev/null | sort -rh | head -20
}

# make a dir and cd into it
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# open current directory in Windows Explorer
function explore() {
  start "$(pwd -W)"
}

# get your local and public IP
function myip() {
  echo "  local  : $(ipconfig.exe 2>/dev/null | grep 'IPv4' | head -1 | awk '{print $NF}')"
  echo "  public : $(curl -s ifconfig.me)"
}

# flush Windows DNS cache
function flushdns() {
  ipconfig.exe /flushdns
}

# timer — countdown in seconds
function timer() {
  local secs=${1:-60}
  while [[ $secs -gt 0 ]]; do
    printf "\r  ⏱  %02d:%02d remaining" $((secs/60)) $((secs%60))
    sleep 1
    (( secs-- ))
  done
  printf "\r  ✓  done!                \n"
}

# quick notes — append to ~/notes.md and view
function note() {
  local file="$HOME/notes.md"
  if [[ -z "$1" ]]; then
    bat "$file" 2>/dev/null || cat "$file"
  else
    echo "$(date '+%Y-%m-%d %H:%M')  $*" >> "$file"
    echo "  saved."
  fi
}

# grep through your notes
function noted() {
  grep -i "$1" "$HOME/notes.md"
}


[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Vi mode
bindkey -e  # emacs mode
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Line navigation
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-kill-word
bindkey '^R' history-incremental-search-backward
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^[b' backward-word   # Alt+b
bindkey '^[f' forward-word    # Alt+f

# Arrow keys
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char

# Ctrl+Arrow
bindkey '^[[1;5C' forward-word    # Ctrl+Right
bindkey '^[[1;5D' backward-word   # Ctrl+Left

# Delete keys
bindkey '^[[3~'   delete-char     # Delete
bindkey '^[[3;5~' kill-word       # Ctrl+Delete

# Autosuggestions
bindkey '^ ' autosuggest-accept               # Ctrl+Space — full accept

bindkey '^[[H' beginning-of-line   # Home
bindkey '^[[F' end-of-line         # End
