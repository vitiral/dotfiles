set -e
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

mkdir -p ~/projects ~/bin ~/software

if [[ `uname` == "Linux" ]]; then
    echo "Is Linux"
    OSNAME=`cat /etc/*-release | grep ^NAME=`
fi

OS_STR=`uname -a`
echo $OS_STR

# install zsh settings and change default shell to zsh
if [[ ! -e ~/.antigen ]]; then
    mkdir ~/.antigen
    cd ~/.antigen
    git clone https://github.com/zsh-users/antigen.git
fi

# setup git
if [[ ! -e $HOME/.ssh/id_rsa.pub ]]; then
    echo ~
    git config --global user.email "vitiral@gmail.com"
    git config --global user.name "Rett Berg"
    git config --global core.editor "vim"

    echo "Press enter for EVERYTHING"
    ssh-keygen -t rsa -b 4096 -C "rett@google.com"
    echo "Go to https://github.com/settings/ssh and paste. Press ENTER when done."
    cat ~/.ssh/id_rsa.pub
    read

    eval "$(ssh-agent -s)"
    ssh git@github.com  # should confirm that everything worked
    cd ~/.dotfiles
    git remote rm origin
    git remote add origin git@github.com:vitiral/dotfiles.git
    
    cd ~
    git clone git@github.com:vitiral/notes.git
fi

# put in links to config files
bash $SCRIPTPATH/link_all.sh

echo "Done. You should now (probably) reboot"

