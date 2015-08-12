SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

mkdir ~/projects ~/bin ~/software

if [[ `uname` == "Linux" ]]; then
    echo "Is Linux"
    OSNAME=`cat /etc/*-release | grep ^NAME=`
fi

# Get the base directory if it doesn't exist
cd ~
if [[ ! -e ~/.dotfiles ]]; then
    if [[ `uname` == "Linux" ]]; then
        if [[ "Ubuntu" == *"$(OSNAME)"* ]]; then
            sudo apt-get install -y git
        fi
    fi
    git clone https://github.com/cloudformdesign/dotfiles.git ~/.dotfiles && ~/.dotfiles/install/install.sh
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
eval "$(ssh-agent -s)"
ssh git@github.com  # should confirm that everything worked
cd ~/.dotfiles
git remote rm origin
git remote add origin git@github.com:cloudformdesign/dotfiles.git

cd ~
git clone git@github.com:cloudformdesign/notes.git

# Install useful software
if [[ `uname` == "Darwin" ]]; then
    echo "Is Mac"
    source "$SCRIPTPATH/install_mac.sh"
    source "$SCRIPTPATH/install_linux.sh"
elif [[ `uname` == "Linux" ]]; then
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
cd ~/software

virtualenv python2-env
virtualenv python3-env

py2=python2-env/bin/python
py3=python3-env/bin/python

pip2=python2-env/bin/pip
pip3=python3-env/bin/pip

cd ~/projects/cloudtb
$pip2 install -r "$SCRIPTPATH/python.txt"
$pip2 install -r extras.txt
$python2 setup.py develop
$pip2 install ropevim  # needed for vim (only works with python2)

$pip3 install -r "$SCRIPTPATH/python.txt"
$pip3 install -r extras.txt
$python3 setup.py develop

echo "Done. You should now (probably) reboot"

