# ghostty-config

Mi Ghostty en Ubuntu/GNOME (Wayland):

- `F12`: muestra/oculta Ghostty estilo guake (arriba, ancho completo, mitad de alto) en el monitor del mouse.
- `F11`: maximiza / restaura.
- zsh como shell de Ghostty, con Oh My Zsh + powerlevel10k (+ autosuggestions y syntax-highlighting).
- Barra de tabs compacta con botón `+`, fondo al 80% (`ghostty/tabs.css`).

```sh
./install.sh
```

Después cerrar sesión y volver a entrar (la extensión GNOME no se recarga en Wayland).

## Contenido

- `ghostty/config.ghostty`, `ghostty/tabs.css` → `~/.config/ghostty/`
- `zsh/.p10k.zsh` → `~/.p10k.zsh` (el `.zshrc` se genera desde el template de Oh My Zsh)
- `extension/pointer-dbus@mnicolas` → extensión GNOME que expone `ToggleGhostty` por DBus (y la posición del mouse, usada también por guake)
