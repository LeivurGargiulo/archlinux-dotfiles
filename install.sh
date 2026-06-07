#!/bin/bash
# =============================================================================
# dotfiles/install.sh — leivur
# Crea symlinks desde el repo a las rutas correctas del sistema
# =============================================================================

set -e

DOTFILES="$HOME/dotfiles"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }
title() { echo -e "\n${BLUE}━━━ $1 ━━━${NC}"; }

echo ""
echo -e "${BLUE}"
echo "  ██╗     ███████╗██╗██╗   ██╗██╗   ██╗██████╗ "
echo "  ██║     ██╔════╝██║██║   ██║██║   ██║██╔══██╗"
echo "  ██║     █████╗  ██║██║   ██║██║   ██║██████╔╝"
echo "  ██║     ██╔══╝  ██║╚██╗ ██╔╝██║   ██║██╔══██╗"
echo "  ███████╗███████╗██║ ╚████╔╝ ╚██████╔╝██║  ██║"
echo "  ╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═════╝ ╚═╝  ╚═╝"
echo -e "${NC}"
echo "  dotfiles installer"
echo ""

# Verificar que estamos en el lugar correcto
[ -d "$DOTFILES" ] || error "No encontré ~/dotfiles. Cloná el repo primero:\n  git clone https://github.com/leivur/dotfiles ~/dotfiles"

# -----------------------------------------------------------------------------
# Crear directorios
# -----------------------------------------------------------------------------
title "Creando directorios"
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/kitty
mkdir -p ~/Pictures
info "Directorios listos"

# -----------------------------------------------------------------------------
# Función symlink segura (hace backup si ya existe)
# -----------------------------------------------------------------------------
link() {
    local src="$1"
    local dst="$2"

    if [ ! -f "$src" ]; then
        warn "No encontré: $src — saltando"
        return
    fi

    # Si ya existe y NO es un symlink → backup
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        warn "Backup: $(basename $dst) → $(basename $dst).backup"
        mv "$dst" "$dst.backup"
    fi

    ln -sf "$src" "$dst"
    info "$(basename $dst)"
}

# -----------------------------------------------------------------------------
# Symlinks
# -----------------------------------------------------------------------------
title "Creando symlinks"

link "$DOTFILES/hypr/hyprland.conf"  "$HOME/.config/hypr/hyprland.conf"
link "$DOTFILES/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
link "$DOTFILES/waybar/style.css"    "$HOME/.config/waybar/style.css"
link "$DOTFILES/kitty/kitty.conf"    "$HOME/.config/kitty/kitty.conf"
link "$DOTFILES/zsh/.zshrc"          "$HOME/.zshrc"

# -----------------------------------------------------------------------------
# Listo
# -----------------------------------------------------------------------------
echo ""
echo -e "${GREEN}┌─────────────────────────────────────────┐${NC}"
echo -e "${GREEN}│  ¡Dotfiles instalados correctamente!    │${NC}"
echo -e "${GREEN}└─────────────────────────────────────────┘${NC}"
echo ""
echo "  Próximos pasos:"
echo "  1. source ~/.zshrc"
echo "  2. start-hyprland"
echo ""
