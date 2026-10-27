# ghostty-setup

Mi Ghostty en Ubuntu/GNOME (Wayland):

- `F12`: muestra/oculta Ghostty estilo guake (arriba, ancho completo, mitad de alto) en el monitor del mouse.
- `F11`: maximiza / restaura.
- Barra de tabs compacta con botón `+`, fondo al 80% (`ghostty/tabs.css`).

```sh
./install.sh
```

Después cerrar sesión y volver a entrar (la extensión GNOME no se recarga en Wayland).

## Contenido

- `ghostty/config.ghostty`, `ghostty/tabs.css` → `~/.config/ghostty/`
- `extension/pointer-dbus@mnicolas` → extensión GNOME que expone `ToggleGhostty` por DBus (y la posición del mouse, usada también por guake)
