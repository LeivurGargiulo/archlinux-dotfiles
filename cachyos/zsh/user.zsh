# ╔══════════════════════════════════════════════════════════════╗
# ║  user.zsh — aliases y funciones de leivur (sobre HyDE)        ║
# ╠══════════════════════════════════════════════════════════════╣
# ║  Solo aliases/funciones (aditivo). NO toca el prompt ni el    ║
# ║  setup de zsh de HyDE. Se carga vía: source ~/.config/zsh/    ║
# ║  user.zsh  (apply.sh lo engancha en tu ~/.zshrc).            ║
# ╚══════════════════════════════════════════════════════════════╝

# ─── FILE SYSTEM ───────────────────────────────────────────────
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

# ─── PACMAN / AUR (CachyOS: paru por defecto) ──────────────────
alias update="sudo pacman -Syu"
alias install="sudo pacman -S"
alias remove="sudo pacman -Rns"
alias search="pacman -Ss"
alias lspkg="pacman -Q"
alias cleanup="sudo pacman -Rns \$(pacman -Qtdq 2>/dev/null) 2>/dev/null; sudo pacman -Sc --noconfirm"
# CachyOS trae 'paru' como helper AUR (en vez de yay)
alias yayi="paru -S"
alias yayu="paru -Syu"
alias yays="paru -Ss"
alias yayr="paru -Rns"

# ─── GIT ───────────────────────────────────────────────────────
alias g="git"
alias gs="git status -sb"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit -m"
alias gca="git commit --amend"
alias gcane="git commit --amend --no-edit"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gl="git log --oneline --graph --decorate -15"
alias gll="git log --oneline --graph --decorate --all"
alias gd="git diff"
alias gds="git diff --staged"
alias gb="git branch -vv"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gst="git stash"
alias gstp="git stash pop"
alias gfetch="git fetch --all --prune"
alias gpull="git pull --rebase"

# ─── DEV ───────────────────────────────────────────────────────
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias code="code --ozone-platform=wayland"
alias dc="docker compose"
alias dps="docker ps"
alias dex="docker exec -it"

# ─── HYPRLAND / DESKTOP ────────────────────────────────────────
alias hreload="hyprctl reload && notify-send 'Hyprland' 'Config recargada'"
alias hlogs="cat ~/.local/share/hyprland/hyprland.log | tail -50"
alias sysinfo="fastfetch"
alias lockscreen="loginctl lock-session"

# ─── DIRECTORIES ───────────────────────────────────────────────
alias dots="cd ~/archlinux-dotfiles"
alias conf="cd ~/.config"
alias proj="cd ~/Projects"
alias dl="cd ~/Downloads"

# ─── TOOLS ─────────────────────────────────────────────────────
alias f="y"
alias t="tmux"
alias ta="tmux attach -t"
alias tls="tmux list-sessions"
alias tnew="tmux new -s"
alias ff='fzf --preview "bat --color=always --style=numbers {}" --preview-window=right:50%:wrap'

# ─── FUNCTIONS ─────────────────────────────────────────────────
# Extraer cualquier archivo
extract() {
    [[ -z "$1" ]] && { echo "Uso: extract <archivo>"; return 1; }
    [[ ! -f "$1" ]] && { echo "'$1' no existe"; return 1; }
    case "$1" in
        *.tar.bz2)   tar xjf "$1"        ;;
        *.tar.gz)    tar xzf "$1"        ;;
        *.tar.xz)    tar xJf "$1"        ;;
        *.tar.zst)   tar --zstd -xf "$1" ;;
        *.tar)       tar xf "$1"         ;;
        *.bz2)       bunzip2 "$1"        ;;
        *.gz)        gunzip "$1"         ;;
        *.zip)       unzip "$1"          ;;
        *.7z)        7z x "$1"           ;;
        *.rar)       unar "$1"           ;;
        *.xz)        unxz "$1"           ;;
        *.zst)       unzstd "$1"         ;;
        *)           echo "No sé cómo extraer '$1'" ;;
    esac
}

# mkdir + cd
mkcd() { mkdir -p "$1" && cd "$1"; }

# Buscar proceso por nombre
psgrep() { ps auxf | grep -v grep | grep -i "$1"; }

# IP pública
myip() { curl -s https://ipinfo.io/ip && echo; }

# Clima rápido
weather() { local c="${1:-Buenos Aires}"; curl -s "wttr.in/${c// /+}?format=3"; }

# Backup rápido de un archivo
bak() { cp -v "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"; }

# yazi — hace cd al salir
y() {
    local tmp; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if [[ -f "$tmp" ]]; then
        local cwd; cwd="$(cat "$tmp")"
        rm -f "$tmp"
        [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd "$cwd"
    fi
}

# ─── EZA — COLORES MONOCROMÁTICOS (dark glossy white) ──────────
# Gris para todo, blanco para directorios/ejecutables. Sin colores.
export EZA_COLORS="reset:\
di=1;38;5;255:\
ex=4;38;5;255:\
ln=38;5;245:\
fi=38;5;250:\
or=38;5;240:\
ur=38;5;250:uw=38;5;245:ux=38;5;255:ue=38;5;255:\
gr=38;5;245:gw=38;5;240:gx=38;5;250:\
tr=38;5;240:tw=38;5;235:tx=38;5;245:\
sn=38;5;250:sb=38;5;240:\
uu=38;5;250:un=38;5;240:\
da=38;5;243:\
xx=38;5;236"

# ─── ATUIN — historial (TUI oscura, sólo Ctrl-R) ───────────────
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi
