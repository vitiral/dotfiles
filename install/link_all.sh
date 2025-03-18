#!/usr/local/bin/zsh

# std dotfiles
cd ~

function lndot() {
  ln -s $PWD/.dotfiles/dot/$1 .$1
}

lndot vimrc
touch .vimrc.local.before
touch .vimrc.local.after

lndot alias
lndot tmux.conf
lndot zshrc
lndot xinitrc
lndot Xresources

mkdir -p ~/.config/i3/
ln -s $HOME/.dotfiles/config/i3   ~/.config/i3/config

# .config
# mkdir -p .config
# cd .config
# ln -s $HOME/.dotfiles/config/i3 .//
# ln -s $HOME/.dotfiles/config/i3status .
# ln -s $HOME/.dotfiles/config/novault.sites .
# ln -s $HOME/.dotfiles/config/alacritty .
