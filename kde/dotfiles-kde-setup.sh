#!/usr/bin/env bash
# One-shot sudo bundle to finish importing gabrielwt0/Dotfiles onto Fedora KDE.
# Everything not requiring root (starship, fonts, doom framework clone, all
# config files) has already been done by Claude. Run this script directly:
#   bash ~/dotfiles-kde-setup.sh
set -euo pipefail

echo "==> installing packages (zsh, terminal/shell tooling, emacs + doom deps, qt6ct, R)"
sudo dnf install -y \
    zsh alacritty eza fzf \
    zsh-autosuggestions zsh-syntax-highlighting \
    qt6ct \
    emacs ripgrep fd-find git-core \
    R mariadb-server

echo "==> enabling MariaDB (used by local dev projects, e.g. ferro)"
sudo systemctl enable --now mariadb

echo "==> installing VS Code"
if ! command -v code >/dev/null 2>&1; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
    sudo dnf install -y code
else
    echo "  -- code already installed"
fi

echo "==> installing LaTeX toolchain (system/texlive-packages.txt)"
sudo dnf install -y $(grep -v '^\s*#' ~/dotfiles/system/texlive-packages.txt)

echo "==> installing VS Code extensions (vscode/extensions.txt)"
while read -r ext; do
    [ -z "$ext" ] && continue
    code --install-extension "$ext" --force
done < ~/dotfiles/vscode/extensions.txt

echo "==> setting zsh as default shell"
chsh -s "$(which zsh)"

cat <<'EOF'

Done. Two things left, both interactive so not automated here:

  1. Doom Emacs (framework already cloned to ~/.config/emacs, configs already
     in ~/.config/doom/):
       ~/.config/emacs/bin/doom install
       ~/.config/emacs/bin/doom sync

  2. Google Calendar in Doom (not versioned, has a secret iCal URL):
       recreate ~/.config/doom/gcal.el yourself

Log out/in (or reboot) to pick up the zsh shell change and Qt theming.
EOF
