#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  post-install.sh — leivur @ gamdias                         ║
# ║  Ejecutar como usuario leivur (NO root) después del boot    ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

# ─── COLORES ───────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

log_title()   { echo -e "\n${BLUE}${BOLD}══ $1 ══${RESET}"; }
log_ok()      { echo -e "  ${GREEN}✓${RESET}  $1"; }
log_warn()    { echo -e "  ${YELLOW}⚠${RESET}  $1"; }
log_info()    { echo -e "  ${CYAN}→${RESET}  $1"; }
log_error()   { echo -e "  ${RED}✗${RESET}  $1" >&2; }

# ─── PRECONDICIONES ────────────────────────────────────────────
if [[ "$EUID" -eq 0 ]]; then
    log_error "No ejecutes este script como root. Usa tu usuario normal con sudo."
    exit 1
fi

log_info "Verificando conexión a internet..."
if ! ping -c1 -W3 archlinux.org &>/dev/null; then
    log_error "Sin conexión a internet. Conecta primero."
    exit 1
fi
log_ok "Conexión activa"

# ─── 1. ACTUALIZAR SISTEMA + KEYRING ───────────────────────────
log_title "1. Actualizar sistema"
sudo pacman -Sy --noconfirm archlinux-keyring
sudo pacman -Syu --noconfirm
log_ok "Sistema actualizado"

# ─── 2. SHELL ZSH ──────────────────────────────────────────────
log_title "2. Cambiar shell a zsh"
sudo chsh -s /usr/bin/zsh "$USER"
log_ok "Shell cambiada a zsh para $USER"

# ─── 3. DRIVERS AMD ────────────────────────────────────────────
log_title "3. Drivers AMD (open-source)"
sudo pacman -S --noconfirm --needed \
    mesa \
    lib32-mesa \
    vulkan-radeon \
    lib32-vulkan-radeon \
    xf86-video-amdgpu \
    libva-mesa-driver \
    lib32-libva-mesa-driver \
    mesa-vdpau \
    lib32-mesa-vdpau \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader
log_ok "Drivers AMD instalados"

# ─── 4. HYPRLAND ECOSYSTEM ─────────────────────────────────────
log_title "4. Hyprland y ecosistema Wayland"
sudo pacman -S --noconfirm --needed \
    hyprland \
    hyprlock \
    hypridle \
    hyprpicker \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    xdg-user-dirs \
    waybar \
    wofi \
    kitty \
    polkit-gnome \
    qt5-wayland \
    qt6-wayland \
    xorg-xwayland \
    xorg-xlsclients \
    nwg-look \
    grim \
    slurp \
    wl-clipboard \
    cliphist \
    swww \
    swaync \
    brightnessctl \
    playerctl \
    pavucontrol \
    network-manager-applet \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    pipewire-jack \
    wireplumber \
    pamixer
log_ok "Hyprland ecosystem instalado"

# ─── 5. FILE MANAGERS ──────────────────────────────────────────
log_title "5. File managers"
sudo pacman -S --noconfirm --needed \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    gvfs \
    gvfs-mtp \
    file-roller \
    yazi \
    ffmpegthumbnailer \
    unar \
    jq \
    poppler \
    fd \
    ripgrep \
    fzf \
    zoxide \
    imagemagick
log_ok "File managers instalados"

# ─── 6. FUENTES ────────────────────────────────────────────────
log_title "6. Fuentes"
sudo pacman -S --noconfirm --needed \
    noto-fonts \
    noto-fonts-emoji \
    noto-fonts-cjk \
    noto-fonts-extra \
    ttf-jetbrains-mono-nerd \
    ttf-inter \
    ttf-font-awesome \
    ttf-nerd-fonts-symbols \
    ttf-nerd-fonts-symbols-common \
    otf-font-awesome
log_ok "Fuentes instaladas"

# ─── 7. CLI TOOLS ──────────────────────────────────────────────
log_title "7. CLI tools"
sudo pacman -S --noconfirm --needed \
    tmux \
    starship \
    bat \
    eza \
    btop \
    fastfetch \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    unzip \
    zip \
    p7zip \
    tree \
    tokei \
    ncdu \
    duf \
    hyperfine \
    wget \
    curl \
    rsync \
    pigz \
    pv
log_ok "CLI tools instalados"

