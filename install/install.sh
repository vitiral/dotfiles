SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# Get the base directory if it doesn't exist
cd ~
if [[ ! -e ~/.dotfiles ]]; then
    if [[ `uname` == "Linux" ]]; then
        if [[ "Ubuntu" == *"$(OSNAME)"* ]]; then
            sudo apt-get install git
        fi
    fi
    git clone https://github.com/cloudformdesign/dotfiles.git ~/.dotfiles && ~/.dotfiles/install/install.sh
fi


# Install useful software
if [[ `uname` == "Darwin" ]]; then
    echo "Is Mac"
    source "$SCRIPTPATH/install_mac.sh"
    source "$SCRIPTPATH/install_linux.sh"
elif [[ `uname` == "Linux" ]]; then
    echo "Is Linux"
    OSNAME=`cat /etc/*-release | grep ^NAME=`
    if [[ "Ubuntu" == *"$(OSNAME)"* ]]; then
        echo "  Is Ubuntu"
        source "$SCRIPTPATH/install_ubuntu.sh"
    else
        exit 1
    fi
    source "$SCRIPTPATH/install_linux.sh"
elif [[ `uname` == 'Cygwin' ]]; then
    :  # pass, none yet
fi

# setup git
git config --global user.email "googberg@gmail.com"
git config --global user.name "Garrett Berg"
git config --global core.editor "vim"

if [[ ! -e ~/.ssh/id_rsa.pub ]]; then
    echo "Press enter for EVERYTHING"
    ssh-keygen -t rsa -b 4096 -C "googberg@gmail.com"
    echo "Go to https://github.com/settings/ssh and paste. Press ENTER when done."
    cat ~/.ssh/id_rsa.pub
    read
fi
ssh git@github.com  # should confirm that everything worked
cd ~/.dotfiles
git remote rm origin
git remote add origin git@github.com:cloudformdesign/dotfiles.git

cd projects
git clone git@github.com:cloudformdesign/notes.git

# install zsh settings and change default shell to zsh
mkdir ~/.antigen
cd ~/.antigen
git clone https://github.com/zsh-users/antigen.git
sudo chsh -s /usr/bin/zsh
sudo chsh -s /usr/bin/zsh $USER

# python
cd ~/projects
git clone git@github.com:cloudformdesign/cloudtb.git
cd ~/projects/cloudtb

sudo pip2 install -r "$SCRIPTPATH/python.txt"
sudo pip2 install -r extras.txt
sudo python2 setup.py develop

sudo pip3 install -r "$SCRIPTPATH/python.txt"
sudo pip3 install -r extras.txt
sudo python3 setup.py develop

# install default dot files
sh $SCRIPTPATH/dotfiles.sh
sh $SCRIPTPATH/link_all.sh

echo "Done. You should now (probably) reboot"

