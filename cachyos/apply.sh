#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  apply.sh — aplica los overrides dark-glossy sobre HyDE       ║
# ║  Correr DESPUÉS de instalar HyDE. Como tu usuario (no root).  ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RESET='\033[0m'
ok()   { echo -e "  ${GREEN}✓${RESET} $1"; }
info() { echo -e "  ${BLUE}→${RESET} $1"; }
warn() { echo -e "  ${YELLOW}⚠${RESET} $1"; }
err()  { echo -e "  ${RED}✗${RESET} $1" >&2; }

# Carpeta de este repo (donde vive apply.sh)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── PRECONDICIONES ────────────────────────────────────────────
if [[ "$EUID" -eq 0 ]]; then err "No lo corras como root."; exit 1; fi
if [[ ! -d "$HOME/.config/hypr" ]]; then
    err "No encuentro ~/.config/hypr — ¿instalaste HyDE primero?"
    echo "    Ver la guía: $SCRIPT_DIR/README.md"
    exit 1
fi

# link <src> <dst> — symlink con backup si ya existe algo real
link() {
    local src="$SCRIPT_DIR/$1" dst="$2"
    [[ ! -e "$src" ]] && { warn "No existe $src, skip"; return 0; }
    mkdir -p "$(dirname "$dst")"
    if [[ -L "$dst" && "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
        ok "ya enlazado: $dst"; return 0
    fi
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        mv "$dst" "${dst}.bak.$(date +%Y%m%d_%H%M%S)"
        warn "backup: $dst → ${dst}.bak.*"
    fi
    [[ -L "$dst" ]] && rm -f "$dst"
    ln -sf "$src" "$dst"
    ok "$dst → $src"
}

echo -e "${BLUE}── Aplicando overrides dark-glossy sobre HyDE ──${RESET}"

# ─── HYPRLAND ──────────────────────────────────────────────────
# userprefs.conf lo carga HyDE al final → pisa sus defaults/tema.
link "hypr/userprefs.conf" "$HOME/.config/hypr/userprefs.conf"

# ─── TERMINAL / SHELL / MUX ────────────────────────────────────
# kitty.conf propio (monocromático fijo). OJO: reemplaza el de HyDE,
# así que kitty deja de seguir el tema dinámico de HyDE (es a propósito).
link "kitty/kitty.conf"     "$HOME/.config/kitty/kitty.conf"
link "starship/starship.toml" "$HOME/.config/starship.toml"
link "tmux/tmux.conf"       "$HOME/.config/tmux/tmux.conf"
link "tmux/tmux.conf"       "$HOME/.tmux.conf"
link "zsh/user.zsh"         "$HOME/.config/zsh/user.zsh"

# Enganchar user.zsh en ~/.zshrc (idempotente)
ZSHRC="$HOME/.zshrc"
HOOK='[ -f ~/.config/zsh/user.zsh ] && source ~/.config/zsh/user.zsh'
if [[ -f "$ZSHRC" ]] && ! grep -qF "user.zsh" "$ZSHRC"; then
    printf '\n# leivur custom aliases/funciones\n%s\n' "$HOOK" >> "$ZSHRC"
    ok "enganchado user.zsh en ~/.zshrc"
else
    ok "user.zsh ya está enganchado (o no hay ~/.zshrc todavía)"
fi

# ─── RELOAD ────────────────────────────────────────────────────
if command -v hyprctl &>/dev/null && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    hyprctl reload >/dev/null && ok "Hyprland recargado"
else
    info "Recargá con SUPER+SHIFT+R (o relogueá) para ver los cambios"
fi

echo -e "${GREEN}── Listo. Estilo dark-glossy aplicado sobre HyDE ──${RESET}"
