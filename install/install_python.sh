set -e
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# default shell
sudo pip3 install xonsh

pip install -r $SCRIPTPATH/python.txt --user
pip3 install -r $SCRIPTPATH/python.txt --user

if [[ ! -e $HOME/projects/cloudtb ]]; then
    cd ~/projects
    git clone git@github.com:vitiral/cloudtb.git
fi

if [[ ! -e $HOME/projects/litevault ]]; then
    cd ~/projects
    git clone git@github.com:vitiral/litevault.git
fi

pip3 install -e ~/projects/litevault --user

pip install -e ~/projects/cloudtb --user
pip3 install -e ~/projects/cloudtb --user
