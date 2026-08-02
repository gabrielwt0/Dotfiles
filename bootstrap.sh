#!/usr/bin/env bash
# ~/dotfiles/bootstrap.sh — instala pacotes de sistema e extensões que o restore.sh não cobre
# (restore.sh só copia arquivos de config; este script instala software).
set -euo pipefail
cd "$(dirname "$0")"

echo "instalando VS Code (se necessário)..."
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

echo "instalando pacotes LaTeX (system/texlive-packages.txt)..."
sudo dnf install -y $(grep -v '^\s*#' system/texlive-packages.txt)

echo "instalando extensões do VS Code (vscode/extensions.txt)..."
while read -r ext; do
    [ -z "$ext" ] && continue
    code --install-extension "$ext" --force
done < vscode/extensions.txt

echo
echo "bootstrap concluído. Rode ./restore.sh se ainda não rodou."
