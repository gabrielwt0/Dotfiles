#!/usr/bin/env bash
# ~/dotfiles/sync.sh — copia as configs do sistema para o repositório
set -euo pipefail
cd "$(dirname "$0")"

copia() {
    local origem="$1" destino="$2"
    if [ -e "$origem" ]; then
        mkdir -p "$destino"
        cp -r "$origem" "$destino/"
        printf '  ok  %s\n' "$origem"
    else
        printf '  --  %s (não existe)\n' "$origem"
    fi
}

echo "sincronizando..."

# Sway
copia ~/.config/sway/config              sway
copia ~/.config/sway/config.d            sway

# Waybar
copia ~/.config/waybar/config.jsonc      waybar
copia ~/.config/waybar/style.css         waybar
copia ~/.config/waybar/tuned.sh          waybar

# Terminal e shell
copia ~/.config/alacritty/alacritty.toml alacritty
copia ~/.zshrc                           zsh
copia ~/.config/starship.toml            starship

# Doom Emacs (gcal.el fica de fora pelo .gitignore)
copia ~/.config/doom/init.el             doom
copia ~/.config/doom/config.el           doom
copia ~/.config/doom/packages.el         doom

# Flags de apps Electron
copia ~/.config/code-flags.conf          apps
copia ~/.config/spotify-flags.conf       apps

# VS Code
copia ~/.config/Code/User/settings.json       vscode
copia ~/.config/Code/User/snippets/latex.json vscode/snippets
if command -v code >/dev/null 2>&1; then
    code --list-extensions > vscode/extensions.txt
    printf '  ok  vscode/extensions.txt (gerado)\n'
fi

# KDE (Plasma, sem Sway) — Konsole e env de sessão
copia ~/.local/share/konsole/Shell.profile kde/konsole
copia ~/.config/environment.d/10-shell.conf kde/environment.d

# Neovim (LazyVim) — só o config (~/.config/nvim); plugins/dados ficam em
# ~/.local/share/nvim, fora do repo
rm -rf nvim
mkdir -p nvim
cp -r ~/.config/nvim/. nvim/
printf '  ok  ~/.config/nvim\n'

echo
git add -A
git status -sb
