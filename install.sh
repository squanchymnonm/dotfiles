#!/usr/bin/env bash
# Deja Ghostty configurado: config + CSS, fuente, extensión GNOME y hotkey F12 estilo guake.
set -euo pipefail
cd "$(dirname "$0")"

EXT_UUID=pointer-dbus@mnicolas
KB_PATH=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/
KB_SCHEMA=org.gnome.settings-daemon.plugins.media-keys.custom-keybinding

echo "==> Ghostty"
if ! command -v ghostty >/dev/null; then
    sudo apt-get update && sudo apt-get install -y ghostty
fi

echo "==> zsh + Oh My Zsh + powerlevel10k"
if ! command -v zsh >/dev/null; then
    sudo apt-get install -y zsh
fi
if [ ! -d ~/.oh-my-zsh ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZC="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ -d "$ZC/themes/powerlevel10k" ] || git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZC/themes/powerlevel10k"
[ -d "$ZC/plugins/zsh-autosuggestions" ] || git clone -q --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZC/plugins/zsh-autosuggestions"
[ -d "$ZC/plugins/zsh-syntax-highlighting" ] || git clone -q --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZC/plugins/zsh-syntax-highlighting"

if ! grep -q 'oh-my-zsh.sh' ~/.zshrc 2>/dev/null; then
    [ -e ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bak
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
fi
sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc
sed -i 's|^plugins=(git)$|plugins=(git zsh-autosuggestions zsh-syntax-highlighting)|' ~/.zshrc
if ! grep -q 'p10k-instant-prompt' ~/.zshrc; then
    cat - ~/.zshrc > ~/.zshrc.tmp <<'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

EOF
    mv ~/.zshrc.tmp ~/.zshrc
fi
grep -q 'source ~/.p10k.zsh' ~/.zshrc || echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
[ -e ~/.p10k.zsh ] && ! cmp -s zsh/.p10k.zsh ~/.p10k.zsh && cp ~/.p10k.zsh ~/.p10k.zsh.bak
cp zsh/.p10k.zsh ~/.p10k.zsh

echo "==> Fuente JetBrainsMono Nerd Font"
if ! fc-list | grep -q "JetBrainsMono Nerd Font"; then
    dir="$HOME/.local/share/fonts/JetBrainsMono"
    tmp=$(mktemp -d)
    curl -fsSL -o "$tmp/f.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    mkdir -p "$dir" && unzip -oq "$tmp/f.zip" -d "$dir" && rm -rf "$tmp"
    fc-cache -f >/dev/null
fi

echo "==> Config de Ghostty"
mkdir -p ~/.config/ghostty
for f in config.ghostty tabs.css; do
    [ -e ~/.config/ghostty/$f ] && cp ~/.config/ghostty/$f ~/.config/ghostty/$f.bak
done
sed "s|__HOME__|$HOME|" ghostty/config.ghostty > ~/.config/ghostty/config.ghostty
cp ghostty/tabs.css ~/.config/ghostty/tabs.css

echo "==> Extensión GNOME ($EXT_UUID)"
mkdir -p ~/.local/share/gnome-shell/extensions
cp -r "extension/$EXT_UUID" ~/.local/share/gnome-shell/extensions/
enabled=$(gsettings get org.gnome.shell enabled-extensions)
if [[ $enabled != *"'$EXT_UUID'"* ]]; then
    if [[ $enabled == "@as []" || $enabled == "[]" ]]; then
        gsettings set org.gnome.shell enabled-extensions "['$EXT_UUID']"
    else
        gsettings set org.gnome.shell enabled-extensions "${enabled%]}, '$EXT_UUID']"
    fi
fi

echo "==> Hotkey F12"
gsettings set $KB_SCHEMA:$KB_PATH name 'Ghostty toggle'
gsettings set $KB_SCHEMA:$KB_PATH command 'gdbus call --session -d org.mnicolas.Pointer -o /org/mnicolas/Pointer -m org.mnicolas.Pointer.ToggleGhostty'
gsettings set $KB_SCHEMA:$KB_PATH binding 'F12'
kbs=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
if [[ $kbs != *"'$KB_PATH'"* ]]; then
    if [[ $kbs == "@as []" || $kbs == "[]" ]]; then
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$KB_PATH']"
    else
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${kbs%]}, '$KB_PATH']"
    fi
fi

echo
echo "Listo. Cerrá sesión y volvé a entrar para que GNOME cargue la extensión."
echo "Si la versión de GNOME no es la 50, agregala en shell-version de metadata.json."
