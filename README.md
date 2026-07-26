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
- Fundo da tela de bloqueio/login do SDDM (tema `03-sway-fedora`, usado como fallback de lock em
  sessões Wayland): por padrão usa o wallpaper do Fedora. Para deixá-lo sólido Gruvbox (`#1d2021`),
  igual ao resto do sistema:

      magick -size 1920x1080 xc:'#1d2021' /tmp/gruvbox-bg.png
      sudo install -m 644 -o root -g root /tmp/gruvbox-bg.png \
          /usr/share/sddm/themes/03-sway-fedora/gruvbox-bg.png
      printf '[General]\nbackground=/usr/share/sddm/themes/03-sway-fedora/gruvbox-bg.png\n' \
          | sudo tee /usr/share/sddm/themes/03-sway-fedora/theme.conf.user

  `theme.conf.user` sobrepõe o `theme.conf` do pacote sem sobrescrevê-lo, então sobrevive a
  atualizações do tema. Só é notado no próximo login/lock, não no atual.
