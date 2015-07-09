cd ~
ln -s .dotfiles/.alias
ln -s .dotfiles/.bash_profile .bash_profile
ln -s .dotfiles/.bashrc .bashrc 
ln -s .dotfiles/.tmux.conf .tmux.conf 
ln -s .dotfiles/.zshrc

# ipyython
cd ~
ln -s .dotfiles/.pythonrc.py
cd ~/.ipython/profile_default/ && ln -s ~/.spf13-vim-3/ipython_config.py
cd ~
