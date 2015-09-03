# Cloudform Design’s dotfiles

This was originally based off of spf13-vim, a fantastic vim distribution. It
grew to the point where it could not longer be called spf13 though.

# Install
```bash
curl http://git.io/vGyih -L > install.sh && bash install.sh
```

# Arch Linux
For arch linux it is recommended to run install_arch.sh first
```bash
curl http://git.io/vGyiS -L > install_arch.sh && bash install_arch.sh
```

## Embedded Systems
For Embedded systems it is recommended to edit `~/vimrc.before.local` with the following line:
```
let g:spf13_bundle_groups=['minimal']
```
