#!/usr/bin/env bash
cd "$(dirname "$0")"
cp ~/.config/sway/config              sway/
cp ~/.config/waybar/config.jsonc      waybar/
cp ~/.config/waybar/style.css         waybar/
cp ~/.config/alacritty/alacritty.toml alacritty/
cp ~/.zshrc                           zsh/
cp ~/.config/starship.toml            starship/ 2>/dev/null
git add -A && git status -sb
