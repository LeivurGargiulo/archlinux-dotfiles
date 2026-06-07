# CachyOS + HyDE — Dark Glossy Glass

Guía completa para montar el estilo **dark glossy glass · monochrome (negro/grises
+ acento blanco)** sobre [CachyOS](https://cachyos.org/) usando
[**HyDE**](https://github.com/HyDE-Project/HyDE) como base ya armada, y aplicar
encima los toques propios + una capa de *ricing por aplicación*, sin pelear con
una config de Hyprland desde cero.

> **Filosofía:** HyDE maneja lo pesado (Hyprland, waybar, rofi, temas, wallpapers,
> lockscreen, idle). Nosotros sólo ponemos *overrides* en los archivos que HyDE
> reserva para el usuario (así sobreviven a updates y cambios de tema) y sumamos
> add-ons que viven *encima* sin tocar lo que HyDE administra.

---

## Índice

1. [Requisitos](#0-requisitos)
2. [Instalar CachyOS](#1-instalar-cachyos)
3. [Instalar HyDE](#2-instalar-hyde)
4. [Elegir un tema dark](#3-elegir-un-tema-dark)
5. [Aplicar los overrides (`apply.sh`)](#4-aplicar-los-overrides)
6. [Instalar el ricing (`install-ricing.sh`)](#5-instalar-el-ricing)
7. [Referencia: todo lo que se agrega](#referencia-todo-lo-que-se-agrega)
8. [El mecanismo de override de HyDE](#el-mecanismo-de-override-de-hyde)
9. [Personalizar](#personalizar)
10. [Notas / caveats](#notas--caveats)

---

## 0. Requisitos

- CachyOS instalado (es Arch optimizado; todo lo de HyDE aplica).
- Tu usuario normal con `sudo`. **Nada de esto se corre como root.**

---

## 1. Instalar CachyOS

En el instalador, elegí **Desktop = Hyprland** (o una instalación mínima/CLI si
querés que HyDE traiga todo). Cualquiera sirve: HyDE instala lo que falte.

> Si ya tenés CachyOS con otro DE, igual podés seguir: HyDE convive y lo elegís
> en la pantalla de login (SDDM).

---

## 2. Instalar HyDE

HyDE **no es un paquete**: se clona y se corre su `install.sh`.

```bash
sudo pacman -S --needed git base-devel
git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
cd ~/HyDE/Scripts
./install.sh
```

- **No** lo corras con `sudo`.
- Detecta NVIDIA solo; en tu AMD usa mesa (ya cubierto por CachyOS).
- Reiniciá y entrá a la sesión **Hyprland (HyDE)** desde SDDM.

> CachyOS es Arch-based; si algún paso se queja, suele ser un paquete que CachyOS
> ya trae con otro nombre — seguí y revisá al final. Ante la duda:
> `./install.sh -i` (mínimo) y después los configs.

---

## 3. Elegir un tema dark

HyDE es temático: cambiás todo el look con un comando.

```bash
hydectl theme import                       # menú interactivo
hydectl theme import --name "Tema" --url "<git-url>"   # uno puntual
```

Puntos de partida oscuros: **Catppuccin Mocha**, **Tokyo Night**,
**Gruvbox Material Dark**, o la
[hyde-gallery](https://github.com/HyDE-Project/hyde-gallery). El paso 5 le mete
el blur/translucidez/sombras y los bordes blancos.

---

## 4. Aplicar los overrides

```bash
git clone -b cachyos https://github.com/LeivurGargiulo/archlinux-dotfiles.git ~/archlinux-dotfiles
cd ~/archlinux-dotfiles
bash cachyos/apply.sh
```

Enlaza (con backup) los configs propios sobre HyDE y recarga Hyprland.
Idempotente: lo podés correr de nuevo sin romper nada.

---

## 5. Instalar el ricing

```bash
bash cachyos/ricing/install-ricing.sh
```

Instala y aplica la capa de rice por-aplicación + extras (todo monocromático).
Resiliente: si un paquete del AUR falla, sigue y te avisa.

---

## Referencia: todo lo que se agrega

### 🪟 Overrides de Hyprland — `cachyos/hypr/userprefs.conf`

El **corazón** del look. HyDE lo carga al final, así que pisa sus defaults y los
del tema. Incluye:

| Componente | Descripción |
|------------|-------------|
| **Teclado latam** | `kb_layout = latam` + Caps como Escape (HyDE viene en `us`). |
| **Bordes monocromáticos** | Borde activo blanco con gradiente, inactivo casi invisible — la firma del estilo. |
| **Glass / decoración** | `blur` 4 pasadas, sombras suaves, redondeo 8px, opacidad inactiva 0.92 → el efecto "vidrio". |
| **Gesto de 3 dedos** | `gesture = 3, horizontal, workspace` (sintaxis 0.51+). |
| **Apps propias** | `SUPER+E` thunar, `SUPER+SHIFT+E` yazi, `SUPER+B` firefox (override de los binds de HyDE). |
| **Window rules** | Diálogos flotantes (pavucontrol, blueman, nm-connection-editor, file-roller, diálogos de Thunar), en sintaxis 0.55. |

### 🖥️ Configs portadas (tus dotfiles de siempre)

| Archivo | Destino | Descripción |
|---------|---------|-------------|
| **kitty** `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` | Terminal GPU. Monocromático fijo (negro/grises, fuente JetBrainsMono NF, opacidad 0.82 + blur). *Reemplaza* el de HyDE a propósito. |
| **starship** `starship/starship.toml` | `~/.config/starship.toml` | Prompt minimalista monocromático. |
| **tmux** `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` + `~/.tmux.conf` | Multiplexor: prefix `C-Space`, navegación vi, clipboard Wayland, status bar monocromática. |
| **zsh** `zsh/user.zsh` | `~/.config/zsh/user.zsh` | Tus aliases y funciones. Se *engancha* en `~/.zshrc` (no lo reemplaza). Incluye `EZA_COLORS` monocromático y el init de **atuin**. |

### 🎨 Ricing por aplicación — `cachyos/ricing/`

| App / tool | Qué es | Qué le hacemos |
|------------|--------|----------------|
| **Spicetify** | Modder de Spotify (CLI). | Lo instala + Marketplace. Tema **Bloom** esquema `darkmono` (monocromático). *(2 clics en el Marketplace)*. |
| **Vesktop** | Cliente de Discord con **Vencord** integrado; mejor en Wayland. | Lo instala. Tema **VenTrans** (glass translúcido) + *Enable Window Transparency* → se ve el blur de Hyprland a través. |
| **Firefox userChrome** | CSS que reestiliza la UI del navegador. | `userChrome.css` glossy: tabs slim, urlbar tipo glass, todo oscuro con acento blanco. Autodetecta el perfil y habilita userChrome solo. |
| **fastfetch** | Info del sistema al estilo neofetch. | Config monocromática (`config.jsonc`) con keys blancas. |
| **CAVA** | Visualizer de audio en terminal. | Config con gradiente **gris → blanco** (sin colores). Se abre con `cava`. |

### ✨ Extras automatizados (monocromáticos)

| Tool | Qué es | Qué le hacemos |
|------|--------|----------------|
| **Neovim transparente** | Tu LazyVim. | Plugin que fuerza fondo transparente en cada cambio de tema → se ve el blur de kitty a través del editor. |
| **yazi** | File manager de terminal (Rust). | `theme.toml` monocromático: archivos gris, directorios blanco, sin colores por tipo. |
| **git-delta** | Pager de diffs para git. | Diffs **sin colores**: +/− se distinguen por brillo de gris; cabeceras y números en blanco/gris. Enganchado vía `include` en `~/.gitconfig`. |
| **atuin** | Historial de shell con TUI fuzzy (Ctrl-R). | TUI compacta y oscura (toma los colores de kitty). Init en `user.zsh`, sin sync. |
| **btop** | Monitor de sistema. | Tema `monochrome` (todos los gradientes gris → blanco). |
| **eza** | `ls` moderno. | `EZA_COLORS` monocromático: grises para todo, blanco para dirs/ejecutables. |

> **Quitados a propósito** (no son dark-glossy-white): pokemon/shell-color-scripts
> (colorido) y MangoHud (overlay de gaming).

Detalle por app: `cachyos/ricing/README.md`, `cachyos/ricing/discord/README.md`,
`cachyos/ricing/firefox/README.md`.

---

## El mecanismo de override de HyDE

HyDE carga su config en este orden:

```
core de HyDE  →  keybindings.conf  →  windowrules.conf  →  monitors.conf  →  userprefs.conf  →  workflows.conf
```

Como `userprefs.conf` va casi al final, **todo lo que pongas ahí gana**: binds,
decoración, input, reglas de ventana. Por eso metimos todos los cambios de
Hyprland en ese único archivo y no tocamos los que HyDE administra (`themes/`,
`hyde.conf`).

---

## Personalizar

- **Ver todos los atajos de HyDE:** `SUPER + /` (cheatsheet en pantalla).
- **Agregar un bind propio** en `userprefs.conf`:
  ```
  bind = $mainMod, T, exec, telegram-desktop
  ```
- **Bordes que sigan el tema** (en vez de blanco): borrá las dos líneas
  `col.active_border` / `col.inactive_border` del bloque `general`.
- **Kitty siguiendo el tema de HyDE** (en vez de tu monocromático): comentá la
  línea de kitty en `apply.sh` y dejá que HyDE lo maneje.
- **Wallpapers:** los maneja HyDE (`SUPER + SHIFT + W`). No usamos `swww` directo
  para no chocar con su motor.
- **Después de editar `userprefs.conf`:** `hyprctl reload` o `SUPER + SHIFT + R`.

---

## Notas / caveats

- **Hyprland 0.55+** dejó `hyprlang` (el formato `.conf`) como *deprecado* en
  favor de Lua, pero **sigue funcionando**. HyDE todavía usa `.conf`. Cuando HyDE
  migre a Lua, se adapta.
- La sintaxis de `windowrule`/`layerrule` de este repo es la **nueva** (0.55):
  `windowrule = float true, match:class ^(...)$`. La vieja con comas ya no parsea.
- **eza**: `EZA_COLORS` tiene prioridad sobre cualquier `theme.yml`, así que el
  monocromático queda garantizado.
- **yazi**: el schema actual usa `[mgr]`; si tu versión avisa, renombralo a
  `[manager]` en `yazi/theme.toml`.
- **git-delta**: se engancha apuntando a este repo (`include.path`). Si movés el
  repo, recorré el instalador de ricing.
- **nvim transparente**: necesita kitty con opacidad < 1 (ya la tenés) para que
  se note el glass.
- Si venías del setup de Arch puro de este repo (`install.sh` / `post-install.sh`
  en `main`), **no los uses acá**: CachyOS ya trae drivers/AUR y HyDE el resto.
  Esta branch `cachyos` es self-contained.

---

## Orden rápido (TL;DR)

```bash
# 1. Instalar HyDE
git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
cd ~/HyDE/Scripts && ./install.sh          # reiniciar al terminar

# 2. (Opcional) elegir tema dark
hydectl theme import

# 3. Clonar este repo y aplicar todo
git clone -b cachyos https://github.com/LeivurGargiulo/archlinux-dotfiles.git ~/archlinux-dotfiles
cd ~/archlinux-dotfiles
bash cachyos/apply.sh                       # overrides dark glossy
bash cachyos/ricing/install-ricing.sh       # rice por-app + extras
```
