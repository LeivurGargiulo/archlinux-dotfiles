# CachyOS + HyDE — Dark Glossy Glass

Guía para montar el estilo **dark glossy glass · monochrome** sobre
[CachyOS](https://cachyos.org/) usando [**HyDE**](https://github.com/HyDE-Project/HyDE)
como base ya armada, y aplicar encima los toques propios sin pelear con una
config de Hyprland desde cero.

> **Filosofía:** HyDE maneja lo pesado (Hyprland, waybar, rofi, temas, wallpapers,
> lockscreen, idle). Nosotros sólo ponemos un puñado de *overrides* en los
> archivos que HyDE reserva para el usuario, así sobreviven a updates y a
> cambios de tema.

---

## 0. Requisitos

- CachyOS instalado (es Arch optimizado; todo lo de HyDE aplica).
- Tu usuario normal con `sudo`. **Nada de esto se corre como root.**

---

## 1. Instalar CachyOS

En el instalador de CachyOS, elegí el **Desktop = Hyprland** (o una instalación
mínima/CLI si querés que HyDE traiga todo). Cualquiera de las dos sirve: HyDE
instala lo que falte.

> Si ya tenés CachyOS con otro DE, igual podés seguir: HyDE convive, lo elegís
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
- El script detecta NVIDIA solo; en tu AMD usa mesa (ya cubierto por CachyOS).
- Reiniciá al terminar y entrá a la sesión **Hyprland (HyDE)** desde SDDM.

> CachyOS es Arch-based; HyDE está pensado para Arch "puro". Si algún paso del
> instalador se queja, casi siempre es un paquete que CachyOS ya trae con otro
> nombre — seguí y revisá al final. Ante la duda, instalá lo mínimo con
> `./install.sh -i` y después los configs.

---

## 3. Elegir un tema dark glossy

HyDE es temático: cambiás todo el look con un comando. Para el estilo oscuro y
vidrioso, importá/activá un tema dark y después afinamos el “glass” con nuestros
overrides.

```bash
# Elegir entre los temas incluidos:
hydectl theme import        # menú interactivo

# o importar uno puntual por nombre/URL:
hydectl theme import --name "Nombre-Del-Tema" --url "<git-url>"
```

Buenos puntos de partida oscuros: **Catppuccin Mocha**, **Tokyo Night**,
**Gruvbox Material Dark** o cualquiera de la
[hyde-gallery](https://github.com/HyDE-Project/hyde-gallery). Después el paso 4
le mete el blur/translucidez/sombras y los bordes blancos monocromáticos.

---

## 4. Aplicar los overrides de este repo

```bash
git clone https://github.com/LeivurGargiulo/archlinux-dotfiles.git ~/archlinux-dotfiles
cd ~/archlinux-dotfiles
git checkout cachyos
bash cachyos/apply.sh
```

`apply.sh` enlaza (con backup) todo lo de `cachyos/` a su lugar y recarga
Hyprland. Es idempotente: lo podés correr de nuevo sin romper nada.

---

## Qué hace cada cosa

| Archivo | Destino | Para qué |
|---------|---------|----------|
| `hypr/userprefs.conf` | `~/.config/hypr/userprefs.conf` | **El corazón.** HyDE lo carga al final → pisa sus defaults. Acá va: teclado **latam**, bordes blancos monocromáticos, blur/sombras/translucidez (el “glass”), gesto de 3 dedos, tus apps (thunar/yazi/firefox) y reglas de ventana. |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` | Tu kitty monocromático fijo. *Reemplaza* el de HyDE, así que kitty deja de seguir el tema dinámico (a propósito — querías el tuyo). |
| `starship/starship.toml` | `~/.config/starship.toml` | Tu prompt. |
| `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` + `~/.tmux.conf` | Tu tmux (prefix `C-Space`, vi, clipboard Wayland). |
| `zsh/user.zsh` | `~/.config/zsh/user.zsh` | Tus aliases y funciones. Se *engancha* en `~/.zshrc` (no lo reemplaza), así no toca el setup de zsh de HyDE. |

### El mecanismo de override de HyDE

HyDE carga su config en este orden:

```
core de HyDE  →  keybindings.conf  →  windowrules.conf  →  monitors.conf  →  userprefs.conf  →  workflows.conf
```

Como `userprefs.conf` va casi al final, **todo lo que pongas ahí gana**: binds,
decoración, input, reglas de ventana. Por eso metimos todos nuestros cambios de
Hyprland en ese único archivo y no tocamos los que HyDE administra (`themes/`,
`hyde.conf`).

---

## Personalizar

- **Ver todos los atajos de HyDE:** `SUPER + /` (cheatsheet en pantalla).
- **Agregar un bind propio:** copiá el patrón en `userprefs.conf`:
  ```
  bind = $mainMod, T, exec, telegram-desktop
  ```
- **Bordes que sigan el tema** (en vez de blanco monocromático): borrá las dos
  líneas `col.active_border` / `col.inactive_border` del bloque `general` en
  `userprefs.conf`.
- **Kitty siguiendo el tema de HyDE** (en vez de tu monocromático): no enlaces
  `kitty.conf` (comentá esa línea en `apply.sh`) y dejá que HyDE lo maneje.
- **Wallpapers:** los maneja HyDE (`SUPER + SHIFT + W` o su selector). No usamos
  `swww` directo para no chocar con su motor.
- **Después de editar `userprefs.conf`:** `hyprctl reload` o `SUPER + SHIFT + R`.

---

## Notas / caveats

- **Hyprland 0.55+** dejó `hyprlang` (el formato `.conf`) como *deprecado* en
  favor de Lua, pero **sigue funcionando**. HyDE todavía usa `.conf`, así que
  estos overrides están en ese formato. Cuando HyDE migre a Lua, se adapta.
- La sintaxis de `windowrule`/`layerrule` de este repo es la **nueva** (0.55):
  `windowrule = float true, match:class ^(...)$`. La vieja con comas ya no parsea.
- Si venías del setup de Arch puro de este repo (`install.sh` / `post-install.sh`
  en `main`), **no los uses acá**: CachyOS ya trae drivers/AUR y HyDE trae el
  resto. Esta branch `cachyos` es self-contained.
