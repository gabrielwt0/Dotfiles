# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## O que é este repositório

Dotfiles pessoais para Fedora Sway Spin (gerenciador de janelas Sway/Wayland). Não é um projeto de
software com build/lint/test — é uma coleção de arquivos de configuração versionados, sincronizados
entre `~/dotfiles` (o repo) e os caminhos reais em `~/.config/...` via dois scripts shell.

## Fluxo de trabalho principal

O repo é a cópia de "controle de versão" das configs; `~/.config/...` é a cópia "viva" usada pelo
sistema. Os dois scripts em `set -euo pipefail` movem arquivos entre os dois:

```
./sync.sh      # copia do sistema (~/.config/...) PARA o repo, depois `git add -A` + `git status -sb`
./restore.sh   # copia do repo PARA o sistema (~/.config/...), com backup .bak-<timestamp> do que existir
./bootstrap.sh # instala software (VS Code, pacotes LaTeX via dnf, extensões do VS Code) — não copia
                # arquivos, roda antes ou depois do restore.sh indiferentemente
```

- **Sempre que um arquivo de config do sistema for editado diretamente** (ex.: `~/.config/sway/config`),
  rode `./sync.sh` para trazer a mudança para o repo antes de commitar.
- **Sempre que um arquivo do repo for editado**, rode `./restore.sh` para aplicar no sistema (ele faz
  backup automático do arquivo anterior com sufixo `.bak-YYYYMMDD-HHMM`).
- Cada par origem/destino é hardcoded nas funções `copia()`/`restaura()` de cada script — ao adicionar
  um novo arquivo de config ao repo, é preciso adicionar a linha correspondente em **ambos** os scripts.
- Depois de mexer no Sway, valide antes de recarregar: `sway --validate --config ~/.config/sway/config`
  e depois `swaymsg reload`.
- Depois de mexer no Doom Emacs (`doom/*.el`), rode `doom sync` (e `doom doctor` se necessário) na
  máquina real.

## Arquivos fora do controle de versão

- `doom/gcal.el` — contém a URL secreta do iCal do Google Calendar; está no `.gitignore` e não deve
  ser criado/commitado.
- `/etc/sudoers.d/tuned` — permite `tuned-adm` sem senha (usado por `waybar/tuned.sh`); precisa ser
  recriado manualmente em máquina nova, não vive no repo.

## Estrutura das configs

- `sway/config` + `sway/config.d/*.conf` — config principal do Sway (variáveis, aparência, keybindings,
  workspaces) mais fragmentos incluídos (screenshots, barra, swayidle). As cores de bordas/clientes em
  `sway/config` seguem o esquema Gruvbox Dark.
- `waybar/` — barra de status: `config.jsonc` (módulos), `style.css`, e `tuned.sh`, um script custom que
  a waybar chama para mostrar/alternar o perfil de energia do TuneD (`status`/`next`/`prev`, ciclando
  `powersave → balanced → throughput-performance`).
- `doom/` — `init.el` (módulos habilitados), `config.el` (config pessoal, tema, etc.), `packages.el`
  (pacotes extras além dos módulos padrão do Doom).
- `alacritty/alacritty.toml`, `starship/starship.toml` — terminal e prompt, também em Gruvbox Dark.
- `apps/*-flags.conf` — flags de linha de comando para apps Electron (VS Code, Spotify), ex.
  `--ozone-platform-hint=auto` para Wayland.
- `zsh/.zshrc` — histórico, navegação, autocompletar, keybindings estilo emacs, aliases.
- `scripts/aplica-gruvbox.sh` — aplica o tema Gruvbox Dark editando `sway/config` e `doom/config.el`
  in-place via `sed` (com backup automático), depois valida com `sway --validate`. É o script a usar
  ao trocar de tema, não editar as cores manualmente em múltiplos arquivos.
- `vscode/settings.json`, `vscode/snippets/latex.json` — settings e snippets globais do VS Code
  (perfil padrão). Inclui config do LaTeX Workshop para redação de notas (autobuild/autoclean ao
  salvar, PDF em aba com SyncTeX, format-on-save). Agnóstico de desktop environment — funciona em
  qualquer spin do Fedora, não só Sway.
- `vscode/extensions.txt` — lista de IDs de extensões (`code --list-extensions`), regenerada
  automaticamente pelo `sync.sh`; instalada pelo `bootstrap.sh`.
- `system/texlive-packages.txt` — pacotes dnf da toolchain LaTeX (scheme básico + latexmk,
  latexindent, chktex, texcount, biber, enumitem) que o `vscode/settings.json` do LaTeX Workshop
  espera; instalados pelo `bootstrap.sh`, não pelo `restore.sh` (que só copia arquivos).
- `nvim/` — config completa do LazyVim (`~/.config/nvim`). `lazy-lock.json` fixa a versão exata de
  cada plugin; plugins/dados instalados ficam em `~/.local/share/nvim`, fora do repo. Extras do
  LazyVim (R, Python, C/C++, Java, web, SQL, LaTeX, DAP, testes) são habilitados via linhas
  `{ import = "lazyvim.plugins.extras...." }` em `lua/config/lazy.lua`, não pela UI `:LazyExtras`.
  `lua/plugins/` tem overrides próprios: `colorscheme.lua` (Gruvbox), `web-templates.lua` (html/css/
  emmet para templates Jinja do Flask), `python-repl.lua` (iron.nvim, REPL de dados como o R.nvim já
  dá pro R). `lua/config/options.lua` registra a conexão MariaDB do projeto `ferro` no vim-dadbod-ui
  automaticamente, lendo a senha de `~/dev/ferro/.env` em runtime (nunca hardcoded aqui).
- `nvim-lsp-extras-setup.sh` — bootstrap como `bootstrap.sh`/`kde/dotfiles-kde-setup.sh` (não copia
  arquivos): instala Go via dnf, necessário só para o Mason compilar o `sqls` (LSP de SQL usado pelo
  extra `lang.sql`). Fica fora de `nvim/` de propósito — senão o `rm -rf nvim` do `sync.sh` apagaria.
- `kde/` — só relevante ao restaurar numa máquina Fedora KDE Plasma (sem Sway). `konsole/Shell.profile`
  e `environment.d/10-shell.conf` são copiados pelo `restore.sh` como qualquer outro arquivo.
  `dotfiles-kde-setup.sh` (pacotes dnf: zsh, alacritty, eza, fzf, qt6ct, emacs, VS Code, LaTeX, chsh
  para zsh) e `dotfiles-doom-doctor-fixes.sh` (pacotes que os módulos do Doom pedem: cmake, aspell,
  direnv, sqlite, clang-tools-extra, JDK, etc.) são scripts de bootstrap como o `bootstrap.sh` — não
  copiam arquivos, precisam ser rodados manualmente (`bash kde/dotfiles-kde-setup.sh`) por pedirem
  sudo interativo.

## Convenções

- Comentários e mensagens de commit/scripts estão em português; siga esse idioma ao editar/adicionar
  comentários nestes arquivos.
- Todos os scripts shell usam `#!/usr/bin/env bash` com `set -euo pipefail` e uma função pequena e
  idempotente (`copia`, `restaura`) chamada em loop para cada arquivo — siga esse padrão para novos scripts.
