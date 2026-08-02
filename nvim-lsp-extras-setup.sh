#!/usr/bin/env bash
# Installs Go, needed only so Mason can build the "sqls" LSP server
# (SQL/MariaDB support in nvim). Run as your normal user:
#   bash ~/nvim-lsp-extras-setup.sh
set -euo pipefail

echo "==> installing Go (required to build sqls)"
sudo dnf install -y golang

echo "==> installing sqls via Mason"
nvim --headless -c "lua local r=require('mason-registry'); r.get_package('sqls'):install():once('closed', function() vim.schedule(function() vim.cmd('qa!') end) end)" 2>&1 | tail -5

echo "done"
