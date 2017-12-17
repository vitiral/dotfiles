# vim
if [[ ! -e $HOME/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
mkdir -p $HOME/.vim/data/undo
mkdir -p $HOME/.vim/data/swap
mkdir -p $HOME/.vim/data/backup

# neovim
NVIM_PLUG="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [[ ! -e "$NVIM_PLUG" ]]; then
    curl -fLo "$NVIM_PLUG" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
mkdir -p $HOME/.nvim/data/undo
mkdir -p $HOME/.nvim/data/swap
mkdir -p $HOME/.nvim/data/backup
