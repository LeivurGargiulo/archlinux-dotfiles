# Reporte de instalación — `post-install.sh` + `install.sh`

Este documento describe **todo lo que hacen los scripts** de `archlinux-dotfiles`
y **todos los paquetes que instalan**. Pensado para ejecutarse en una instalación
limpia de Arch Linux (AMD + Hyprland/Wayland), como usuario normal (no root).

---

## Cómo funciona

Hay dos scripts con responsabilidades distintas:

| Script | Qué hace | Instala paquetes |
|--------|----------|:---:|
| `archinstall/post-install.sh` | Instala TODO el sistema (drivers, Hyprland, apps), habilita servicios, clona dotfiles y los enlaza. | ✅ Sí |
| `install.sh` | Solo crea **symlinks** de las configs del repo hacia `~/.config/…`. Lo llama `post-install.sh`, o se corre suelto. | ❌ No |

> **Importante:** correr solo `install.sh` **no instala nada** — únicamente enlaza
> configuraciones. El instalador real es `post-install.sh`.

### Robustez

- `post-install.sh` usa `set -euo pipefail`, pero las instalaciones de paquetes
  pasan por las funciones `pac()` (oficiales) y `aur()` (AUR), que **no abortan**
  el script si un paquete falla: reintentan paquete por paquete, registran los
  que fallaron en `FAILED_PKGS` y siguen.
- Al final hay una **verificación**: avisa si Hyprland no quedó instalado y lista
  los paquetes que fallaron, con cómo reintentarlos.

---

## Qué hace, paso a paso

| # | Sección | Acción |
|---|---------|--------|
| — | Precondiciones | Verifica que **no** se corre como root y que hay internet (`ping archlinux.org`). |
| 1 | Actualizar sistema | `pacman -Sy archlinux-keyring` + `pacman -Syu`. |
| 2 | Shell zsh | Instala `zsh` + plugins y cambia la shell del usuario a zsh (`chsh`). |
| 3 | Drivers AMD | Mesa + Vulkan radeon + VA-API (open source). |
| 4 | Hyprland / Wayland | Compositor, lock, idle, barra, lanzador, portales, audio, etc. |
| 5 | File managers | Thunar + Yazi y utilidades de archivos. |
| 6 | Fuentes | Noto, Nerd Fonts, Inter, Font Awesome. |
| 7 | CLI tools | tmux, starship y reemplazos modernos de coreutils. |
| 8 | Dev tools | Neovim, Docker, Python, Node, Rust. Habilita Docker y agrega el usuario al grupo. |
| 9 | Estudio | Zathura (PDF/DjVu/PS) y Anki. |
| 10 | Apps generales | Firefox, VLC, GIMP, OBS, Discord, mpv, LibreOffice, etc. |
| 11 | Servicios | Habilita `bluetooth`, `sshd`, `reflector.timer`. |
| 12 | yay | Instala el helper de AUR (clona y `makepkg -si`). |
| 13 | Paquetes AUR | VS Code, wlogout, hyprshot, Spotify, lazygit, etc. + LazyVim. |
| 14 | Dotfiles | Clona/actualiza el repo en `~/archlinux-dotfiles` y corre `install.sh`. |
| 15 | Directorios | Crea `~/Pictures`, `~/Projects`, `~/.local/bin`, etc. + `xdg-user-dirs-update`. |
| — | Verificación | Chequea Hyprland y reporta paquetes fallidos. |

---

## Paquetes instalados

### 3 · Drivers AMD (open source)
`mesa` · `lib32-mesa` · `vulkan-radeon` · `lib32-vulkan-radeon` ·
`xf86-video-amdgpu` · `libva-mesa-driver` · `lib32-libva-mesa-driver` ·
`vulkan-icd-loader` · `lib32-vulkan-icd-loader`

