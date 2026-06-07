#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  install.sh — leivur @ gamdias                              ║
# ║  Symlinks seguros para todos los dotfiles                   ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

# ─── COLORES ───────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

log_title() { echo -e "\n${BLUE}${BOLD}── $1 ──${RESET}"; }
log_ok()    { echo -e "  ${GREEN}✓${RESET}  $1"; }
log_warn()  { echo -e "  ${YELLOW}⚠${RESET}  $1"; }
log_info()  { echo -e "  ${BLUE}→${RESET}  $1"; }
log_skip()  { echo -e "  ${YELLOW}↷${RESET}  $1 (ya era symlink, skip)"; }

# ─── VERIFICAR DOTFILES DIR ────────────────────────────────────
DOTFILES_DIR="$HOME/dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${RED}Error: $DOTFILES_DIR no existe.${RESET}"
    echo "Clona el repo primero: git clone https://github.com/leivur/dotfiles.git ~/dotfiles"
    exit 1
fi

log_info "Dotfiles en: $DOTFILES_DIR"
log_info "Usuario: $USER | Home: $HOME"

# ─── FUNCIÓN LINK ──────────────────────────────────────────────
# link <source_in_dotfiles> <target_symlink>
link() {
    local src="$DOTFILES_DIR/$1"
    local dst="$2"

    # Verificar que el source existe
    if [[ ! -e "$src" ]]; then
        log_warn "Source no encontrado: $src — skipping"
        return 0
    fi

    # Crear directorio padre si no existe
    local dst_dir
    dst_dir="$(dirname "$dst")"
    if [[ ! -d "$dst_dir" ]]; then
        mkdir -p "$dst_dir"
        log_info "Creado directorio: $dst_dir"
    fi

    # Si ya es symlink apuntando al mismo sitio, skip
    if [[ -L "$dst" ]] && [[ "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
        log_skip "$dst"
        return 0
    fi

    # Si existe (no symlink), renombrar a .bak
    if [[ -e "$dst" ]] && [[ ! -L "$dst" ]]; then
        local bak="${dst}.bak.$(date +%Y%m%d_%H%M%S)"
        mv "$dst" "$bak"
        log_warn "Backup: $dst → $bak"
    fi

    # Si era symlink roto o diferente, eliminar
    if [[ -L "$dst" ]]; then
        rm -f "$dst"
    fi

    # Crear symlink
    ln -sf "$src" "$dst"
    log_ok "$dst → $src"
}

# ─── CREAR DIRECTORIOS BASE ────────────────────────────────────
log_title "Creando directorios de configuración"

dirs=(
    "$HOME/.config/hypr"
    "$HOME/.config/waybar"
    "$HOME/.config/kitty"
    "$HOME/.config/tmux"
    "$HOME/.config/swaync"
    "$HOME/.config/starship"
    "$HOME/.config/yazi"
    "$HOME/.config/wofi"
    "$HOME/Pictures/Wallpapers"
    "$HOME/Pictures/Screenshots"
    "$HOME/Projects"
    "$HOME/Documents"
    "$HOME/Downloads"
    "$HOME/.local/bin"
    "$HOME/.local/share/applications"
    "$HOME/.cache"
    "$HOME/.zsh_cache"
)

for d in "${dirs[@]}"; do
    if [[ ! -d "$d" ]]; then
        mkdir -p "$d"
        log_ok "Creado: $d"
    fi
done

# ─── HYPRLAND ──────────────────────────────────────────────────
log_title "Hyprland"
link "hypr/hyprland.conf"   "$HOME/.config/hypr/hyprland.conf"
link "hyprlock/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
link "hypridle/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"

# ─── WAYBAR ────────────────────────────────────────────────────
log_title "Waybar"
link "waybar/config.jsonc"  "$HOME/.config/waybar/config.jsonc"
link "waybar/style.css"     "$HOME/.config/waybar/style.css"

# ─── KITTY ─────────────────────────────────────────────────────
log_title "Kitty"
link "kitty/kitty.conf"     "$HOME/.config/kitty/kitty.conf"

# ─── TMUX ──────────────────────────────────────────────────────
log_title "tmux"
link "tmux/tmux.conf"       "$HOME/.config/tmux/tmux.conf"
link "tmux/tmux.conf"       "$HOME/.tmux.conf"

# ─── SWAYNC ────────────────────────────────────────────────────
log_title "swaync"
link "swaync/config.json"   "$HOME/.config/swaync/config.json"
link "swaync/style.css"     "$HOME/.config/swaync/style.css"

# ─── STARSHIP ──────────────────────────────────────────────────
log_title "Starship"
link "starship/starship.toml" "$HOME/.config/starship.toml"

# ─── ZSH ───────────────────────────────────────────────────────
log_title "Zsh"
link "zsh/.zshrc"           "$HOME/.zshrc"

# ─── FINALIZACIÓN ──────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║  ✓ Dotfiles instalados correctamente     ║${RESET}"
echo -e "${GREEN}${BOLD}╠══════════════════════════════════════════╣${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}  Reiniciá Hyprland o hacé logout/login  ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}  para aplicar todos los cambios.        ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════╝${RESET}"
echo ""
