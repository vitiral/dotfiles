# Cloudform Design’s dotfiles

This was originally based off of spf13-vim, a fantastic vim distribution. It
grew to the point where it could not longer be called spf13 though.

# Install
```bash
    curl https://raw.githubusercontent.com/cloudformdesign/spf13-vim/master/install/install.sh -L > install.sh && sh install.sh
```

## Embedded Systems
For Embedded systems it is recommended to edit `~/vimrc.before.local` with the following line:
```
let g:spf13_bundle_groups=['minimal']
```
