# dotfiles — Fedora Sway

## Restaurar numa máquina nova

    git clone git@github.com:gabrielwt0/Dotfiles.git ~/dotfiles
    cd ~/dotfiles && ./restore.sh

## Atualizar o repositório

    ~/dotfiles/sync.sh
    git commit -m "descrição"
    git push

## Não versionado
- `doom/gcal.el` — contém a URL secreta do Google Calendar

## Fora do repositório (recriar manualmente)
- `~/.config/doom/gcal.el` — URL secreta do iCal
- `/etc/sudoers.d/tuned` — permite trocar perfil sem senha:
      echo "$USER ALL=(ALL) NOPASSWD: /usr/sbin/tuned-adm" | sudo tee /etc/sudoers.d/tuned
      sudo chmod 440 /etc/sudoers.d/tuned
