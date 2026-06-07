# Ricing add-ons — sobre HyDE / CachyOS

Capa de "rice por aplicación" y eyecandy que vive **encima** de HyDE sin tocar
lo que HyDE administra (barra, launcher, notificaciones, lockscreen, wallpaper,
motor de temas). Todo dark glossy / monochrome.

## Instalar

```bash
cd ~/archlinux-dotfiles
git checkout cachyos
bash cachyos/ricing/install-ricing.sh
```

Es resiliente: si un paquete del AUR falla, sigue con el resto y te avisa.

## Qué incluye

| Área | Qué hace | Manual restante |
|------|----------|-----------------|
| **Terminal** | `fastfetch` (config monocromática), **CAVA** (visualizer), `shell-color-scripts` + `pokemon-colorscripts` al abrir la shell | — |
| **Spotify** | **Spicetify** + Marketplace | Marketplace → instalar **Bloom**, esquema `darkmono` |
| **Discord** | **Vesktop** (Discord + Vencord, ideal Wayland) | Online theme **VenTrans** + Enable Window Transparency |
| **Firefox** | `userChrome.css` glossy + compacto, perfil autodetectado | reiniciar Firefox |

Detalle por app: ver `discord/README.md` y `firefox/README.md`.

---

## Extras (ideas para seguir puliendo)

No los automaticé para no inflar el script, pero son ganadores y fáciles:

- **Neovim transparente** (tu LazyVim): en tu config de colorscheme,
  ```lua
  vim.cmd [[ hi Normal guibg=NONE ctermbg=NONE ]]
  vim.cmd [[ hi NormalNC guibg=NONE ctermbg=NONE ]]
  ```
  así el blur de kitty se ve a través del editor.
- **yazi flavor oscuro**: `ya pack -a yazi-rs/flavors:dracula` (o el que quieras) y
  setealo en `~/.config/yazi/theme.toml`.
- **delta** para diffs lindos: `pacman -S git-delta` + en `~/.gitconfig`:
  `[core] pager = delta` · `[delta] dark = true  line-numbers = true`.
- **atuin**: historial de shell con TUI oscura — `pacman -S atuin && atuin import auto`.
- **vivid**: `LS_COLORS` coherentes — `pacman -S vivid` y en zsh
  `export LS_COLORS="$(vivid generate ...)"`.
- **btop tema**: poné un theme monocromático en `~/.config/btop/themes/`.
- **MangoHud** (gaming): overlay de FPS glossy — `pacman -S mangohud`.
- **Wallpapers**: dejá tus fondos dark en `~/Pictures/Wallpapers/` y usalos desde
  el selector de HyDE (`SUPER + SHIFT + W`).

¿Querés que automatice alguno de estos también? Decime cuál y lo agrego acá.