# ─── 8. DEV TOOLS ──────────────────────────────────────────────
log_title "8. Herramientas de desarrollo"
sudo pacman -S --noconfirm --needed \
    neovim \
    github-cli \
    docker \
    docker-compose \
    python \
    python-pip \
    python-pipx \
    nodejs \
    npm \
    rustup

# Docker setup
log_info "Habilitando Docker..."
sudo systemctl enable docker.service
sudo usermod -aG docker "$USER"
log_ok "Docker configurado (logout/login para aplicar grupo)"

# Rust stable
log_info "Instalando Rust stable..."
rustup default stable
log_ok "Rust instalado"

log_ok "Dev tools instalados"

# ─── 9. ESTUDIO ────────────────────────────────────────────────
log_title "9. Herramientas de estudio"
sudo pacman -S --noconfirm --needed \
    zathura \
    zathura-pdf-mupdf \
    zathura-djvu \
    zathura-ps \
    anki
log_ok "Herramientas de estudio instaladas"

# ─── 10. APPS GENERALES ────────────────────────────────────────
log_title "10. Aplicaciones generales"
sudo pacman -S --noconfirm --needed \
    firefox \
    vlc \
    gimp \
    obs-studio \
    discord \
    mpv \
    imv \
    libreoffice-fresh
log_ok "Aplicaciones generales instaladas"

# ─── 11. SERVICIOS ─────────────────────────────────────────────
log_title "11. Habilitando servicios"
sudo systemctl enable bluetooth.service
log_ok "Bluetooth habilitado"
sudo systemctl enable sshd.service
log_ok "SSH habilitado"
sudo systemctl enable reflector.timer
log_ok "Reflector habilitado"

# ─── 12. YAY (AUR helper) ──────────────────────────────────────
log_title "12. Instalando yay"
if ! command -v yay &>/dev/null; then
    log_info "Clonando yay..."
    tmpdir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    log_ok "yay instalado"
else
    log_ok "yay ya está instalado"
fi

# ─── 13. AUR PACKAGES ──────────────────────────────────────────
log_title "13. Paquetes AUR"
log_info "Instalando paquetes AUR (puede tardar)..."
yay -S --noconfirm --needed \
    visual-studio-code-bin \
    wlogout \
    hyprshot \
    spotify \
    lazygit \
    sd \
    choose-rust-git \
    procs
log_ok "Paquetes AUR instalados"

# LazyVim (nvim config)
if [[ ! -d "$HOME/.config/nvim/.git" ]]; then
    log_info "Instalando LazyVim..."
    [[ -d "$HOME/.config/nvim" ]] && mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%s)"
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    log_ok "LazyVim clonado en ~/.config/nvim"
else
    log_ok "LazyVim ya está configurado"
fi

# ─── 14. DOTFILES ──────────────────────────────────────────────
log_title "14. Dotfiles"
DOTFILES_DIR="$HOME/archlinux-dotfiles"
if [[ ! -d "$DOTFILES_DIR" ]]; then
    log_info "Clonando dotfiles..."
    git clone https://github.com/LeivurGargiulo/archlinux-dotfiles.git "$DOTFILES_DIR"
    log_ok "Dotfiles clonados"
else
    log_ok "Dotfiles ya están presentes (git pull)"
    git -C "$DOTFILES_DIR" pull --rebase
fi

log_info "Ejecutando install.sh..."
bash "$DOTFILES_DIR/install.sh"

# ─── 15. DIRECTORIOS ───────────────────────────────────────────
log_title "15. Creando directorios"
mkdir -p \
    "$HOME/Pictures/Wallpapers" \
    "$HOME/Pictures/Screenshots" \
    "$HOME/Projects" \
    "$HOME/Documents" \
    "$HOME/Downloads" \
    "$HOME/.local/bin" \
    "$HOME/.local/share/applications"
log_ok "Directorios creados"

# XDG user dirs
xdg-user-dirs-update

# ─── FINALIZACIÓN ──────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║  ¡Instalación completada!  leivur @ gamdias              ║${RESET}"
echo -e "${GREEN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}  Próximos pasos:                                        ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}  1. Reiniciar para aplicar cambios                      ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}  2. Agregar wallpaper en ~/Pictures/Wallpapers/         ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}  3. Abrir nvim para que LazyVim instale plugins          ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}  4. Logout/login para que el grupo docker tome efecto   ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}║${RESET}  5. Personalizar starship y zsh según preferencias      ${GREEN}${BOLD}║${RESET}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
echo ""
