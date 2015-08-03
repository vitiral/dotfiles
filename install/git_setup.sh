
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
