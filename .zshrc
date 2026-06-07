# =============================================================================
# .zshrc — leivur
# =============================================================================

# Historial
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias ls='eza --icons'
alias ll='eza -la --icons --git'
alias lt='eza --tree --icons --level=2'
alias cat='bat --style=auto'
alias grep='grep --color=auto'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -pv'

# Pacman / yay
alias update='sudo pacman -Syu && yay -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'   # Eliminar huérfanos

# Git
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# Hyprland
alias hreload='hyprctl reload'
alias hlogs='cat ~/.cache/hyprland/hyprland.log | tail -50'

# Directorios frecuentes
alias dots='cd ~/dotfiles'
alias conf='cd ~/.config'

# -----------------------------------------------------------------------------
# Plugins
# -----------------------------------------------------------------------------
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions: aceptar con →
bindkey '→' autosuggest-accept
bindkey '^[[C' autosuggest-accept

# -----------------------------------------------------------------------------
# Prompt simple (se puede reemplazar con starship o p10k después)
# -----------------------------------------------------------------------------
autoload -U colors && colors
setopt PROMPT_SUBST

PROMPT='%F{#cba6f7}%n%f%F{#6c7086}@%f%F{#89b4fa}%m%f %F{#a6e3a1}%~%f %(?.%F{#a6e3a1}❯%f.%F{#f38ba8}❯%f) '

# -----------------------------------------------------------------------------
# Fastfetch al abrir terminal
# (comentalo si te cansa verlo siempre)
# -----------------------------------------------------------------------------
fastfetch

# -----------------------------------------------------------------------------
# Arrancar Hyprland automáticamente al login en tty1
# -----------------------------------------------------------------------------
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
    exec Hyprland
fi
