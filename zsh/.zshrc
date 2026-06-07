# ╔══════════════════════════════════════════════════════════════╗
# ║  .zshrc — leivur @ gamdias                                  ║
# ║  zsh · starship · eza · bat · fzf · yazi                    ║
# ╚══════════════════════════════════════════════════════════════╝

# ─── PERFORMANCE: Skip if non-interactive ──────────────────────
[[ $- != *i* ]] && return

# ─── HISTORY ───────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY

# ─── OPTIONS ───────────────────────────────────────────────────
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CORRECT
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt GLOB_COMPLETE
setopt EXTENDED_GLOB
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS
setopt MULTIOS
setopt PROMPT_SUBST
setopt NO_FLOW_CONTROL

# ─── COMPLETIONS ───────────────────────────────────────────────
autoload -Uz compinit
compinit -d ~/.cache/.zcompdump

# Case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# Menu select
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/.zsh_compcache
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format '%F{white}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format '%F{white}-- %d --%f'
zstyle ':completion:*:messages' format '%F{gray}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{gray}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion::complete:*' gain-privileges 1

# ─── KEYBINDINGS ───────────────────────────────────────────────
bindkey -e  # emacs mode (for readline compat)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

# ─── ENVIRONMENT VARIABLES ─────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="firefox"
export TERMINAL="kitty"
export PAGER="less"
export LESS="-R --mouse"
export MANPAGER="nvim +Man!"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:$PATH"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
export BAT_THEME="base16"
export BAT_STYLE="numbers,changes,header"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

# Wayland
# OJO: NO hardcodear WAYLAND_DISPLAY. Lo setea el compositor (Hyprland).
# Si se fuerza acá, el guard del autostart de abajo nunca dispara.
export QT_QPA_PLATFORM="wayland;xcb"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND="wayland,x11"
export MOZ_ENABLE_WAYLAND=1
export _JAVA_AWT_WM_NONREPARENTING=1

# ─── FZF ───────────────────────────────────────────────────────
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="
  --color=bg:#0a0a0a,bg+:#1a1a1a
  --color=fg:#aaaaaa,fg+:#e8e8e8
  --color=hl:#888888,hl+:#ffffff
  --color=border:#222222,separator:#333333
  --color=header:#555555,info:#444444,prompt:#888888
  --color=pointer:#ffffff,marker:#ffffff,spinner:#666666
  --color=preview-bg:#0a0a0a,preview-border:#222222
  --border=rounded
  --prompt='  '
  --pointer='▶'
  --marker='◆'
  --height=40%
  --layout=reverse
  --preview-window=right:50%:wrap
"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:100 {}' --preview-window=right:50%:wrap"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {}'"

# Load fzf keybindings if available
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]]   && source /usr/share/fzf/completion.zsh

# ─── PLUGINS ───────────────────────────────────────────────────
# zsh-autosuggestions
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#444444"
    ZSH_AUTOSUGGEST_USE_ASYNC=true
    bindkey '^ ' autosuggest-accept
    bindkey '^[[Z' autosuggest-accept
fi

# zsh-syntax-highlighting (load LAST)
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
    ZSH_HIGHLIGHT_STYLES[default]='fg=#aaaaaa'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#666666'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cccccc,bold'
    ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#aaaaaa,underline'
    ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#aaaaaa,underline'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=#aaaaaa,underline'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#888888'
    ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#aaaaaa,underline'
    ZSH_HIGHLIGHT_STYLES[path]='fg=#dddddd'
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#888888'
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=#aaaaaa'
    ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#aaaaaa'
    ZSH_HIGHLIGHT_STYLES[command-substitution]='none'
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#888888'
    ZSH_HIGHLIGHT_STYLES[process-substitution]='none'
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#888888'
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#aaaaaa'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#aaaaaa'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#cccccc'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#cccccc'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#cccccc'
    ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#cccccc'
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#dddddd'
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#dddddd'
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#dddddd'
    ZSH_HIGHLIGHT_STYLES[assign]='none'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=#888888'
    ZSH_HIGHLIGHT_STYLES[comment]='fg=#444444'
    ZSH_HIGHLIGHT_STYLES[named-fd]='none'
    ZSH_HIGHLIGHT_STYLES[numeric-fd]='none'
    ZSH_HIGHLIGHT_STYLES[arg0]='fg=#ffffff'
    ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=#888888,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#aaaaaa,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#888888,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#666666,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=#555555,bold'
fi

# ─── ALIASES: FILE SYSTEM ──────────────────────────────────────
alias ls="eza --icons --group-directories-first --color=always"
alias ll="eza -lah --icons --group-directories-first --color=always --git"
alias lt="eza --tree --level=2 --icons --color=always"
alias la="eza -a --icons --group-directories-first --color=always"
alias cat="bat --color=always"
alias less="bat --paging=always"
alias grep="grep --color=auto"
alias diff="diff --color=auto"

# Safer file ops
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Iv"
alias mkdir="mkdir -pv"

# Disk / system
alias df="df -h"
alias du="du -h"
alias free="free -h"
alias top="btop"
alias htop="btop"
alias ps="ps auxf"

# ─── ALIASES: PACMAN / AUR ─────────────────────────────────────
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias remove="sudo pacman -Rns"
alias search="pacman -Ss"
alias sinfo="pacman -Si"
alias lspkg="pacman -Q"
alias cleanup="sudo pacman -Rns \$(pacman -Qtdq 2>/dev/null) 2>/dev/null; sudo pacman -Sc --noconfirm"
alias mirrors="sudo reflector --country Argentina,Brazil,Chile --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"

# yay (AUR helper)
alias yayi="yay -S"
alias yayu="yay -Syu"
alias yays="yay -Ss"
alias yayr="yay -Rns"

# ─── ALIASES: GIT ──────────────────────────────────────────────
alias g="git"
alias gs="git status -sb"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit -m"
alias gca="git commit --amend"
alias gcane="git commit --amend --no-edit"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpo="git push origin"
alias gl="git log --oneline --graph --decorate -15"
alias gll="git log --oneline --graph --decorate --all"
alias gd="git diff"
alias gds="git diff --staged"
alias gb="git branch -vv"
alias gba="git branch -a"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gst="git stash"
alias gstp="git stash pop"
alias grb="git rebase"
alias grbi="git rebase -i"
alias gfetch="git fetch --all --prune"
alias gpull="git pull --rebase"
alias gclone="git clone"
alias greset="git reset --hard HEAD"
alias gclean="git clean -fd"

# ─── ALIASES: DEV ──────────────────────────────────────────────
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias code="code --ozone-platform=wayland"
alias py="python"
alias pip="pip"
alias dc="docker compose"
alias dps="docker ps"
alias dex="docker exec -it"

# ─── ALIASES: HYPRLAND ─────────────────────────────────────────
alias hreload="hyprctl reload && notify-send 'Hyprland' 'Configuración recargada'"
alias hlogs="journalctl -xe -u hyprland --no-pager | tail -50"
alias wlogs="journalctl -xe _SYSTEMD_UNIT=greetd.service --no-pager | tail -30"
alias sysinfo="fastfetch"
alias wallrandom="swww img \$(ls ~/Pictures/Wallpapers/*.{jpg,jpeg,png,gif,webp} 2>/dev/null | shuf -n1) --transition-type wipe --transition-angle 30 --transition-duration 1.5"
alias lockscreen="loginctl lock-session"

# ─── ALIASES: DIRECTORIES ──────────────────────────────────────
alias dots="cd ~/archlinux-dotfiles"
alias conf="cd ~/.config"
alias proj="cd ~/Projects"
alias dl="cd ~/Downloads"

# ─── ALIASES: TOOLS ────────────────────────────────────────────
alias f="y"              # yazi via function below
alias t="tmux"
alias ta="tmux attach -t"
alias tls="tmux list-sessions"
alias tnew="tmux new -s"

# fzf + bat preview
alias ff='fzf --preview "bat --color=always --style=numbers {}" --preview-window=right:50%:wrap'

# rg + fzf
alias rgf='rg --color=always --line-number --no-heading --smart-case "" | fzf --ansi --delimiter ":" --nth=3.. --preview "bat --color=always --style=numbers --highlight-line {2} {1}" --preview-window="right,50%,+{2}+3/3"'

# ─── FUNCTIONS ─────────────────────────────────────────────────

# Extract any archive
extract() {
    if [[ -z "$1" ]]; then
        echo "Uso: extract <archivo>"
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "'$1' no existe"
        return 1
    fi
    case "$1" in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.tar.xz)    tar xJf "$1"     ;;
        *.tar.zst)   tar --zstd -xf "$1" ;;
        *.tar)       tar xf "$1"      ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.zip)       unzip "$1"       ;;
        *.7z)        7z x "$1"        ;;
        *.rar)       unrar x "$1"     ;;
        *.Z)         uncompress "$1"  ;;
        *.xz)        unxz "$1"        ;;
        *.zst)       unzstd "$1"      ;;
        *)           echo "No sé cómo extraer '$1'" ;;
    esac
}

# mkdir + cd
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Search process by name
psgrep() {
    ps auxf | grep -v grep | grep -i "$1"
}

# Get public IP
myip() {
    curl -s https://ipinfo.io/ip && echo
}

# Quick weather
weather() {
    local city="${1:-Buenos Aires}"
    curl -s "wttr.in/${city// /+}?format=3"
}

# Backup file
bak() {
    cp -v "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"
}

# yazi — cd on exit
y() {
    local tmp
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if [[ -f "$tmp" ]]; then
        local cwd
        cwd="$(cat "$tmp")"
        rm -f "$tmp"
        [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd "$cwd"
    fi
}

# Quick HTTP server
serve() {
    local port="${1:-8000}"
    python -m http.server "$port"
}

# Find file by name
ff_find() {
    fd --hidden --follow --exclude .git "$1" "${2:-.}"
}

# Create simple git repo
ginit() {
    git init
    git add -A
    git commit -m "init: initial commit"
}

# ─── STARSHIP INIT ─────────────────────────────────────────────
eval "$(starship init zsh)"

# ─── ZOXIDE (smart cd) ─────────────────────────────────────────
[[ $(command -v zoxide) ]] && eval "$(zoxide init zsh --cmd cd)"

# ─── AUTOSTART HYPRLAND ────────────────────────────────────────
if [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$XDG_VTNR" = "1" ]]; then
    exec Hyprland
fi
