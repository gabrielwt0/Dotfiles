#!/usr/bin/env bash
# ~/dotfiles/gnome/dotfiles-gnome-setup.sh — bootstrap de pacotes para Fedora GNOME Workstation
# Espelha kde/dotfiles-kde-setup.sh, mas sem as partes específicas de KDE/Qt
# (qt6ct, Konsole) que não fazem sentido numa sessão GNOME/GTK. Roda depois do
# ./restore.sh (que só copia arquivos de config, não instala nada). Precisa de
# sudo interativo, por isso não é chamado automaticamente por restore.sh:
#   bash gnome/dotfiles-gnome-setup.sh
set -euo pipefail

echo "==> instalando pacotes (zsh, terminal/shell, emacs + deps do doom, R)"
sudo dnf install -y \
    zsh alacritty eza fzf \
    zsh-autosuggestions zsh-syntax-highlighting \
    emacs ripgrep fd-find git-core \
    R mariadb-server

echo "==> habilitando o MariaDB (usado por projetos locais, ex. ferro)"
sudo systemctl enable --now mariadb

echo "==> instalando o VS Code"
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
    printf '  --  code já instalado\n'
fi

echo "==> instalando pacotes LaTeX (system/texlive-packages.txt)"
sudo dnf install -y $(grep -v '^\s*#' ~/dotfiles/system/texlive-packages.txt)

echo "==> instalando extensões do VS Code (vscode/extensions.txt)"
while read -r ext; do
    [ -z "$ext" ] && continue
    code --install-extension "$ext" --force
done < ~/dotfiles/vscode/extensions.txt

echo "==> definindo zsh como shell padrão"
chsh -s "$(which zsh)"

echo "==> ajustes de aparência do GNOME (tema escuro + Alacritty nos favoritos)"
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
    if command -v alacritty >/dev/null 2>&1; then
        atual=$(gsettings get org.gnome.shell favorite-apps)
        if [[ "$atual" != *"Alacritty.desktop"* ]]; then
            gsettings set org.gnome.shell favorite-apps \
                "$(echo "$atual" | sed "s/]$/, 'Alacritty.desktop']/")" || true
        fi
    fi
else
    printf '  --  gsettings não encontrado, pulando ajustes de aparência\n'
fi

cat <<'EOF'

Feito. Duas coisas ficam de fora por serem interativas:

  1. Doom Emacs (framework ainda não clonado):
       git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
       ~/.config/emacs/bin/doom install
       doom sync

  2. Google Calendar no Doom (não versionado, tem URL secreta):
       recrie ~/.config/doom/gcal.el você mesmo

Deps extras dos módulos do Doom (cmake, aspell, direnv, etc.) estão em
../kde/dotfiles-doom-doctor-fixes.sh — apesar do nome/pasta, é agnóstico de
desktop environment, roda igual aqui:
  bash ../kde/dotfiles-doom-doctor-fixes.sh

Faça logout/login (ou reboot) para o shell zsh e o tema escuro pegarem.
EOF
