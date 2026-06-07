# Firefox — userChrome glossy

`install-ricing.sh` ya hace esto por vos, pero acá está el paso a mano por si tu
perfil no se detectó (Firefox tiene que haberse abierto al menos una vez).

## 1. Habilitar userChrome

`about:config` → buscá y poné en `true`:

```
toolkit.legacyUserProfileCustomizations.stylesheets = true
svg.context-properties.content.enabled = true
```

## 2. Colocar el CSS

Encontrá tu perfil:

```bash
ls -d ~/.mozilla/firefox/*.default-release
```

Copiá/enlazá el archivo:

```bash
PROF=$(ls -d ~/.mozilla/firefox/*.default-release | head -1)
mkdir -p "$PROF/chrome"
ln -sf "$PWD/userChrome.css" "$PROF/chrome/userChrome.css"
```

Reiniciá Firefox.

## Alternativas pre-armadas (más completas)

Si querés un userChrome más ambicioso en vez de este minimal:

- **[ShyFox](https://github.com/Naezr/ShyFox)** — UI oculta/animada, muy glossy.
- **[Cascade](https://github.com/andreasgrafen/cascade)** — una sola barra, ultra compacto.
- **[Mod-Blur](https://github.com/datguypiko/Firefox-Mod-Blur)** — efecto blur oscuro.

Todos se instalan igual: su `userChrome.css` (y a veces `userContent.css`) en
`<perfil>/chrome/`. Podés combinarlos con las variables de color de acá.

## Bonus: startpage estilo terminal

- **[Excalith Start Page](https://github.com/excalith/excalith-start-page)** — terminal-like, configurable.
- **[dawn](https://github.com/b-coimbra/dawn)** — minimal y oscura.

Ponela como página de inicio/nueva pestaña en Ajustes → Inicio.
