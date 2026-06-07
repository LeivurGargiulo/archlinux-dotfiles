# leivur's dotfiles

Arch Linux + Hyprland — configuración personal lista para usar.

## Instalación en 2 comandos

```bash
git clone https://github.com/leivur/dotfiles ~/dotfiles
bash ~/dotfiles/install.sh
```

El script crea symlinks de todos los configs al lugar correcto.
Si ya existía algún archivo, lo renombra a `.backup` antes de reemplazarlo.

---

## Paquetes necesarios

Antes de correr el installer, asegurate de tener todo instalado.

### Sistema base (en chroot durante la instalación)
```bash
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers \
  amd-ucode networkmanager network-manager-applet \
  nano vim git curl wget sudo zsh zsh-completions \
  pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber \
  bluez bluez-utils blueman \
  ntfs-3g dosfstools \
  man-db man-pages
```

### Entorno gráfico + apps (ya en el sistema instalado)
```bash
sudo pacman -S \
  hyprland xdg-desktop-portal-hyprland \
  waybar wofi dunst \
  kitty \
  polkit-gnome \
  qt5-wayland qt6-wayland \
  xorg-xwayland \
  nwg-look \
  grim slurp \
  wl-clipboard \
  brightnessctl playerctl \
  thunar thunar-archive-plugin file-roller \
  pavucontrol \
  noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd \
  firefox vlc obsidian btop fastfetch \
  fzf ripgrep bat eza \
  zsh-autosuggestions zsh-syntax-highlighting
```

### AUR (instalar yay primero)
```bash
cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

yay -S brave-bin visual-studio-code-bin
```

---

## Estructura

```
dotfiles/
├── hypr/
│   └── hyprland.conf       # Compositor, keybindings, animaciones
├── waybar/
│   ├── config.jsonc        # Módulos de la barra
│   └── style.css           # Tema Catppuccin Mocha
├── kitty/
│   └── kitty.conf          # Terminal — fuente, colores, opacidad
├── zsh/
│   └── .zshrc              # Aliases, plugins, prompt, autostart
├── install.sh              # Crea los symlinks
└── README.md
```

---

## Atajos de teclado (Hyprland)

| Atajo | Acción |
|-------|--------|
| `Super + Enter` | Terminal (kitty) |
| `Super + Q` | Cerrar ventana |
| `Super + Space` | Launcher (wofi) |
| `Super + E` | File manager (thunar) |
| `Super + B` | Brave |
| `Super + F` | Fullscreen |
| `Super + Shift + F` | Fullscreen sin bordes |
| `Super + V` | Flotar ventana |
| `Super + Shift + Q` | Salir de Hyprland |
| `Super + Shift + R` | Recargar config |
| `Super + H/J/K/L` | Mover foco (vim-style) |
| `Super + ←/→/↑/↓` | Mover foco (flechas) |
| `Super + Shift + H/J/K/L` | Mover ventana |
| `Super + 1-9` | Ir a workspace |
| `Super + Shift + 1-9` | Mover ventana a workspace |
| `Print` | Screenshot completo (guarda en ~/Pictures) |
| `Shift + Print` | Screenshot de área |
| `Super + Shift + S` | Screenshot de área → clipboard |

---

## Créditos

Tema de colores: [Catppuccin Mocha](https://github.com/catppuccin/catppuccin)
