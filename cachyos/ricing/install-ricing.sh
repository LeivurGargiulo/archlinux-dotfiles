#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  install-ricing.sh — add-ons de ricing sobre HyDE/CachyOS     ║
# ║  Spotify (Spicetify) · Discord (Vesktop) · Firefox · Terminal ║
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
    [[ -z "$AUR" ]] && { warn "No hay helper AUR (paru/yay); salteo: $*"; return 0; }
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
title "1. Terminal: fastfetch + cava + color-scripts"
pac_install cava fastfetch
aur_install shell-color-scripts pokemon-colorscripts-git
link "fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
link "cava/config"            "$HOME/.config/cava/config"
ok "Tip: CAVA se abre con 'cava'. fastfetch usa el config nuevo."

# ─── 2. SPOTIFY (Spicetify) ────────────────────────────────────
title "2. Spotify: Spicetify + Marketplace"
if ! command -v spotify &>/dev/null && [[ ! -d /opt/spotify ]]; then
    info "Instalando Spotify (AUR)..."
    aur_install spotify
fi
aur_install spicetify-cli
if command -v spicetify &>/dev/null; then
    # Spotify (AUR) vive en /opt/spotify y necesita permisos de escritura.
    if [[ -d /opt/spotify ]]; then
        sudo chmod a+wr /opt/spotify 2>/dev/null || true
        sudo chmod a+wr -R /opt/spotify/Apps 2>/dev/null || true
    fi
    spicetify backup apply 2>/dev/null && ok "Spicetify aplicado"
    # Marketplace (para elegir Bloom/Comfy con 2 clics desde Spotify)
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh 2>/dev/null \
        && ok "Marketplace instalado" || warn "No se pudo instalar Marketplace (hacelo manual)"
    info "En Spotify → pestaña Marketplace → instalá 'Bloom' y elegí esquema 'darkmono'."
else
    warn "spicetify no quedó instalado; revisá el AUR."
fi

# ─── 3. DISCORD (Vesktop = Discord + Vencord) ──────────────────
title "3. Discord: Vesktop (con Vencord integrado)"
aur_install vesktop-bin
ok "Tema glass: Vesktop → Settings → Vencord → Themes → Online Themes, pegá:"
echo "      https://raw.githubusercontent.com/galaxine-senpai/ventrans/main/VenTrans.css"
ok "Y activá: Settings → Vencord → Enable Window Transparency (requiere reiniciar Vesktop)."

# ─── 4. FIREFOX (userChrome glossy) ────────────────────────────
title "4. Firefox: userChrome glossy + compacto"
FF_PROFILE="$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name '*.default-release' 2>/dev/null | head -1)"
if [[ -n "$FF_PROFILE" ]]; then
    mkdir -p "$FF_PROFILE/chrome"
    ln -sf "$SCRIPT_DIR/firefox/userChrome.css" "$FF_PROFILE/chrome/userChrome.css"
    # Habilitar userChrome vía user.js (idempotente)
    if ! grep -qs "legacyUserProfileCustomizations" "$FF_PROFILE/user.js" 2>/dev/null; then
        echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$FF_PROFILE/user.js"
        echo 'user_pref("svg.context-properties.content.enabled", true);' >> "$FF_PROFILE/user.js"
    fi
    ok "userChrome enlazado en $FF_PROFILE/chrome/ — reiniciá Firefox."
else
    warn "No encontré perfil default-release. Abrí Firefox una vez y volvé a correr esto,"
    warn "o seguí firefox/README.md para hacerlo a mano."
fi

echo -e "\n${GREEN}── Ricing add-ons listos ──${RESET}"
echo -e "${YELLOW}Resumen de pasos manuales:${RESET}"
echo "  • Spotify:  Marketplace → Bloom (esquema darkmono)"
echo "  • Vesktop:  Online Theme VenTrans + Enable Window Transparency"
echo "  • Firefox:  reiniciar para tomar el userChrome"
