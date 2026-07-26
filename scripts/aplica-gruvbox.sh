#!/usr/bin/env bash
# aplica-gruvbox.sh — troca as cores do Sway e do Doom para Gruvbox Dark
set -euo pipefail

SWAY=~/.config/sway/config
DOOM=~/.config/doom/config.el

echo "fazendo backup..."
cp "$SWAY" "$SWAY.bak-$(date +%Y%m%d-%H%M)"
[ -f "$DOOM" ] && cp "$DOOM" "$DOOM.bak-$(date +%Y%m%d-%H%M)"

echo "sway: fundo e cores das janelas..."

# fundo sólido
sed -i 's|^output \* bg .*|output * bg #1d2021 solid_color|' "$SWAY"

# swaylock com a mesma cor
sed -i 's|swaylock -f -c [0-9a-fA-F]*|swaylock -f -c 1d2021|g' "$SWAY"

# paleta das bordas: classe  borda   fundo   texto   indicador  borda-filho
sed -i 's|^client.focused  .*|client.focused           #d79921  #1d2021  #ebdbb2  #d79921    #d79921|' "$SWAY"
sed -i 's|^client.focused_inactive.*|client.focused_inactive  #3c3836  #1d2021  #a89984  #3c3836    #3c3836|' "$SWAY"
sed -i 's|^client.unfocused.*|client.unfocused         #3c3836  #1d2021  #665c54  #3c3836    #3c3836|' "$SWAY"
sed -i 's|^client.urgent.*|client.urgent            #cc241d  #1d2021  #ebdbb2  #cc241d    #cc241d|' "$SWAY"

echo "doom: tema..."
if [ -f "$DOOM" ]; then
    sed -i "s|^(setq doom-theme .*|(setq doom-theme 'doom-gruvbox)|" "$DOOM"
fi

echo
echo "validando o sway..."
if sway --validate --config "$SWAY"; then
    echo "ok — rode: swaymsg reload"
else
    echo "ERRO na config. Restaure com:"
    echo "  cp $SWAY.bak-* $SWAY"
    exit 1
fi
