# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""
autoload -U colors && colors
PS1="%{$fg[cyan]%}%2d$~ %# %{$reset_color%}"

# CASE_SENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 13   # auto-update (in days).

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

plugins=(
  history-substring-search
  vi-mode
  git
)

source $ZSH/oh-my-zsh.sh
setopt prompt_subst

# Cntrl+O or up/down to select history
bindkey "^O" history-substring-search-up
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

source ~/.alias

if [ -e ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
