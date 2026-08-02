#!/usr/bin/env bash
# Fixes for the 25 `doom doctor` warnings after importing gabrielwt0/Dotfiles.
# Everything not requiring root (npm globals: stylelint/js-beautify, pyenv
# clone, Symbols Nerd Font) has already been done by Claude. Run this as your
# normal user (no leading `sudo`):
#   bash ~/dotfiles-doom-doctor-fixes.sh
set -euo pipefail

echo "==> installing dnf packages for doom modules"
sudo dnf install -y \
    cmake \
    aspell aspell-en aspell-pt_BR \
    direnv \
    sqlite \
    clang-tools-extra \
    glslang \
    java-latest-openjdk-devel \
    pandoc-cli \
    graphviz \
    python3-pytest \
    shfmt \
    ShellCheck \
    tidy \
    python3-pip

echo "==> installing python tooling (user-level, needs python3-pip from above)"
python3 -m pip install --user black pipenv grip

cat <<'EOF'

Done. A few doctor warnings are intentionally left unaddressed:

  - dockfmt        (Go tool, not packaged for Fedora; only needed if you
                     format Dockerfiles from inside Doom)
  - csharpier       (needs a full .NET SDK install first; skip unless you
                     actually write C#)
  - nosetests       (the `nose` test runner is unmaintained upstream;
                     pytest above covers the same job)
  - maim/scrot      (X11 screenshot tools for org-download-clipboard --
                     won't work under a Wayland KDE session anyway)

Restart Emacs (or `doom sync`) and run `doom doctor` again afterward to
confirm the warning count drops.
EOF
