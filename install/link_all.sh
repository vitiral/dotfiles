
# std dotfiles
cd ~
ln -s .dotfiles/.Xresources .
ln -s .dotfiles/.alias .
ln -s .dotfiles/.bash_profile .
ln -s .dotfiles/.bashrc .
ln -s .dotfiles/.tmux.conf .
ln -s .dotfiles/.zshrc .
ln -s .dotfiles/.vimperatorrc .

# .config
mkdir -p .config
cd .config
ln -s ~/.dotfiles/config/i3 .

# python
cd ~
ln -s .dotfiles/.pythonrc.py
cd ~/.ipython/profile_default/ && ln -s ~/.dotfiles/ipython_config.py
cd ~
