# Guía de Instalación: Arch Linux + Hyprland
### Para: Ryzen 5 9600X · 16GB RAM · SSD NVMe 1TB

> **Antes de empezar:** Esta guía asume que vas a borrar Windows y hacer una instalación limpia. No hay vuelta atrás una vez que formatees el disco. Hacé un backup de lo que necesites.

---

## Índice

1. [Conceptos clave antes de arrancar](#1-conceptos-clave)
2. [Preparar el USB booteable](#2-preparar-el-usb)
3. [Bootear desde el USB](#3-bootear)
4. [Conectarse a internet](#4-internet)
5. [Instalación automática con archinstall](#5-instalacion-con-archinstall) ← **nuevo**
6. [Primer arranque](#6-primer-arranque)
7. [Post-instalación con el script](#7-post-instalacion) ← **nuevo**
8. [Solución de problemas comunes](#8-troubleshooting)

---

## 1. Conceptos clave

Antes de meter comandos, entendé qué estás haciendo. Esto va a hacer que no te pierdas si algo sale distinto.

### ¿Qué es el sistema de archivos y las particiones?

Tu SSD es como una hoja en blanco. Antes de instalar nada, hay que dividirla en **particiones** (secciones) y luego darle a cada una un **formato** (sistema de archivos) para que el OS sepa cómo leer y escribir datos.

Para Arch vamos a crear 3 particiones:

| Partición | Tamaño | Formato | Para qué sirve |
|-----------|--------|---------|----------------|
| EFI/boot  | 1 GB   | FAT32   | Archivos de arranque. UEFI los necesita acá para iniciar el sistema. |
| swap      | 16 GB  | swap    | RAM virtual. Cuando la RAM se llena, el sistema usa esto. Con 16GB de RAM, 16GB de swap es suficiente y permite hibernación. |
| root `/`  | Resto  | ext4    | Todo el sistema operativo, tus archivos, programas, etc. |

> En esta guía todo esto lo hace **archinstall** automáticamente con la configuración que ya tenemos lista en los dotfiles. No hay que tocar `fdisk` manualmente.

### ¿Qué es UEFI vs BIOS?

Tu placa madre moderna usa **UEFI** (no BIOS legacy). Esto importa porque el proceso de booteo y el bootloader funcionan diferente. Esta guía es para UEFI.

### ¿Qué es el bootloader?

Es el programa que arranca primero cuando encendés la PC, antes que Linux. Su trabajo es cargar el kernel de Linux. Usamos **GRUB**, el más común y robusto.

### ¿Qué es `chroot`?

En el paso de instalación, vamos a "entrar" al nuevo sistema desde el USB usando `arch-chroot`. Es como teleportarte dentro del sistema que acabás de instalar para configurarlo, antes de reiniciar en él. Con archinstall esto sucede internamente — vos no lo ves.

---

## 2. Preparar el USB

### En Windows (antes de formatearlo)

1. Descargá la ISO de Arch desde el sitio oficial:  
   👉 https://archlinux.org/download/  
   Bajá el archivo `.iso` (aprox. 1.1 GB).

2. Descargá **Rufus** (gratuito):  
   👉 https://rufus.ie/

3. Insertá un USB de al menos 2 GB.

4. Abrí Rufus y configuralo así:
   - **Device:** tu USB
   - **Boot selection:** la ISO de Arch que bajaste
   - **Partition scheme:** `GPT` ← importante para UEFI
   - **Target system:** `UEFI (non CSM)`
   - **File system:** `FAT32`
   - Hacé click en **START** → si pregunta por el modo de escritura, elegí **ISO Image mode**

5. Esperá que termine. Cuando diga "READY", listo.

---

## 3. Bootear

1. **Apagá la PC.**

2. **Conectá el USB.**

3. **Entrá al BIOS/UEFI:** Al encender, apretá `DEL` o `F2` repetidamente (en placas GIGABYTE generalmente es `DEL`).

4. En el UEFI:
   - Deshabilitá **Secure Boot** (buscalo en Security o Boot). Arch puede correr con Secure Boot pero es más complejo, lo saltamos por ahora.
   - En **Boot Order**, poné el USB primero.
   - Guardá y reiniciá (`F10` generalmente).

5. Va a aparecer el menú de Arch. Seleccioná **"Arch Linux install medium (x86_64, UEFI)"** y presioná Enter.

6. Vas a ver un montón de texto y después vas a terminar en un prompt así:
   ```
   root@archiso ~ #
   ```
   Estás en el live environment del USB. Desde acá instalamos todo.

> **Nota:** El teclado puede estar en layout QWERTY inglés. Cambialo con:
> ```bash
> loadkeys la-latin1
> ```

---

## 4. Internet

La instalación necesita internet para bajar paquetes. Si estás por Ethernet debería funcionar automáticamente.

Verificá:
```bash
ping -c 3 archlinux.org
```

Si ves respuestas con tiempos (ej: `64 bytes from...`), tenés internet. Si no responde:
```bash
# Ver interfaces de red disponibles
ip link

# Activar la interfaz ethernet
ip link set enp6s0 up   # reemplazá enp6s0 por el nombre que viste

# DHCP automático
dhcpcd
```

Para WiFi:
```bash
iwctl
  station wlan0 scan
  station wlan0 connect "NombreDeRed"
  exit
```

---

## 5. Instalación con archinstall

Acá es donde esta guía cambia respecto a una instalación manual. En lugar de particionar a mano, configurar el fstab, hacer chroot, y configurar todo desde cero, usamos **archinstall** con la configuración ya preparada en los dotfiles.

### 5.1 Clonar los dotfiles en el live environment

```bash
# Instalar git (ya viene en la ISO, pero por las dudas)
pacman -Sy git --noconfirm

# Clonar el repo
git clone https://github.com/leivur/dotfiles.git /tmp/dotfiles
```

### 5.2 ⚠️ Editar las credenciales (obligatorio)

El archivo `user_credentials.json` tiene placeholders — **hay que poner las contraseñas reales antes de instalar**. Este archivo no se commitea al repo (está en `.gitignore`).

```bash
nano /tmp/dotfiles/archinstall/user_credentials.json
```

Reemplazá `CAMBIAR_ESTA_PASSWORD` en ambas líneas con tu contraseña:

```json
{
    "!root-password": "tu_contraseña_aqui",
    "users": [
        {
            "!password": "tu_contraseña_aqui",
            "sudo": true,
            "username": "leivur"
        }
    ]
}
```

Guardá: `Ctrl+O`, Enter, `Ctrl+X`.

### 5.3 Revisar qué va a instalar (opcional pero recomendado)

El archivo `user_configuration.json` ya tiene configurado todo lo que necesitás:

```bash
cat /tmp/dotfiles/archinstall/user_configuration.json
```

Lo más importante:
- **Disco:** `/dev/nvme0n1` con GPT — 1GB EFI + 16GB swap + resto ext4
- **Bootloader:** GRUB
- **Audio:** PipeWire
- **Red:** NetworkManager
- **Locale:** `en_US.UTF-8`, teclado `latam`
- **Timezone:** `America/Argentina/Buenos_Aires`
- **Perfil:** Minimal, driver AMD open-source (mesa, vulkan-radeon)
- **Repos:** multilib habilitado
- **Usuario:** `leivur` con sudo
- **Paquetes base:** git, curl, zsh, btop, fastfetch, bluez, reflector, y más

> ⚠️ El disco objetivo es `/dev/nvme0n1`. Verificá antes con `lsblk` que ese es tu SSD y no otro disco.

### 5.4 Lanzar archinstall

```bash
archinstall \
  --config /tmp/dotfiles/archinstall/user_configuration.json \
  --creds /tmp/dotfiles/archinstall/user_credentials.json
```

archinstall va a mostrar un resumen de lo que va a hacer y pedir confirmación antes de tocar el disco. **Leé el resumen.** Si todo se ve bien, confirmá.

El proceso tarda unos 5-10 minutos dependiendo de la conexión. Cuando termine va a preguntar si querés reiniciar — decí que sí.

**Sacá el USB antes de que reinicie** o vas a volver a bootear desde él.

---

## 6. Primer arranque

Si todo salió bien, vas a ver el menú de GRUB y después un login de texto:

```
gamdias login:
```

Ingresá con `leivur` y tu contraseña.

### Conectar a internet (si es necesario)

```bash
# Ethernet: debería funcionar automáticamente con NetworkManager
# Para WiFi:
nmcli device wifi connect "NombreDeRed" password "tu_wifi_password"

# Verificar
ping -c3 archlinux.org
```

---

## 7. Post-instalación con el script

Acá está la otra gran diferencia de esta guía: en lugar de instalar todo a mano paquete por paquete, un solo script se encarga de todo.

### 7.1 Ejecutar post-install.sh

```bash
bash ~/dotfiles/archinstall/post-install.sh
```

> Ejecutalo como `leivur`, **no como root**. El script lo verifica y sale si detecta root.

El script instala en orden y puede tardar **15-30 minutos** dependiendo de la conexión:

| Paso | Qué instala |
|------|-------------|
| 1 | Actualización del sistema + keyring |
| 2 | Cambia shell a zsh |
| 3 | Drivers AMD: mesa, lib32-mesa, vulkan-radeon, xf86-video-amdgpu, libva |
| 4 | Hyprland completo: hyprland, hyprlock, hypridle, waybar, wofi, kitty, swaync, swww, grim, slurp, cliphist, brightnessctl, playerctl, PipeWire |
| 5 | File managers: Thunar, Yazi + dependencias |
| 6 | Fuentes: JetBrainsMono Nerd Font, Inter, Noto, Font Awesome |
| 7 | CLI tools: tmux, starship, bat, eza, btop, fzf, zoxide, ripgrep, fd, fastfetch... |
| 8 | Dev: neovim + LazyVim, docker, rustup, nodejs, python, github-cli |
| 9 | Estudio: zathura, anki |
| 10 | Apps: firefox, vlc, gimp, obs-studio, discord |
| 11 | Servicios: bluetooth, ssh, reflector |
| 12 | yay (AUR helper) |
| 13 | AUR: vscode, wlogout, hyprshot, spotify, lazygit, sd, procs |
| 14 | Clona dotfiles y ejecuta `install.sh` (symlinks) |
| 15 | Crea directorios: Pictures, Projects, Documents, etc. |

### 7.2 Qué hace install.sh

`post-install.sh` llama automáticamente a `install.sh`, que crea **symlinks** desde `~/dotfiles/` hacia los destinos correctos. Si algún archivo ya existe, lo renombra a `.bak.TIMESTAMP` antes de reemplazarlo.

Los symlinks que crea:

| Config | Destino |
|--------|---------|
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

### 7.3 Reiniciar para aplicar todo

```bash
reboot
```

Al volver, `~/.zshrc` va a detectar que estás en TTY1 e iniciar Hyprland automáticamente:

```bash
# Este bloque al final del .zshrc lo hace solo:
if [[ -z "$WAYLAND_DISPLAY" ]] && [[ "$XDG_VTNR" = "1" ]]; then
    exec Hyprland
fi
```

### 7.4 Primeros pasos manuales después del reboot

Algunas cosas no se pueden automatizar:

```bash
# 1. Agregar un wallpaper
cp /ruta/a/imagen.jpg ~/Pictures/Wallpapers/wallpaper.jpg
# (Hyprland lo carga desde ahí al arrancar)

# 2. Abrir nvim para que LazyVim instale sus plugins (~2 min)
nvim
# Presioná Enter para confirmar las instalaciones

# 3. Docker requiere re-login para aplicar el grupo
newgrp docker
# o hacer logout/login completo

# 4. Primer wallpaper aleatorio si ya tenés varios:
# Super + Shift + W  (keybinding ya configurado)
```

---

## 8. Troubleshooting

### No arranca Hyprland / pantalla en negro

```bash
# Ver logs
cat ~/.local/share/hyprland/hyprland.log

# Verificar drivers AMD
pacman -Qs mesa vulkan-radeon
# Si no están, instalar:
sudo pacman -S mesa xf86-video-amdgpu vulkan-radeon
```

### No hay sonido

```bash
systemctl --user status pipewire wireplumber

# Si no está corriendo:
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

### No funciona internet después del reinicio

```bash
sudo systemctl status NetworkManager

# Si no está corriendo:
sudo systemctl enable --now NetworkManager

# Conectarse por WiFi con TUI:
nmtui
```

### Waybar no aparece o tiene errores

```bash
# Lanzar manual para ver el error
waybar

# Ver logs
journalctl -f -u waybar
```

### Íconos de waybar se ven como cuadrados

Las fuentes Nerd Font no están cargadas:
```bash
fc-list | grep -i "JetBrains"

# Si no aparece nada:
sudo pacman -S ttf-jetbrains-mono-nerd
fc-cache -fv
# Reiniciar waybar: Super + Shift + R
```

### `pacman` falla con error de llaves (keyring)

```bash
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Sy archlinux-keyring
sudo pacman -Su
```

### Hyprland no carga el wallpaper al arrancar

```bash
# Verificar que el archivo existe:
ls ~/Pictures/Wallpapers/wallpaper.jpg

# Si no existe, copiá cualquier imagen:
cp /ruta/imagen.jpg ~/Pictures/Wallpapers/wallpaper.jpg

# Recargar Hyprland:
# Super + Shift + R
```

### Reinstalar symlinks si moviste ~/dotfiles

```bash
cd ~/dotfiles
bash install.sh
```

---

## Atajos de teclado

Esta configuración viene de los dotfiles — es la que está activa después de instalar.

| Atajo | Acción |
|-------|--------|
| `Super + Enter` | Kitty (terminal) |
| `Super + Space` | Wofi (lanzador de apps) |
| `Super + Q` | Cerrar ventana activa |
| `Super + E` | Thunar (file manager) |
| `Super + Shift + E` | Yazi en Kitty |
| `Super + B` | Firefox |
| `Super + N` | Toggle notificaciones (swaync) |
| `Super + C` | Historial del portapapeles |
| `Super + F` | Fullscreen |
| `Super + V` | Toggle floating |
| `Super + Shift + W` | Wallpaper aleatorio |
| `Super + Shift + R` | Recargar Hyprland |
| `Super + Shift + L` | Bloquear pantalla |
| `Super + Shift + Q` | Salir de Hyprland |
| `Super + 1-0` | Cambiar workspace |
| `Super + Shift + 1-0` | Mover ventana al workspace |
| `Super + ←/→/↑/↓` | Mover foco |
| `Super + Shift + ←/→/↑/↓` | Mover ventana |
| `Super + Alt + ←/→/↑/↓` | Redimensionar ventana |
| `Super + click izq drag` | Mover ventana con mouse |
| `Super + click der drag` | Redimensionar con mouse |
| `Print` | Screenshot completo → `~/Pictures/Screenshots/` |
| `Shift + Print` | Screenshot área → `~/Pictures/Screenshots/` |
| `Super + Shift + S` | Screenshot área → portapapeles |
| `XF86AudioRaiseVolume` | Subir volumen 5% |
| `XF86AudioLowerVolume` | Bajar volumen 5% |
| `XF86MonBrightnessUp/Down` | Brillo +/- 5% |

---

## Recursos para seguir

- **Wiki de Arch:** https://wiki.archlinux.org — la biblia. Si tenés un problema, la respuesta está acá.
- **Hyprland Wiki:** https://wiki.hyprland.org — documentación completa
- **Dotfiles repo:** https://github.com/leivur/dotfiles — para personalizar configs
- **r/unixporn:** Para dotfiles e inspiración visual
- **r/archlinux:** Comunidad, preguntas, noticias

---

> **Tip final:** La primera instalación probablemente salga con algún problema. Es normal. Romper Arch y tener que reinstalar es parte del proceso de aprendizaje, y la segunda vez te toma 30 minutos. No te frustres.
