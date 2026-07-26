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

echo "restaurando configs..."

restaura sway/config                ~/.config/sway/config
restaura sway/config.d              ~/.config/sway/config.d
restaura waybar/config.jsonc        ~/.config/waybar/config.jsonc
restaura waybar/style.css           ~/.config/waybar/style.css
restaura alacritty/alacritty.toml   ~/.config/alacritty/alacritty.toml
restaura zsh/.zshrc                 ~/.zshrc
restaura starship/starship.toml     ~/.config/starship.toml
restaura doom/init.el               ~/.config/doom/init.el
restaura doom/config.el             ~/.config/doom/config.el
restaura doom/packages.el           ~/.config/doom/packages.el
restaura apps/code-flags.conf       ~/.config/code-flags.conf
restaura apps/spotify-flags.conf    ~/.config/spotify-flags.conf
restaura waybar/tuned.sh            ~/.config/waybar/tuned.sh

cat <<'EOF'

Feito. Passos seguintes:

  1. Instale os pacotes:
       ./bootstrap.sh          (se existir)

  2. Doom Emacs:
       git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
       ~/.config/emacs/bin/doom install
       doom sync

  3. Google Calendar (não versionado):
       recrie ~/.config/doom/gcal.el com a URL secreta do iCal

  4. Shell padrão:
       chsh -s $(which zsh)

  5. Valide e recarregue:
       sway --validate --config ~/.config/sway/config
       swaymsg reload
EOF
