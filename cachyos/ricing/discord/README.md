# Discord — Vesktop + tema glass

En Wayland/Hyprland conviene **Vesktop** (un cliente de Discord con **Vencord**
ya integrado): mejor soporte Wayland, screenshare que funciona, y transparencia
real para temas glass. `install-ricing.sh` instala `vesktop-bin`.

## Aplicar el tema glass (VenTrans)

1. Abrí **Vesktop**.
2. `Settings → Vencord → Themes → Online Themes`.
3. Pegá esta URL:
   ```
   https://raw.githubusercontent.com/galaxine-senpai/ventrans/main/VenTrans.css
   ```
4. `Settings → Vencord → Enable Window Transparency` → **activar**.
5. Reiniciá Vesktop (cerralo del todo y abrilo de nuevo).

> La transparencia necesita reinicio del cliente para tomar efecto. El blur lo
> pone Hyprland: Vesktop es una capa más, así que el blur de HyDE/Hyprland se ve
> a través de la ventana translúcida.

## Alternativas de tema

- **[Vencord Themes oficiales](https://github.com/Vencord/Themes)** — repo curado.
- **[SEELE1306/CSS-Snippets](https://github.com/SEELE1306/CSS-Snippets)** — snippets sueltos (QuickCSS).
- Para algo monocromático, buscá temas "amoled"/"midnight" y ajustá el acento a blanco.

## ¿Preferís parchear el Discord normal?

Si ya usás el cliente oficial y no querés Vesktop:

```bash
sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
```

…pero en Wayland Vesktop da menos dolores de cabeza.
