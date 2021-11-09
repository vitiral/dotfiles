source ~/.antigen/antigen/antigen.zsh

# 
# export DISABLE_AUTO_TITLE="true"
# 
antigen use oh-my-zsh
# antigen theme robbyrussell
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle sharat87/zsh-vim-mode
antigen bundle history-substring-search
antigen apply

bindkey "^F" vi-cmd-mode
bindkey "^O" history-substring-search-up

source "$HOME/.alias"
PS1=$'\e[01;36m%2d$~ %# \e[0m' # last two directories

if [ -e ~/.shell.local ]; then
    source ~/.shell.local
fi

[ -f ~/.config/zsh.local ] && source ~/.config/zsh.local
[ -d ~/.zsh ] && fpath=(~/.zsh $fpath)

