SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

mkdir ~/projects ~/bin ~/software
source "$SCRIPTPATH/git_setup.sh"

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

# install zsh settings and change default shell to zsh
mkdir ~/.antigen
cd ~/.antigen
git clone https://github.com/zsh-users/antigen.git
sudo chsh -s /usr/bin/zsh
sudo chsh -s /usr/bin/zsh $USER

# install default dot files
bash $SCRIPTPATH/dotfiles.sh
bash $SCRIPTPATH/link_all.sh

# extra software, etc
source $SCRIPTPATH/install_third.sh

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


echo "Done. You should now (probably) reboot"

