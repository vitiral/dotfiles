
# std dotfiles
cd ~
# ln -s .dotfiles/.xinitrc .
# ln -s .dotfiles/.Xresources .
# ln -s .dotfiles/.inputrc .
ln -s .dotfiles/.alias .
# ln -s .dotfiles/.bash_profile .
# ln -s .dotfiles/.bashrc .
ln -s .dotfiles/.tmux.conf .
ln -s .dotfiles/.zshrc .
# ln -s .dotfiles/.gitconfig .
# ln -s .dotfiles/.gitmodules .
ln -s .dotfiles/vimrc .vimrc
touch .vimrc.local.before
touch .vimrc.local.after

# .config
# mkdir -p .config
# cd .config
# ln -s $HOME/.dotfiles/config/i3 .
# ln -s $HOME/.dotfiles/config/i3status .
# ln -s $HOME/.dotfiles/config/novault.sites .
# ln -s $HOME/.dotfiles/config/alacritty .
