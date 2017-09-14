source ~/.antigen/antigen/antigen.zsh

antigen use oh-my-zsh
antigen theme robbyrussell
antigen bundle pip
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle sharat87/zsh-vim-mode
antigen bundle tarruda/zsh-autosuggestions
antigen bundle history-substring-search
antigen apply

#bindkey "^F" vi-cmd-mode
bindkey "^O" history-substring-search-up

source "$HOME/.alias"

if [ -e ~/.shell.local ]; then
    source ~/.shell.local
fi

# added by travis gem
[ -f /home/garrett/.travis/travis.sh ] && source /home/garrett/.travis/travis.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.config/zsh.local ] && source ~/.config/zsh.local
[ -d ~/.zsh ] && fpath=(~/.zsh $fpath)
