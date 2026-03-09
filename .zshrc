# ============================================================
#  .zshrc — No OMZ, fast startup, exact original prompt style
# ============================================================

# zmodload zsh/zprof

# ── Core env ────────────────────────────────────────────────
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export LANG=en_US.UTF-8

# ── History ─────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY

# ── Completion: once per day, skip compaudit ─────────────────
autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-${ZSH_VERSION}"
if [[ -f "$ZSH_COMPDUMP" && $(find "$ZSH_COMPDUMP" -mmin -1440 2>/dev/null) ]]; then
    compinit -C -u -d "$ZSH_COMPDUMP"
else
    compinit -u -d "$ZSH_COMPDUMP" && touch "$ZSH_COMPDUMP"
fi
[[ ! -f "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc" ]] \
    && zcompile "$ZSH_COMPDUMP" &!

# ── Colors (pure zsh, no OMZ needed) ────────────────────────
autoload -Uz colors && colors

# ── Git prompt (pure zsh, replicates OMZ git_prompt_info) ────
# Shows: [branch]  if dirty,  [branch] if clean
_git_prompt_info() {
    local ref
    ref=$(git symbolic-ref HEAD 2>/dev/null) || return
    local branch="${ref#refs/heads/}"

    # Dirty check
    if git diff --quiet --ignore-submodules HEAD 2>/dev/null; then
        # Clean
        echo "%{$fg[green]%}[%{$fg[yellow]%}${branch}%{$fg[green]%}]%{$reset_color%}"
    else
        # Dirty
        echo "%{$fg[green]%}[%{$fg[yellow]%}${branch}%{$fg[green]%}] %{$fg[yellow]%}⚡ %{$reset_color%}"
    fi
}

# ── Prompt (exact replica of your archcraft-dwm theme) ───────
setopt PROMPT_SUBST
PROMPT='%{$fg_bold[red]%}>%{$fg_bold[cyan]%}>%{$fg_bold[yellow]%}> %{$fg_bold[cyan]%}   %c %{$fg_bold[yellow]%}$(_git_prompt_info)%{$fg_bold[white]%} %% %{$reset_color%}'

# ── Zinit ────────────────────────────────────────────────────
ZINIT_HOME="$HOME/.local/share/zinit"
if [[ -f "$ZINIT_HOME/zinit.git/zinit.zsh" && ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
    command mv "$ZINIT_HOME/zinit.git/"* "$ZINIT_HOME/" 2>/dev/null
fi
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
    print -P "%F{33}Installing Zinit...%f"
    command mkdir -p "$ZINIT_HOME"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"
ZINIT[COMPILATION]=no

# ── Plugins — all async ──────────────────────────────────────
zinit ice depth=1 atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice depth=1
zinit light zsh-users/zsh-history-substring-search

zinit ice wait"0b" lucid depth=1 nocd
zinit light Aloxaf/fzf-tab

FAST_HIGHLIGHT_SKIP_WIDGETS+=(menu-search recent-paths)
zinit ice wait"0c" lucid depth=1 nocd
zinit light zdharma-continuum/fast-syntax-highlighting

# ── zoxide ───────────────────────────────────────────────────
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh 2>/dev/null)"
    alias cd='z'
    alias cdi='zi'
fi

# ── Completion styling ───────────────────────────────────────
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions'   format '[%d]'
zstyle ':completion:*'                list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*'                menu no
zstyle ':fzf-tab:complete:cd:*'       fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 $realpath'
zstyle ':fzf-tab:complete:ls:*'       fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 $realpath'
zstyle ':fzf-tab:*' fzf-flags         --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group      '<' '>'

# ── Navigation ───────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ..'
alias pdw='pwd'

# ── Listing ──────────────────────────────────────────────────
alias ls='eza -l  --color=always --icons --group-directories-first'
alias la='eza -al --color=always --icons --group-directories-first'
alias ll='eza -a  --color=always --icons --group-directories-first'
alias lt='eza -aT --color=always --icons --group-directories-first --level=2'
alias ltt='eza -aT --color=always --icons --group-directories-first'
alias l='ls'
alias l.="eza -a --color=always --icons | grep '^\.' "
alias listdir="ls -d */ > list"

# ── Git ──────────────────────────────────────────────────────
alias gs="git status -sb"
alias ga="git add"
alias gaa="git add -A"
alias gcm="git commit -m"
alias gca="git commit --amend --no-edit"
alias gc="git clone"
alias gp="git push"
alias gpb="git push -u origin"
alias gl="git log --oneline --graph --decorate --all"
alias gd="git diff"
alias gds="git diff --staged"
alias gco="git checkout"
alias gsw="git switch"
alias gb="git branch"
alias gst="git stash"
alias gstp="git stash pop"
alias reposize="git count-objects -vH"

# ── Search ───────────────────────────────────────────────────
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias rg='rg --sort path'

# ── QOL ──────────────────────────────────────────────────────
alias please='fc -s'
alias sudolast='sudo $(fc -ln -1)'
alias mkcd='f() { mkdir -p "$1" && cd "$1"; }; f'
alias path='echo $PATH | tr ":" "\n"'
alias ports='ss -tulnp 2>/dev/null || netstat -tulnp'
alias myip='curl -s ifconfig.me'
alias clr='clear'
alias q='exit'
alias reload='exec zsh'
alias zshrc='${EDITOR:-nano} ~/.zshrc'

# ── Key bindings ─────────────────────────────────────────────
bindkey '^ '   autosuggest-accept
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^R'   history-incremental-search-backward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# ── Autosuggestion tuning ────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# zprof

[[ -d /d ]] && builtin cd /d
