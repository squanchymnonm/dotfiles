#!/usr/bin/env bash
# Oh My Zsh + powerlevel10k + plugins. Requiere zsh, git y curl. Compartido entre Linux y macOS.
set -euo pipefail
cd "$(dirname "$0")"

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
perl -pi -e 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc
perl -pi -e 's|^plugins=\(git\)$|plugins=(git zsh-autosuggestions zsh-syntax-highlighting)|' ~/.zshrc
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
if [ -e ~/.p10k.zsh ] && ! cmp -s .p10k.zsh ~/.p10k.zsh; then
    cp ~/.p10k.zsh ~/.p10k.zsh.bak
fi
cp .p10k.zsh ~/.p10k.zsh
