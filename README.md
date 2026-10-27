# dotfiles

Configuración de mi sistema (Ubuntu/GNOME y macOS).

### Ghostty

- `F12`: muestra/oculta Ghostty estilo guake (arriba, ancho completo, mitad de alto) en el monitor del mouse.
- `F11`: maximiza / restaura.
- zsh como shell de Ghostty, con Oh My Zsh + powerlevel10k (+ autosuggestions y syntax-highlighting).
- Barra de tabs compacta con botón `+`, fondo al 80% (`ghostty/tabs.css`).

### Neovim

- Neovim + LazyVim (starter), con ripgrep, fd y lazygit.

## Linux (Ubuntu/GNOME)

```sh
./install.sh
```

Después cerrar sesión y volver a entrar (la extensión GNOME no se recarga en Wayland).

## macOS

```sh
./install-macos.sh
```

Instala con Homebrew. F12 usa el quick terminal nativo de Ghostty (`ghostty/macos.ghostty`): hay que darle permiso de Accesibilidad a Ghostty. F11 y la barra de tabs custom (GTK) no aplican en macOS.

## Contenido

- `ghostty/config.ghostty`, `ghostty/tabs.css` → `~/.config/ghostty/`
- `zsh/setup.sh`: Oh My Zsh + powerlevel10k + plugins (compartido)
- `zsh/.p10k.zsh` → `~/.p10k.zsh` (el `.zshrc` se genera desde el template de Oh My Zsh)
- `extension/pointer-dbus@mnicolas` → extensión GNOME que expone `ToggleGhostty` por DBus (y la posición del mouse, usada también por guake)