### 4 · Hyprland y ecosistema Wayland
`hyprland` · `hyprlock` · `hypridle` · `hyprpicker` ·
`xdg-desktop-portal-hyprland` · `xdg-desktop-portal-gtk` · `xdg-user-dirs` ·
`waybar` · `wofi` · `kitty` · `polkit-gnome` · `qt5-wayland` · `qt6-wayland` ·
`xorg-xwayland` · `xorg-xlsclients` · `nwg-look` · `grim` · `slurp` ·
`wl-clipboard` · `cliphist` · `swww` · `swaync` · `brightnessctl` ·
`playerctl` · `pavucontrol` · `network-manager-applet` ·
`pipewire` · `pipewire-alsa` · `pipewire-pulse` · `pipewire-jack` ·
`wireplumber` · `pamixer`

### 5 · File managers
`thunar` · `thunar-archive-plugin` · `thunar-volman` · `gvfs` · `gvfs-mtp` ·
`file-roller` · `yazi` · `ffmpegthumbnailer` · `unarchiver` · `jq` · `poppler` ·
`fd` · `ripgrep` · `fzf` · `zoxide` · `imagemagick`

### 6 · Fuentes
`noto-fonts` · `noto-fonts-emoji` · `noto-fonts-cjk` · `noto-fonts-extra` ·
`ttf-jetbrains-mono-nerd` · `inter-font` · `ttf-font-awesome` ·
`ttf-nerd-fonts-symbols` · `ttf-nerd-fonts-symbols-common` · `otf-font-awesome`

### 7 · CLI tools
`tmux` · `starship` · `bat` · `eza` · `btop` · `fastfetch` ·
`zsh-autosuggestions` · `zsh-syntax-highlighting` · `unzip` · `zip` · `p7zip` ·
`tree` · `tokei` · `ncdu` · `duf` · `hyperfine` · `wget` · `curl` · `rsync` ·
`pigz` · `pv`

### 8 · Dev tools
`neovim` · `github-cli` · `docker` · `docker-compose` · `python` ·
`python-pip` · `python-pipx` · `nodejs` · `npm` · `rustup`
→ habilita `docker.service`, agrega el usuario al grupo `docker`, y `rustup default stable`.

### 9 · Estudio
`zathura` · `zathura-pdf-mupdf` · `zathura-djvu` · `zathura-ps` · `anki`

### 10 · Apps generales
`firefox` · `vlc` · `gimp` · `obs-studio` · `discord` · `mpv` · `imv` ·
`libreoffice-fresh`

### 13 · AUR (vía yay)
`visual-studio-code-bin` · `wlogout` · `hyprshot` · `spotify` · `lazygit` ·
`sd` · `choose-rust-git` · `procs`
→ además clona **LazyVim** en `~/.config/nvim`.

---

## Symlinks que crea `install.sh`

| Origen en el repo | Destino |
|-------------------|---------|
| `hypr/hyprland.conf` | `~/.config/hypr/hyprland.conf` |
| `hyprlock/hyprlock.conf` | `~/.config/hypr/hyprlock.conf` |
| `hypridle/hypridle.conf` | `~/.config/hypr/hypridle.conf` |
| `waybar/config.jsonc` | `~/.config/waybar/config.jsonc` |
| `waybar/style.css` | `~/.config/waybar/style.css` |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` y `~/.tmux.conf` |
| `swaync/config.json` | `~/.config/swaync/config.json` |
| `swaync/style.css` | `~/.config/swaync/style.css` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `zsh/.zshrc` | `~/.zshrc` |

> Si el destino ya existía como archivo real, `install.sh` lo respalda como
> `*.bak.TIMESTAMP` antes de enlazar.

El arranque de Hyprland lo dispara `~/.zshrc` al loguearte en **TTY1**:

```bash
if [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$XDG_VTNR" = "1" ]]; then
    exec Hyprland
fi
```

---

## Cambios de nombre en repos (histórico de fixes)

Paquetes que cambiaron de nombre o desaparecieron en Arch y ya están corregidos
en el script:

| Antes | Ahora | Motivo |
|-------|-------|--------|
| `ttf-inter` | `inter-font` | Renombrado en `extra`. |
| `unar` | `unarchiver` | El paquete `unar` se reemplazó por `unarchiver` (provee `unar`/`lsar`). |
| `mesa-vdpau` | *(eliminado)* | Mesa quitó VDPAU (sept 2025); usar VA-API (`libva-mesa-driver`, ya incluido). |
| `lib32-mesa-vdpau` | *(eliminado)* | Idem, versión multilib. |
