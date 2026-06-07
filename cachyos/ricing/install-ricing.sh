#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  install-ricing.sh — add-ons dark glossy · white             ║
# ║  Spotify · Discord · Firefox · Terminal · Extras (todo auto)  ║
# ║  Correr como tu usuario (no root), después de apply.sh.       ║
# ╚══════════════════════════════════════════════════════════════╝

set -uo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RESET='\033[0m'
ok()   { echo -e "  ${GREEN}✓${RESET} $1"; }
info() { echo -e "  ${BLUE}→${RESET} $1"; }
warn() { echo -e "  ${YELLOW}⚠${RESET} $1"; }
err()  { echo -e "  ${RED}✗${RESET} $1" >&2; }
title(){ echo -e "\n${BLUE}── $1 ──${RESET}"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ "$EUID" -eq 0 ]] && { err "No lo corras como root."; exit 1; }

# Helper AUR: CachyOS trae paru; si no, probamos yay.
AUR=""
command -v paru &>/dev/null && AUR="paru"
[[ -z "$AUR" ]] && command -v yay &>/dev/null && AUR="yay"
aur_install() {
    [[ -z "$AUR" ]] && { warn "Sin helper AUR (paru/yay); salteo: $*"; return 0; }
    "$AUR" -S --noconfirm --needed "$@" || warn "Falló AUR: $*"
}
pac_install() { sudo pacman -S --noconfirm --needed "$@" || warn "Falló pacman: $*"; }

link() {  # link <src-rel> <dst-abs>
    local src="$SCRIPT_DIR/$1" dst="$2"
    [[ ! -e "$src" ]] && { warn "No existe $src"; return 0; }
    mkdir -p "$(dirname "$dst")"
    [[ -e "$dst" && ! -L "$dst" ]] && mv "$dst" "${dst}.bak.$(date +%Y%m%d_%H%M%S)"
    ln -sf "$src" "$dst" && ok "$dst → $src"
}

# ─── 1. TERMINAL EYECANDY ──────────────────────────────────────
title "1. Terminal: fastfetch + cava"
pac_install cava fastfetch
link "fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
link "cava/config"            "$HOME/.config/cava/config"
ok "CAVA se abre con 'cava' (visualizer monocromático)."

# ─── 2. SPOTIFY (Spicetify) ────────────────────────────────────
title "2. Spotify: Spicetify + Marketplace"
if ! command -v spotify &>/dev/null && [[ ! -d /opt/spotify ]]; then
    info "Instalando Spotify (AUR)..."; aur_install spotify
fi
aur_install spicetify-cli
if command -v spicetify &>/dev/null; then
    if [[ -d /opt/spotify ]]; then
        sudo chmod a+wr /opt/spotify 2>/dev/null || true
        sudo chmod a+wr -R /opt/spotify/Apps 2>/dev/null || true
    fi
    spicetify backup apply 2>/dev/null && ok "Spicetify aplicado"
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh 2>/dev/null \
        && ok "Marketplace instalado" || warn "Marketplace no se instaló (hacelo manual)"
    info "En Spotify → Marketplace → instalá 'Bloom' y elegí esquema 'darkmono'."
else
    warn "spicetify no quedó instalado; revisá el AUR."
fi

# ─── 3. DISCORD (Vesktop) ──────────────────────────────────────
title "3. Discord: Vesktop (Vencord integrado)"
aur_install vesktop-bin
ok "Tema glass: Vesktop → Settings → Vencord → Themes → Online Themes:"
echo "      https://raw.githubusercontent.com/galaxine-senpai/ventrans/main/VenTrans.css"
ok "Y activá: Settings → Vencord → Enable Window Transparency (reiniciar Vesktop)."

# ─── 4. FIREFOX (userChrome glossy) ────────────────────────────
title "4. Firefox: userChrome glossy + compacto"
FF_PROFILE="$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name '*.default-release' 2>/dev/null | head -1)"
if [[ -n "$FF_PROFILE" ]]; then
    mkdir -p "$FF_PROFILE/chrome"
    ln -sf "$SCRIPT_DIR/firefox/userChrome.css" "$FF_PROFILE/chrome/userChrome.css"
    if ! grep -qs "legacyUserProfileCustomizations" "$FF_PROFILE/user.js" 2>/dev/null; then
        echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$FF_PROFILE/user.js"
        echo 'user_pref("svg.context-properties.content.enabled", true);' >> "$FF_PROFILE/user.js"
    fi
    ok "userChrome enlazado en $FF_PROFILE/chrome/ — reiniciá Firefox."
else
    warn "No encontré perfil default-release. Abrí Firefox una vez y recorré esto"
    warn "(o seguí firefox/README.md)."
fi

# ─── 5. EXTRAS (todo monocromático, automatizado) ──────────────
title "5. Extras: nvim · yazi · delta · atuin · btop · eza"
pac_install git-delta atuin yazi eza btop

# 5.1 Neovim transparente (LazyVim auto-carga lua/plugins/*.lua)
if [[ -d "$HOME/.config/nvim/lua/plugins" ]]; then
    link "nvim/transparent.lua" "$HOME/.config/nvim/lua/plugins/transparent.lua"
else
    warn "No veo ~/.config/nvim/lua/plugins (¿LazyVim instalado?). Salteo nvim."
fi

# 5.2 yazi — tema monocromático
link "yazi/theme.toml" "$HOME/.config/yazi/theme.toml"

# 5.3 atuin — historial con TUI oscura compacta
link "atuin/config.toml" "$HOME/.config/atuin/config.toml"
command -v atuin &>/dev/null && atuin import auto 2>/dev/null || true

# 5.4 git-delta — diffs monocromáticos (include en ~/.gitconfig, idempotente)
if command -v delta &>/dev/null; then
    git config --global include.path "$SCRIPT_DIR/git/delta.gitconfig"
    ok "delta enganchado en ~/.gitconfig (include.path)"
fi

# 5.5 btop — tema monocromático
link "btop/monochrome.theme" "$HOME/.config/btop/themes/monochrome.theme"
BTOP_CONF="$HOME/.config/btop/btop.conf"
mkdir -p "$(dirname "$BTOP_CONF")"
if [[ -f "$BTOP_CONF" ]]; then
    if grep -q '^color_theme' "$BTOP_CONF"; then
        sed -i 's|^color_theme.*|color_theme = "monochrome"|' "$BTOP_CONF"
    else
        echo 'color_theme = "monochrome"' >> "$BTOP_CONF"
    fi
else
    printf 'color_theme = "monochrome"\ntheme_background = True\n' > "$BTOP_CONF"
fi
ok "btop usando tema monochrome"

echo -e "\n${GREEN}── Ricing dark glossy aplicado ──${RESET}"
echo -e "${YELLOW}Pasos manuales que quedan (2 clics c/u):${RESET}"
echo "  • Spotify:  Marketplace → Bloom (esquema darkmono)"
echo "  • Vesktop:  Online Theme VenTrans + Enable Window Transparency"
echo "  • Firefox:  reiniciar para tomar el userChrome"
echo "  • atuin:    abrí una shell nueva (ya está enganchado en user.zsh)"
