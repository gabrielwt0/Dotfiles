#!/usr/bin/env bash
# Finishes the nvim LSP setup: installs system libs the Mason-managed
# tools need to compile from source, then (re)installs them. Run as your
# normal user (no leading sudo):
#   bash ~/nvim-lsp-extras-setup.sh
set -euo pipefail

echo "==> installing Go (required to build sqls), R package build deps, zathura PDF backend"
# libxml2-devel: R package xml2 (dep of lintr/roxygen2, dep of r-languageserver)
# libgit2-devel/libssh2-devel/openssl-devel: R package git2r (dep of r-languageserver)
# libuv-devel: R package fs (dep of pkgload -> roxygen2 -> languageserver)
# libcurl-devel: R package curl (dep of r-languageserver's chain)
# zathura-pdf-poppler: zathura has no PDF backend without it, can't open PDFs at all
sudo dnf install -y golang libxml2-devel libgit2-devel libssh2-devel openssl-devel libuv-devel libcurl-devel zathura-pdf-poppler

echo "==> installing sqls via Mason"
nvim --headless -c "lua require('mason-registry').get_package('sqls'):install():once('closed', function() vim.schedule(function() vim.cmd('qa!') end) end)" 2>&1 | tail -5

echo "==> installing r-languageserver via Mason (compiles from source, can take 10+ min)"
nvim --headless -c "lua require('mason-registry').get_package('r-languageserver'):install():once('closed', function() vim.schedule(function() vim.cmd('qa!') end) end)" 2>&1 | tail -5

echo "==> verifying"
nvim --headless -c "lua for _, n in ipairs({'sqls','r-languageserver'}) do print(n, require('mason-registry').get_package(n):is_installed()) end" -c "qa" 2>&1

echo "done"
