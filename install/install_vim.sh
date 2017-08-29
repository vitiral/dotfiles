if [[ ! -e $HOME/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
mkdir -p $HOME/.vim/data/undo
mkdir -p $HOME/.vim/data/swap
mkdir -p $HOME/.vim/data/backup

