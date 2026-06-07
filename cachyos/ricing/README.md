# Ricing add-ons — dark glossy · white

Capa de "rice por aplicación" + extras, **todo monocromático (negro/grises +
acento blanco)**, que vive **encima** de HyDE sin tocar lo que HyDE administra
(barra, launcher, notificaciones, lockscreen, wallpaper, motor de temas).

## Instalar (automatiza todo lo posible)

```bash
cd ~/archlinux-dotfiles
git checkout cachyos
bash cachyos/ricing/install-ricing.sh
```

Es resiliente: si un paquete del AUR falla, sigue con el resto y te avisa.

## Qué hace

| Área | Automatizado | Manual restante |
|------|--------------|-----------------|
| **Terminal** | `fastfetch` (config monocromática) + **CAVA** (visualizer gris→blanco) | — |
| **Spotify** | **Spicetify** + Marketplace | Marketplace → **Bloom**, esquema `darkmono` |
| **Discord** | **Vesktop** (Discord + Vencord, ideal Wayland) | Online theme **VenTrans** + Enable Window Transparency |
| **Firefox** | `userChrome.css` glossy, perfil autodetectado + `user.js` | reiniciar Firefox |
| **Neovim** | **Transparente** (LazyVim) → se ve el blur de kitty a través | — |
| **yazi** | Tema monocromático (`theme.toml`) | — |
| **git** | **delta** con diffs monocromáticos (enganchado en `~/.gitconfig`) | — |
| **atuin** | Historial con TUI oscura (Ctrl-R), init en `user.zsh` | shell nueva |
| **btop** | Tema `monochrome` aplicado | — |
| **eza/ls** | `EZA_COLORS` monocromático (grises + dirs/exec blancos) | — |

Detalle por app: ver `discord/README.md` y `firefox/README.md`.

> **Quitados a propósito** (no son dark-glossy-white): pokemon/shell-color-scripts
> (colorido) y MangoHud (overlay de gaming).

---

## Archivos

```
ricing/
├── install-ricing.sh      # instala y aplica TODO
├── fastfetch/config.jsonc # monocromático
├── cava/config            # visualizer gris → blanco
├── firefox/userChrome.css # glass minimal + README
├── discord/README.md      # Vesktop + VenTrans
├── nvim/transparent.lua   # → ~/.config/nvim/lua/plugins/
├── yazi/theme.toml        # monocromático (sección [mgr])
├── git/delta.gitconfig    # diffs monocromáticos (include)
├── atuin/config.toml      # TUI compacta oscura
└── btop/monochrome.theme  # → ~/.config/btop/themes/
```

## Notas / caveats

- **eza**: `EZA_COLORS` (en `user.zsh`) tiene prioridad sobre cualquier
  `theme.yml`, así que el monocromático queda garantizado.
- **yazi**: el schema actual usa `[mgr]`. Si tu versión avisa, renombralo a
  `[manager]` en `yazi/theme.toml`.
- **delta**: se engancha vía `git config --global include.path` apuntando a este
  repo. Si movés el repo, recorré el instalador.
- **nvim transparente**: requiere que kitty tenga opacidad < 1 (ya la tenés en
  `kitty.conf`) para que se note el "glass".
