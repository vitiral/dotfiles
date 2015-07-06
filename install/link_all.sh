cd ~
ln -s .spf13-vim-3/.alias
ln -s .spf13-vim-3/.bash_profile .bash_profile
ln -s .spf13-vim-3/.bashrc .bashrc 
ln -s .spf13-vim-3/.tmux.conf .tmux.conf 
ln -s .spf13-vim-3/.zshrc

# ipyython
cd ~
ln -s .dotfiles/.pythonrc.py
cd ~/.ipython/profile_default/ && ln -s ~/.spf13-vim-3/ipython_config.py
cd ~
