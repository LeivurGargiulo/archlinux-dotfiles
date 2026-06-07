# dotfiles — leivur @ gamdias

**Arch Linux + Hyprland · Dark Glossy Glass · Monochrome**

```
OS:        Arch Linux
WM:        Hyprland (Wayland)
Bar:       Waybar (dock bottom)
Terminal:  Kitty
Shell:     zsh + Starship
Editor:    Neovim (LazyVim)
CPU/GPU:   AMD Ryzen 9600X (open-source drivers)
```

---

## Instalación rápida

```bash
git clone https://github.com/leivur/dotfiles.git ~/dotfiles
cd ~/dotfiles && bash install.sh
```

## Instalación desde cero (Arch Linux)

1. Bootear desde Arch ISO
2. Copiar `archinstall/user_configuration.json` y `archinstall/user_credentials.json` (completar passwords)
3. Ejecutar: `archinstall --config user_configuration.json --creds user_credentials.json`
4. Reiniciar, loguear como `leivur`
5. Ejecutar: `bash ~/dotfiles/archinstall/post-install.sh`

---

## Estructura

```
dotfiles/
├── hypr/            # Hyprland compositor
├── hypridle/        # Idle daemon (dim/lock/sleep)
├── hyprlock/        # Lock screen
├── waybar/          # Status bar (dock)
├── kitty/           # Terminal
├── tmux/            # Multiplexer
├── starship/        # Prompt
├── swaync/          # Notification center
├── zsh/             # Shell config
├── archinstall/     # Arch install scripts
├── install.sh       # Symlink installer
└── .gitignore
```

---

## Keybindings principales

| Atajo | Acción |
|-------|--------|
| `Super+Enter` | Kitty |
| `Super+Space` | Wofi (app launcher) |
| `Super+Q` | Cerrar ventana |
| `Super+E` | Thunar |
| `Super+Shift+E` | Yazi (en kitty) |
| `Super+B` | Firefox |
| `Super+N` | Toggle swaync |
| `Super+C` | Historial portapapeles |
| `Super+F` | Fullscreen |
| `Super+V` | Toggle floating |
| `Super+Shift+W` | Wallpaper random |
| `Super+Shift+R` | Reload Hyprland |
| `Print` | Screenshot completo |
| `Shift+Print` | Screenshot área |
| `Super+Shift+S` | Screenshot área → clipboard |

---

## Paleta de colores

Completamente **monocromática**. Sin colores de acento salvo el blur glassmorphism.

| Variable | Valor | Uso |
|----------|-------|-----|
| Background | `#050505` / `#0a0a0a` | Ventanas, bar |
| Foreground | `#e8e8e8` | Texto principal |
| Accent | `#ffffff` | Bordes activos, cursor |
| Inactive | `#333333` / `#444444` | Bordes inactivos |
| Muted | `#555555` / `#666666` | Texto secundario |

---

## Dependencias clave

Instaladas automáticamente por `post-install.sh`:
`hyprland` `hyprlock` `hypridle` `waybar` `swaync` `swww` `kitty` `tmux`
`starship` `zsh` `neovim` `yazi` `wofi` `grim` `slurp` `wl-clipboard` `cliphist`
`brightnessctl` `playerctl` `pavucontrol` `docker` `rustup` `nodejs` `python`
`bat` `eza` `btop` `fzf` `fd` `ripgrep` `zoxide` `fastfetch` `anki` `zathura`

---

*leivur — gamdias · Arch Linux · Hyprland*
