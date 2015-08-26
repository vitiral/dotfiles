set -e 
# if [[ ! -e /etc/init.d/dropbox ]]; then
#     echo "installing dropbox"
#     cd ~
#     curl https://www.dropbox.com/download\?dl\=packages/dropbox.py -L > dropbox
#     chmod a+x dropbox
#     if python2 dropbox; then
#         sudo mv dropbox /etc/init.d/
#         sudo update-rc.d dropbox defaults
#     fi
# fi
# 
# cd ~/projects
# # if [[ ! -e ~/bin/micropython ]]; then
# if 0; then
#     echo "Installing micropython"
#     git clone git@github.com:micropython/micropython.git
#     cd micropython/unix
#     make
#     cd ~/bin
#     ln -s ~/projects/micropython/unix/micropython .
# fi
