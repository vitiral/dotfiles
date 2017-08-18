set -e
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
CREATE_USER=garrett
USER_HOME=/home/$CREATE_USER

mkdir -p ~/projects ~/bin ~/software

if [[ `uname` == "Linux" ]]; then
    echo "Is Linux"
    OSNAME=`cat /etc/*-release | grep ^NAME=`
fi

# Get the base directory if it doesn't exist
cd ~
if [[ ! -e ~/.dotfiles ]]; then
    git clone https://github.com/cloudformdesign/dotfiles.git ~/.dotfiles && ~/.dotfiles/install/install.sh
fi

OS_STR=`uname -a`
echo $OS_STR

# install zsh settings and change default shell to zsh
if [[ ! -e ~/.antigen ]]; then
    mkdir ~/.antigen
    cd ~/.antigen
    git clone https://github.com/zsh-users/antigen.git
    sudo chsh -s /usr/bin/zsh
    sudo chsh -s /usr/bin/zsh $CREATE_USER
fi

# setup git
if [[ ! -e $USER_HOME/.ssh/id_rsa.pub ]]; then
    echo ~
    git config --global user.email "googberg@gmail.com"
    git config --global user.name "Garrett Berg"
    git config --global core.editor "vim"

    echo "Press enter for EVERYTHING"
    ssh-keygen -t rsa -b 4096 -C "googberg@gmail.com"
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


# Install useful software
if [[ `uname` == "Darwin" ]]; then
    echo "Is Mac"
    source "$SCRIPTPATH/install_mac.sh"
    source "$SCRIPTPATH/install_linux.sh"
elif [[ `uname` == "Linux" ]]; then
    if [[ "Ubuntu" == *"$OS_STR"* ]]; then
        echo "  Is Ubuntu"
        sudo bash $SCRIPTPATH/install_ubuntu.sh
    else
        echo "  I assume this is Arch?"
        sudo bash $SCRIPTPATH/install_arch.sh
    fi
elif [[ `uname` == 'Cygwin' ]]; then
    :  # pass, none yet
fi

# put in links to config files
bash $SCRIPTPATH/link_all.sh

# extra software, etc
source $SCRIPTPATH/install_third.sh
source $SCRIPTPATH/install_python.sh

echo "Done. You should now (probably) reboot"

