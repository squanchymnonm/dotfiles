#!/usr/bin/env bash
# Versión macOS: Ghostty + config, fuente, zsh + Oh My Zsh + powerlevel10k, quick terminal con F12.
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Homebrew"
if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi

echo "==> Ghostty"
[ -d /Applications/Ghostty.app ] || brew install --cask ghostty

echo "==> zsh + Oh My Zsh + powerlevel10k"
command -v zsh >/dev/null || brew install zsh
bash zsh/setup.sh

echo "==> Fuente JetBrainsMono Nerd Font"
if ! ls ~/Library/Fonts /Library/Fonts 2>/dev/null | grep -q "JetBrainsMonoNerdFont"; then
    brew install --cask font-jetbrains-mono-nerd-font
fi

echo "==> Config de Ghostty"
mkdir -p ~/.config/ghostty
[ -e ~/.config/ghostty/config.ghostty ] && cp ~/.config/ghostty/config.ghostty ~/.config/ghostty/config.ghostty.bak
# las opciones gtk-* se ignoran en macOS; F12 usa el quick terminal nativo
sed "s|__HOME__|$HOME|" ghostty/config.ghostty | cat - ghostty/macos.ghostty > ~/.config/ghostty/config.ghostty

echo
echo "Listo. Abrí Ghostty y dale permiso de Accesibilidad"
echo "(Ajustes del Sistema > Privacidad y seguridad > Accesibilidad) para que F12 funcione global."
echo "Si F12 está tomada por el sistema, activá 'Usar F1, F2, etc. como teclas de función estándar'."
