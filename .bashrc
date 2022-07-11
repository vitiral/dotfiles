source "$HOME/.alias"
source "$HOME/.bashrc.local"

source /etc/skel/.bashrc

shopt -s cmdhist
shopt -s lithist

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
