
# dev tools
$SYS_INSTALL \
    git \
    zsh tmux vim pcregrep \
    cmake \
    python2 python3 \

$SYS_INSTALL ssh nmap


# $SYS_INSTALL mongodb
# $SYS_INSTALL libffi-dev pkg-config  # micropython
# install base python packages
$SYS_INSTALL python-dev python3-dev
$SYS_INSTALL python-pip
$SYS_INSTALL python3-pip

# miscilanious
$SYS_INSTALL libdvdcss
$SYS_INSTALL libreoffice vlc gimp pithos bleachbit
$SYS_INSTALL apvlv  # vim like pdf viewer
$SYS_INSTALL samba
$SYS_INSTALL unace unrar zip unzip p7zip-full p7zip-rar sharutils rar \
    uudeview mpack arj cabextract file-roller
$SYS_INSTALL dcfldd  # better dd, realiased in ~/.alias