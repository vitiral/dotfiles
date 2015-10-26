source ~/.antigen/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# # Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle pip

# vim mode

#bindkey -v
#bindkey -M viins 'jj' vi-cmd-mode
#bindkey "^?" backward-delete-char
#bindkey "^W" backward-kill-word
#bindkey "^H" backward-delete-char
#bindkey "^U" backward-kill-line

bindkey "^L" forward-word
bindkey "^H" backward-word

#antigen bundle sharat87/zsh-vim-mode
#vi-search-fix() {
#    zle vi-cmd-mode
#    zle .vi-history-search-backward
#}
#autoload vi-search-fix
#zle -N vi-search-fix
#bindkey -M viins '\e/' vi-search-fix

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle tarruda/zsh-autosuggestions

# Load the theme.
antigen theme robbyrussell

if [[ $CURRENT_OS == 'OS X' ]]; then
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle gem
    antigen bundle osx
elif [[ $CURRENT_OS == 'Linux' ]]; then
    # None so far...

    if [[ $DISTRO == 'CentOS' ]]; then
        antigen bundle centos
    fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
    antigen bundle cygwin
fi

# Tell antigen that you're done.
antigen apply

source "$HOME/.alias"

if [ -e ~/.shell.local ]; then
    source ~/.shell.local
fi

