# ~/.zshrc

### Histórico -----------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY          # compartilha entre abas abertas
setopt HIST_IGNORE_ALL_DUPS   # sem duplicatas
setopt HIST_IGNORE_SPACE      # comando começando com espaço não entra
setopt HIST_VERIFY            # confirma antes de rodar do histórico
setopt EXTENDED_HISTORY

### Navegação -----------------------------------------------------------
setopt AUTO_CD                # digitar o nome da pasta já entra nela
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt CORRECT                # sugere correção de typo em comando

### Autocompletar --------------------------------------------------------
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignora maiúsc/minúsc
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

### Plugins (instalados via dnf) -----------------------------------------
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

### Teclas --------------------------------------------------------------
bindkey -e                                    # atalhos estilo emacs
bindkey '^[[A' history-search-backward        # seta cima busca no histórico
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word                # ctrl+direita
bindkey '^[[1;5D' backward-word               # ctrl+esquerda
bindkey '^H' backward-kill-word               # ctrl+backspace

### Aliases -------------------------------------------------------------
alias ls='eza --group-directories-first'
alias ll='eza -lh --group-directories-first --git'
alias la='eza -lah --group-directories-first --git'
alias lt='eza --tree --level=2'
alias cat='bat --style=plain --paging=never'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ip='ip -color=auto'

alias ..='cd ..'
alias ...='cd ../..'

# dnf / flatpak
alias up='sudo dnf upgrade --refresh && flatpak update'
alias inst='sudo dnf install'
alias busca='dnf search'

# sway
alias swayrl='sway --validate --config ~/.config/sway/config && swaymsg reload'
alias swaycfg='$EDITOR ~/.config/sway/config'
alias barcfg='$EDITOR ~/.config/waybar/config.jsonc'
alias barlog='pkill waybar; waybar'

# git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -15'
alias gd='git diff'

### Variáveis -----------------------------------------------------------
export EDITOR=nano
export VISUAL=$EDITOR
export PAGER=less
export LESS='-R --use-color'
export MANPAGER="less -R --use-color -Dd+r -Du+b"

### Funções úteis --------------------------------------------------------
# cria diretório e entra nele
mkcd() { mkdir -p "$1" && cd "$1"; }

# extrai qualquer arquivo compactado
extrai() {
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.tar.xz)  tar xJf "$1" ;;
        *.tar)     tar xf  "$1" ;;
        *.zip)     unzip   "$1" ;;
        *.rar)     unrar x "$1" ;;
        *.7z)      7z x    "$1" ;;
        *.gz)      gunzip  "$1" ;;
        *) echo "formato não reconhecido: $1" ;;
    esac
}

# backup rápido de arquivo de config
bkp() { cp "$1" "$1.bak-$(date +%Y%m%d-%H%M)" && echo "→ $1.bak-$(date +%Y%m%d-%H%M)"; }

### Prompt --------------------------------------------------------------
eval "$(starship init zsh)"

### Busca fuzzy (fzf) ----------------------------------------------------
source <(fzf --zsh) 2>/dev/null
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border
  --color=bg+:#2e3238,fg:#b8b8ae,fg+:#e8e6df,hl:#5e81ac,hl+:#88c0d0,prompt:#a3be8c"
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt6ct
export PATH="$HOME/.config/emacs/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# user-local tool installs (pip --user, npm --prefix, dotnet tool, go install)
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/.dotnet/tools:$HOME/go/bin:$PATH"
