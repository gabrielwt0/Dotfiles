#!/usr/bin/env bash
# ~/dotfiles/restore.sh — copia as configs do repositório para o sistema
# Faz backup do que já existir antes de sobrescrever.
set -euo pipefail
cd "$(dirname "$0")"

STAMP=$(date +%Y%m%d-%H%M)

restaura() {
    local origem="$1" destino="$2"
    if [ ! -e "$origem" ]; then
        printf '  --  %s (não está no repo)\n' "$origem"
        return
    fi
    mkdir -p "$(dirname "$destino")"
    if [ -e "$destino" ]; then
        mv "$destino" "$destino.bak-$STAMP"
        printf '  bkp %s → %s.bak-%s\n' "$destino" "$destino" "$STAMP"
    fi
    cp -r "$origem" "$destino"
    printf '  ok  %s\n' "$destino"
}

# Detecta a sessão atual para não jogar config de Sway/Waybar/Konsole numa
# máquina GNOME (inofensivo, mas suja o ~/.config com arquivo que nada lê)
DE_ATUAL="${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}"
IS_GNOME=0
case "${DE_ATUAL,,}" in
    *gnome*) IS_GNOME=1 ;;
esac

echo "restaurando configs..."

if [ "$IS_GNOME" -eq 0 ]; then
    restaura sway/config                ~/.config/sway/config
    restaura sway/config.d              ~/.config/sway/config.d
    restaura waybar/config.jsonc        ~/.config/waybar/config.jsonc
    restaura waybar/style.css           ~/.config/waybar/style.css
    restaura waybar/tuned.sh            ~/.config/waybar/tuned.sh
    restaura kde/konsole/Shell.profile  ~/.local/share/konsole/Shell.profile
else
    printf '  --  sway/waybar/konsole (sessão GNOME detectada, pulando)\n'
fi

restaura alacritty/alacritty.toml   ~/.config/alacritty/alacritty.toml
restaura zsh/.zshrc                 ~/.zshrc
restaura starship/starship.toml     ~/.config/starship.toml
restaura doom/init.el               ~/.config/doom/init.el
restaura doom/config.el             ~/.config/doom/config.el
restaura doom/packages.el           ~/.config/doom/packages.el
restaura apps/code-flags.conf       ~/.config/code-flags.conf
restaura apps/spotify-flags.conf    ~/.config/spotify-flags.conf
restaura vscode/settings.json       ~/.config/Code/User/settings.json
restaura vscode/snippets/latex.json ~/.config/Code/User/snippets/latex.json

# ~/.config/environment.d é lido pelo systemd --user em qualquer DE, não só KDE
restaura kde/environment.d/10-shell.conf ~/.config/environment.d/10-shell.conf

# Neovim (LazyVim) — depois de restaurar, abra o nvim para o lazy.nvim
# instalar os plugins (lazy-lock.json fixa as versões)
restaura nvim ~/.config/nvim

echo
echo "Feito. Passos seguintes:"
echo
if [ "$IS_GNOME" -eq 1 ]; then
    echo "  1. Instale os pacotes e extensões:"
    echo "       ./gnome/dotfiles-gnome-setup.sh"
else
    echo "  1. Instale os pacotes e extensões:"
    echo "       ./bootstrap.sh   (ou ./kde/dotfiles-kde-setup.sh numa máquina KDE)"
fi
cat <<'EOF'

  2. Doom Emacs:
       git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
       ~/.config/emacs/bin/doom install
       doom sync

  3. Google Calendar (não versionado):
       recrie ~/.config/doom/gcal.el com a URL secreta do iCal

  4. Shell padrão:
       chsh -s $(which zsh)
EOF
if [ "$IS_GNOME" -eq 0 ]; then
    cat <<'EOF'

  5. Valide e recarregue o Sway (se estiver usando):
       sway --validate --config ~/.config/sway/config
       swaymsg reload
EOF
fi
