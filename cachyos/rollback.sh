#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  rollback.sh — revierte SOLO lo estético (configs)           ║
# ║  No desinstala programas. Restaura backups donde existan y    ║
# ║  deja cada app en su default (HyDE / default del programa).   ║
# ╚══════════════════════════════════════════════════════════════╝

set -uo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; RESET='\033[0m'
ok()   { echo -e "  ${GREEN}✓${RESET} $1"; }
info() { echo -e "  ${BLUE}→${RESET} $1"; }
warn() { echo -e "  ${YELLOW}⚠${RESET} $1"; }
title(){ echo -e "\n${BLUE}── $1 ──${RESET}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ "$EUID" -eq 0 ]] && { echo "No lo corras como root."; exit 1; }

# restore <dst>: quita nuestro symlink y, si hay backup, lo restaura.
# Si no había original (no hay .bak), queda sin archivo → app usa su default.
restore() {
    local dst="$1" bak
    if [[ -L "$dst" ]]; then
        # Solo tocamos symlinks que apuntan a este repo
        if [[ "$(readlink -f "$dst")" == "$SCRIPT_DIR"/* ]]; then
            rm -f "$dst"; ok "quitado symlink: $dst"
        else
            warn "$dst es symlink pero NO apunta a este repo; lo dejo"
            return 0
        fi
    fi
    bak="$(ls -dt "${dst}".bak.* 2>/dev/null | head -1 || true)"
    if [[ -n "${bak:-}" && -e "$bak" ]]; then
        mv "$bak" "$dst"; ok "restaurado backup → $dst"
    fi
}

# ─── 1. HYPRLAND / TERMINAL / SHELL ────────────────────────────
title "1. Configs de Hyprland y terminal"
restore "$HOME/.config/hypr/userprefs.conf"
restore "$HOME/.config/kitty/kitty.conf"
restore "$HOME/.config/starship.toml"
restore "$HOME/.config/tmux/tmux.conf"
restore "$HOME/.tmux.conf"
restore "$HOME/.config/zsh/user.zsh"
restore "$HOME/.config/fastfetch/config.jsonc"
restore "$HOME/.config/cava/config"

# ─── 2. EXTRAS (nvim / yazi / atuin / btop) ────────────────────
title "2. Extras"
restore "$HOME/.config/nvim/lua/plugins/transparent.lua"
restore "$HOME/.config/yazi/theme.toml"
restore "$HOME/.config/atuin/config.toml"
restore "$HOME/.config/btop/themes/monochrome.theme"

# btop: volver al tema Default
BTOP_CONF="$HOME/.config/btop/btop.conf"
if [[ -f "$BTOP_CONF" ]] && grep -q '^color_theme' "$BTOP_CONF"; then
    sed -i 's|^color_theme.*|color_theme = "Default"|' "$BTOP_CONF"
    ok "btop volvió al tema Default"
fi

# ─── 3. ENGANCHES EN ARCHIVOS DEL USUARIO ──────────────────────
title "3. Quitar enganches en ~/.zshrc, git y firefox"

# 3.1 ~/.zshrc: sacar la línea que sourcea user.zsh (y su comentario)
ZSHRC="$HOME/.zshrc"
if [[ -f "$ZSHRC" ]] && grep -q 'user.zsh' "$ZSHRC"; then
    sed -i '/# leivur custom aliases\/funciones/d; /\.config\/zsh\/user\.zsh/d' "$ZSHRC"
    ok "quitado el source de user.zsh en ~/.zshrc"
fi

# 3.2 git-delta: sacar el include de nuestro gitconfig
if git config --global --get-all include.path 2>/dev/null | grep -q "cachyos/ricing/git/delta.gitconfig"; then
    git config --global --unset-all include.path '.*cachyos/ricing/git/delta\.gitconfig' 2>/dev/null \
        && ok "quitado el include de delta en ~/.gitconfig" \
        || warn "no pude quitar el include de delta; revisá ~/.gitconfig a mano"
fi

# 3.3 Firefox: quitar userChrome y los prefs que agregamos
FF_PROFILE="$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name '*.default-release' 2>/dev/null | head -1)"
if [[ -n "$FF_PROFILE" ]]; then
    [[ -L "$FF_PROFILE/chrome/userChrome.css" ]] && rm -f "$FF_PROFILE/chrome/userChrome.css" && ok "quitado userChrome.css"
    if [[ -f "$FF_PROFILE/user.js" ]]; then
        sed -i '/legacyUserProfileCustomizations/d; /svg.context-properties.content.enabled/d' "$FF_PROFILE/user.js"
        ok "quitados los prefs de userChrome en user.js (reiniciá Firefox)"
    fi
fi

# ─── 4. SPOTIFY (Spicetify) → vanilla ──────────────────────────
title "4. Spotify (Spicetify)"
if command -v spicetify &>/dev/null; then
    spicetify restore 2>/dev/null && ok "Spotify restaurado a vanilla" || warn "spicetify restore falló; corré 'spicetify restore' a mano"
else
    info "spicetify no está; nada que revertir"
fi

# ─── CIERRE ────────────────────────────────────────────────────
title "Listo"
echo -e "${GREEN}Rollback estético completo. Los programas siguen instalados.${RESET}"
echo "Para aplicar todo:"
echo "  • Hyprland:  SUPER+SHIFT+R  (o relogueá)"
echo "  • Discord:   en Vesktop, sacá el tema VenTrans y la transparencia a mano"
echo "  • Firefox / Vesktop / Spotify: reinicialos"
echo ""
echo -e "${YELLOW}Nota:${RESET} esto deja Hyprland/kitty/etc. en el default de HyDE."
