# Guía de instalación — leivur @ gamdias

> Arch Linux · Hyprland · Dark Glossy Glass · AMD Ryzen 9600X

Hay dos caminos: **instalación desde cero** (máquina nueva/limpia) o **solo dotfiles** (Arch ya instalado).

---

## Tabla de contenidos

1. [Desde cero con archinstall](#1-desde-cero-con-archinstall)
2. [Solo dotfiles (Arch ya instalado)](#2-solo-dotfiles-arch-ya-instalado)
3. [Post-instalación manual](#3-post-instalación-manual)
4. [Estructura del repo](#4-estructura-del-repo)
5. [Keybindings](#5-keybindings)
6. [Aliases y funciones zsh](#6-aliases-y-funciones-zsh)
7. [Personalización](#7-personalización)
8. [Solución de problemas](#8-solución-de-problemas)

---

## 1. Desde cero con archinstall

### 1.1 Preparar el USB y bootear

```bash
# En otra máquina — flashear la ISO
dd bs=4M if=archlinux-*.iso of=/dev/sdX status=progress oflag=sync

# Bootear desde USB, seleccionar "Arch Linux install medium"
```

### 1.2 Conectarse a internet

```bash
# WiFi
iwctl
  station wlan0 scan
  station wlan0 connect "NombreDeRed"
  exit

# Verificar
ping -c3 archlinux.org
```

### 1.3 Clonar dotfiles en el live environment

```bash
# (opcional pero cómodo — tener los configs a mano)
pacman -Sy git --noconfirm
git clone https://github.com/leivur/dotfiles.git /tmp/dotfiles
```

### 1.4 Editar credenciales

**⚠️ Obligatorio antes de instalar:**

```bash
cp /tmp/dotfiles/archinstall/user_credentials.json /tmp/creds.json
nano /tmp/creds.json
# Reemplazá ambas ocurrencias de CAMBIAR_ESTA_PASSWORD con tu contraseña real
```

El archivo debe quedar así:
```json
{
    "!root-password": "tu_password_segura",
    "users": [
        {
            "!password": "tu_password_segura",
            "sudo": true,
            "username": "leivur"
        }
    ]
}
```

### 1.5 Lanzar archinstall

```bash
archinstall \
  --config /tmp/dotfiles/archinstall/user_configuration.json \
  --creds /tmp/creds.json
```

Lo que configura automáticamente:
- Disco: `/dev/nvme0n1`, GPT — 1GB EFI · 16GB swap · resto ext4
- Bootloader: GRUB
- Audio: PipeWire
- Red: NetworkManager
- Locale: `en_US.UTF-8`, teclado: `latam`
- Timezone: `America/Argentina/Buenos_Aires`
- Perfil: Minimal, driver AMD open-source
- Repos: multilib habilitado
- Usuario: `leivur` con sudo

> Archinstall preguntará confirmación antes de escribir al disco. Revisá el resumen.

### 1.6 Reiniciar

```bash
# Cuando archinstall termine:
exit       # salir del chroot si quedaste dentro
reboot
# Sacar el USB cuando reinicie
```

### 1.7 Primer boot — ejecutar post-install

Loguear como `leivur`, luego:

```bash
# Conectar WiFi primero si es necesario
nmcli device wifi connect "NombreDeRed" password "tu_wifi_password"

# Ejecutar el script de post-instalación
bash ~/dotfiles/archinstall/post-install.sh
```

El script instala en orden (puede tardar 15-30 min según conexión):
1. Actualización del sistema + keyring
2. Shell zsh
3. Drivers AMD (mesa, vulkan-radeon, xf86-video-amdgpu)
4. Hyprland + ecosistema Wayland completo
5. File managers (Thunar, Yazi)
6. Fuentes (JetBrainsMono NF, Inter, Noto)
7. CLI tools (tmux, starship, bat, eza, btop, fzf, zoxide...)
8. Dev tools (neovim/LazyVim, docker, rust, node, python, gh)
9. Estudio (zathura, anki)
10. Apps generales (firefox, vlc, gimp, obs, discord)
11. Servicios (bluetooth, ssh, reflector)
12. yay (AUR helper)
13. AUR (vscode, wlogout, hyprshot, spotify, lazygit, sd, procs)
14. Dotfiles + symlinks vía `install.sh`

### 1.8 Reiniciar y agregar wallpaper

```bash
reboot

# Después del reboot, copiá un wallpaper:
cp /ruta/a/tu/wallpaper.jpg ~/Pictures/Wallpapers/wallpaper.jpg

# Hyprland debería iniciar automáticamente desde TTY1
```

---

## 2. Solo dotfiles (Arch ya instalado)

### 2.1 Requisitos previos

Asegurate de tener instalados los paquetes base. Mínimo indispensable:

```bash
sudo pacman -S --needed \
    hyprland hyprlock hypridle waybar wofi kitty \
    swww swaync grim slurp wl-clipboard cliphist \
    starship tmux zsh zsh-autosuggestions zsh-syntax-highlighting \
    ttf-jetbrains-mono-nerd ttf-inter \
    bat eza fzf fd ripgrep zoxide \
    pipewire wireplumber pipewire-pulse
```

### 2.2 Clonar e instalar

```bash
git clone https://github.com/leivur/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

### 2.3 Cambiar shell a zsh

```bash
chsh -s /usr/bin/zsh
# Hacer logout/login para aplicar
```

### 2.4 Primeros pasos después de install.sh

```bash
# 1. Agregar wallpaper
mkdir -p ~/Pictures/Wallpapers
cp /ruta/a/imagen.jpg ~/Pictures/Wallpapers/wallpaper.jpg

# 2. Iniciar Hyprland desde TTY
Hyprland
# (el .zshrc lo hace automático si estás en TTY1)
```

---

## 3. Post-instalación manual

Pasos que **no se pueden automatizar** y hay que hacer a mano después del primer boot con Hyprland:

### Neovim / LazyVim

```bash
nvim
# LazyVim instala todos sus plugins en el primer arranque (~2 min)
# Presioná Enter para confirmar las instalaciones
```

### Docker — aplicar grupo

```bash
# El grupo docker se asigna en post-install.sh,
# pero requiere un nuevo login para activarse:
newgrp docker
# o hacer logout/login completo

# Verificar:
docker run hello-world
```

### Rust toolchain

```bash
# Verificar que stable está instalado:
rustup show
cargo --version
```

### Bluetooth

```bash
# Activar y conectar dispositivos:
systemctl start bluetooth
bluetoothctl
  power on
  scan on
  pair XX:XX:XX:XX:XX:XX
  connect XX:XX:XX:XX:XX:XX
  trust XX:XX:XX:XX:XX:XX
```

### Reflector (espejos de pacman)

```bash
# Actualizar manualmente la primera vez:
sudo reflector --country Argentina,Brazil,Chile \
    --age 12 --protocol https --sort rate \
    --save /etc/pacman.d/mirrorlist
```

---

## 4. Estructura del repo

```
dotfiles/
├── .gitignore              # Excluye user_credentials.json y .bak
├── INSTALL.md              # Esta guía
├── README.md               # Overview del repo
├── install.sh              # Crea symlinks seguros (backup automático)
│
├── archinstall/
│   ├── post-install.sh     # Instala todo el sistema (NO root)
│   ├── user_configuration.json  # Config de archinstall
│   └── user_credentials.json   # ⚠️  NO commitear con passwords reales
│
├── hypr/
│   └── hyprland.conf       # Compositor: layouts, keybinds, rules, animaciones
├── hypridle/
│   └── hypridle.conf       # Idle: 4m dim → 5m lock → 7m dpms → 15m suspend
├── hyprlock/
│   └── hyprlock.conf       # Lockscreen: blur screenshot + reloj grande
│
├── waybar/
│   ├── config.jsonc        # Dock bottom: módulos, workspaces, power menu
│   └── style.css           # CSS glass monochrome
│
├── kitty/
│   └── kitty.conf          # Terminal: JetBrainsMono NF, opacidad 0.82
├── tmux/
│   └── tmux.conf           # Multiplexer: prefix C-Space, vi keys, statusbar
├── starship/
│   └── starship.toml       # Prompt 2 líneas, monochrome, right prompt hora
│
├── swaync/
│   ├── config.json         # Centro de notificaciones
│   └── style.css           # Estilos glass dark
│
└── zsh/
    └── .zshrc              # Shell: aliases, funciones, plugins, fzf, zoxide
```

### Symlinks que crea `install.sh`

| Archivo en dotfiles | Destino |
|---|---|
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

> Si alguno de estos archivos ya existe y **no es symlink**, `install.sh` lo renombra a `.bak.TIMESTAMP` antes de reemplazarlo.

---

## 5. Keybindings

### Aplicaciones

| Atajo | Acción |
|---|---|
| `Super + Enter` | Kitty (terminal) |
| `Super + Space` | Wofi (lanzador de apps) |
| `Super + E` | Thunar (file manager) |
| `Super + Shift + E` | Yazi en Kitty |
| `Super + B` | Firefox |
| `Super + N` | Toggle swaync (notificaciones) |
| `Super + C` | Historial del portapapeles (cliphist) |

### Ventanas

| Atajo | Acción |
|---|---|
| `Super + Q` | Cerrar ventana activa |
| `Super + F` | Fullscreen |
| `Super + Shift + F` | Fullscreen (sin bordes) |
| `Super + V` | Toggle floating |
| `Super + P` | Pseudotile |
| `Super + J` | Toggle split direction |

### Navegación

| Atajo | Acción |
|---|---|
| `Super + ←/→/↑/↓` | Mover foco |
| `Super + Shift + ←/→/↑/↓` | Mover ventana |
| `Super + Alt + ←/→/↑/↓` | Redimensionar ventana |
| `Super + 1-0` | Ir al workspace 1-10 |
| `Super + Shift + 1-0` | Mover ventana al workspace |
| `Super + [ / ]` | Workspace anterior / siguiente |
| `Super + scroll` | Cambiar workspace |

### Mouse

| Gesto | Acción |
|---|---|
| `Super + click izq drag` | Mover ventana |
| `Super + click der drag` | Redimensionar ventana |

### Sistema

| Atajo | Acción |
|---|---|
| `Super + Shift + R` | Recargar Hyprland |
| `Super + Shift + W` | Wallpaper aleatorio |
| `Super + Shift + L` | Bloquear pantalla |
| `Super + Shift + Q` | Salir de Hyprland |
| `Super + S` | Toggle scratchpad |

### Screenshots

| Atajo | Acción |
|---|---|
| `Print` | Screenshot completo → `~/Pictures/Screenshots/` |
| `Shift + Print` | Screenshot área → `~/Pictures/Screenshots/` |
| `Super + Shift + S` | Screenshot área → portapapeles |

### Multimedia

| Atajo | Acción |
|---|---|
| `XF86AudioRaiseVolume` | Subir volumen 5% |
| `XF86AudioLowerVolume` | Bajar volumen 5% |
| `XF86AudioMute` | Silenciar |
| `XF86MonBrightnessUp/Down` | Brillo +/- 5% |
| `XF86AudioPlay/Next/Prev` | Controlar reproducción |

---

## 6. Aliases y funciones zsh

### Sistema de archivos

```bash
ls          # eza con iconos
ll          # eza -lah con git status
lt          # eza --tree nivel 2
cat         # bat (syntax highlighting)
cp/mv/rm    # versiones interactivas (-iv / -Iv)
```

### Pacman / AUR

```bash
update      # sudo pacman -Syu
install     # sudo pacman -S
remove      # sudo pacman -Rns
search      # pacman -Ss
cleanup     # eliminar huérfanos + limpiar caché
mirrors     # reflector para AR/BR/CL
yayi        # yay -S (AUR install)
yayu        # yay -Syu (AUR update)
```

### Git

```bash
gs          # git status -sb
ga / gaa    # git add / add -A
gc "msg"    # git commit -m
gp / gpf    # push / push --force-with-lease
gl          # log --oneline --graph -15
gd / gds    # diff / diff --staged
gco / gcb   # checkout / checkout -b
gst / gstp  # stash / stash pop
grbi        # rebase -i
```

### Herramientas

```bash
f           # yazi (sale y hace cd al directorio)
t           # tmux
ta nombre   # tmux attach -t
ff          # fzf con preview de bat
rgf         # ripgrep + fzf interactivo
hreload     # recargar Hyprland
wallrandom  # wallpaper aleatorio desde ~/Pictures/Wallpapers/
```

### Funciones

```bash
extract archivo.tar.gz   # descomprimir cualquier formato
mkcd nombre/             # mkdir + cd
psgrep nombre            # buscar proceso
myip                     # IP pública
weather "Buenos Aires"   # clima via wttr.in
bak archivo.txt          # copia de seguridad con timestamp
y                        # yazi con cd al salir
serve [puerto]           # servidor HTTP en puerto (default 8000)
ginit                    # git init + commit inicial
```

---

## 7. Personalización

### Cambiar wallpaper

```bash
# Manual
swww img ~/Pictures/Wallpapers/mi-imagen.jpg \
    --transition-type wipe --transition-angle 30 --transition-duration 1.5

# Aleatorio (también disponible como Super+Shift+W)
wallrandom
```

### Cambiar el wallpaper por defecto al arranque

Editar `hypr/hyprland.conf` línea 11:
```ini
exec-once = swww img ~/Pictures/Wallpapers/wallpaper.jpg ...
```
Reemplazar `wallpaper.jpg` con el nombre de tu imagen.

### Ajustar el blur

En `hypr/hyprland.conf`, sección `decoration > blur`:
```ini
size = 12      # tamaño del kernel (más alto = más blur)
passes = 4     # pasadas (más = más suave, más GPU)
```

### Ajustar opacidad de kitty

En `kitty/kitty.conf`:
```ini
background_opacity  0.82   # 0.0 = transparente, 1.0 = opaco
```

En `hypr/hyprland.conf`:
```ini
windowrulev2 = opacity 0.82, class:^(kitty)$
```

Ambos valores deben ser consistentes.

### Agregar un monitor secundario

En `hypr/hyprland.conf` después de `monitor = , preferred, auto, 1`:
```ini
monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1
#          nombre,  resolución,    posición, escala
```

Obtener nombre del monitor: `hyprctl monitors`

### Cambiar fuente de waybar/UI

En `waybar/style.css`, línea 1 del bloque `*`:
```css
font-family: "Inter", "JetBrainsMono Nerd Font", sans-serif;
```

### Recargar configuración sin reiniciar

```bash
hyprctl reload
# o Super + Shift + R
```

---

## 8. Solución de problemas

### Hyprland no inicia desde TTY

Verificar que el `.zshrc` tiene el autostart al final:
```bash
tail -5 ~/.zshrc
# debe mostrar el bloque:
# if [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$XDG_VTNR" = "1" ]]; then
#     exec Hyprland
# fi
```

Si no está vinculado:
```bash
ls -la ~/.zshrc  # debe mostrar -> .../dotfiles/zsh/.zshrc
```

### Waybar no aparece

```bash
# Ver logs en vivo
journalctl -f -u waybar
# o lanzar manual para ver errores:
waybar &
```

### Íconos de waybar no se ven (cuadrados)

Las fuentes Nerd Font no están instaladas o no son las correctas:
```bash
fc-list | grep -i "JetBrains"
# debe mostrar JetBrainsMono Nerd Font

# Reinstalar si falta:
sudo pacman -S ttf-jetbrains-mono-nerd
fc-cache -fv
```

### Swaync sin blur

Verificar que las `layerrule` están en `hyprland.conf`:
```ini
layerrule = blur, swaync-control-center
layerrule = blur, swaync-notification-window
```

Y que en `hyprland.conf` el blur está habilitado:
```ini
blur {
    enabled = true
```

### Audio no funciona

```bash
systemctl --user status pipewire wireplumber
# Si están inactivos:
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

### Cliphist no guarda historial

El daemon wl-paste debe estar corriendo. Verificar en `hyprland.conf`:
```ini
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
```

### Pantalla de bloqueo (hyprlock) no aparece

```bash
loginctl lock-session
# Si no funciona, llamar directamente:
hyprlock
```

### Docker: permiso denegado sin sudo

```bash
# El grupo se aplica solo después de un nuevo login:
newgrp docker
# Verificar que estás en el grupo:
groups | grep docker
```

### Starship no carga / prompt roto

```bash
which starship           # debe estar instalado
echo $STARSHIP_CONFIG    # debe apuntar a ~/dotfiles/starship/starship.toml
ls -la $STARSHIP_CONFIG  # debe existir
```

### Reinstalar symlinks (después de mover ~/dotfiles)

```bash
cd ~/dotfiles
bash install.sh
# El script detecta symlinks rotos/incorrectos y los recrea
```

---

## Notas finales

- `archinstall/user_credentials.json` está en `.gitignore` — **nunca subas passwords al repo**.
- Los archivos originales que `install.sh` reemplaza se guardan como `archivo.bak.TIMESTAMP` en el mismo directorio.
- Para actualizar los dotfiles desde el repo: `cd ~/dotfiles && git pull`.
- Para contribuir cambios: editar directamente en `~/dotfiles/` (los archivos en `~/.config/` son symlinks, los cambios se reflejan automáticamente).

---

*leivur — gamdias · Arch Linux · Hyprland · 2025*
