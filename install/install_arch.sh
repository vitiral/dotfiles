SCRIPT=$(readlink -f "$0")
SCRIPTDIR=$(dirname "$SCRIPT")
INSTALL_ARGS="-S --noconfir --needed --ignore all"
SYS_INSTALL="sudo pacman $INSTALL_ARGS"
CREATE_USER=garrett
NETCONNECT='wireless'

$SYS_INSTALL git

echo "Setting up Hard Drives"
$SYS_INSTALL hdparm
if sudo hdparm -I /dev/sda | grep "TRIM supported"; then
    # SSD stuff
    sudo cp $SCRIPTDIR/etc/60-schedulers.rules /etc/udev/rules.d
    if [[ `systemctl is-active fstrim.timer` != "active" ]]; then
        sudo systemctl enable fstrim.timer
    fi
fi

# System tools
echo "Setting up system tools"
$SYS_INSTALL fdisk netctl dialog wpa_actiond

if [[! -e ]]; then
    systemctl start netctl-auto@wlp2s0.service
    systemctl enable netctl-auto@wlp2s0.service
fi

if [[ ! -e /etc/locale.conf ]]; then
    echo "Setting up locale"
    sudo cp $SCRIPTDIR/etc/locale.gen /etc
    sudo locale-gen
    sudo cp $SCRIPTDIR/etc/locale.conf /etc
    $SYS_INSTALL ntp
    sudo systemctl enable ntpd.service
fi

if [[ ! -e /etc/localtime ]]; then
    sudo ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
    sudo hwclock --systohc --utc
fi

$SYS_INSTALL openssh mosh ntp wget rsync pkg-config \
if [[ `systemctl is-active sshd.service` != "active" ]]; then
    echo "Setting up ssh"
    sudo cp $SCRIPTDIR/etc/sshd_config /etc/ssh/
    systemctl enable sshd.service
fi

if [[ `systemctl is-active avahi-daemon` != "active" ]]; then
    echo "Setting up avahi"
    $SYS_INSTALL avahi
    sudo systemctl enable avahi-daemon
fi

echo "Setting up user services"
if [[ ! -e /home/$CREATE_USER ]]; then
    echo "creating user"
   sudo useradd -m -g users -G wheel -s /usr/bin/zsh $CREATE_USER
   USER_MSG="User $CREATE_USER created. Create password with: passwd $CREATE_USER"
fi

echo "Installing user utilities"
# Window Manger and basic functionality
$SYS_INSTALL xorg-server xorg-xinit xorg-xev xorg-xmodmap \
    i3 i3lock dmenu xautolock xorg-xrdb scrot \
    rxvt-unicode urxvt-perls xclip \
    xf86-input-synaptics \
    xcape \
    pulseaudio pulseaudio-alsa alsa-utils mesa

## Use i3lock to lock the screen on lid close (i3 config handles timeout situation)
if [[ `systemctl is-active i3lock.service` != "active" ]]; then
    echo "seting up i3lock"
    sudo cp $SCRIPTDIR/etc/i3lock.service /etc/systemd/system/i3lock.service
    sudo systemctl enable i3lock.service
fi

# Software
## dev tools
echo "installing dev tools"
$SYS_INSTALL \
    base-devel cmake make gcc \
    tree \
    lsof smartmontools lm_sensors \
    python2 python2-pip python python-pip \
    npm \
    libgit2

## usertools
echo "installing user tools"
$SYS_INSTALL \
    zsh tmux vim \
    noto-fonts noto-fonts-emoji \
    firefox chromium \
    transmission-qt \
    apvlv feh vlc cmus \
    libreoffice-still

## compression
$SYS_INSTALL unace unrar zip unzip sharutils uudeview cabextract file-roller

# system settings
echo "setting up system"
sudo cp $SCRIPTDIR/etc/99-sysctl.conf /etc/sysctl.d/           # very low swappiness
sudo cp $SCRIPTDIR/etc/50-synaptics.conf /etc/X11/xorg.conf.d  # touchpad
sudo cp $SCRIPTDIR/etc/pacman.conf /etc/pacman.conf            # pacman

# virtualization
$SYS_INSTALL \
    qemu libvirt ebtables \
    virt-install virt-viewer \
    dnsmasq

# yaourt from pacman.conf added repos
$SYS_INSTALL -y yaourt
USR_INSTALL="yaourt $INSTALL_ARGS"

mkdir -p $HOME/software
if [[ ! -e $HOME/software/nerd-fonts ]]; then
    cd $HOME/software
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
    cd nerd-fonts
    ./install.sh Inconsolata
fi

# manual installation of software
if [[ ! -e $HOME/software/py3status ]]; then
    echo "installing py3status"
    cd $HOME
    cd software
    git clone https://github.com/ultrabug/py3status.git
    cd py3status
    sudo /usr/bin/python2.7 setup.py install
fi
source $SCRIPTDIR/install_vim.sh

if [[ ! -e $HOME/.cargo ]]; then
    curl https://sh.rustup.rs -sSf | sh
    cargo install cargo-edit
    cargo install cargo-script
fi

sudo pip3 install virtualenv neovim

echo "You need to set your own passwd with passwd"
echo $NETWORK_MSG
echo $UCODE_MSG
echo $USER_MSG
echo "See https://wiki.archlinux.org/index.php/Xorg for info on setting up video driver"
if [[ ! -e /boot/grub ]]; then
    echo "You need to install a bootloader still!!!"
fi

