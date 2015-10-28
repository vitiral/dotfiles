source ~/.antigen/antigen/antigen.zsh

antigen use oh-my-zsh
antigen theme robbyrussell
antigen bundle pip
antigen bundle history-substring-search
antigen bundle tarruda/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle sharat87/zsh-vim-mode
antigen apply

bindkey "^F" vi-cmd-mode

source "$HOME/.alias"

if [ -e ~/.shell.local ]; then
    source ~/.shell.local
fi
