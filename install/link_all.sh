cd ~
ln -s .dotfiles/.alias .
ln -s .dotfiles/.bash_profile .
ln -s .dotfiles/.bashrc .
ln -s .dotfiles/.tmux.conf .
ln -s .dotfiles/.zshrc .
ln -s .dotfiles/.vimperatorrc .

# ipyython
cd ~
ln -s .dotfiles/.pythonrc.py
cd ~/.ipython/profile_default/ && ln -s ~/.spf13-vim-3/ipython_config.py
cd ~
