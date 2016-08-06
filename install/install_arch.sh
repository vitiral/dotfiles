set -e  # errors cause failure
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
INSTALL_ARGS="-S --noconfir --needed --ignore all"
SYS_INSTALL="sudo pacman $INSTALL_ARGS"
CREATE_USER=garrett
NETCONNECT='wireless'

$SYS_INSTALL git

$SYS_INSTALL hdparm
if sudo hdparm -I /dev/sda | grep "TRIM supported"; then
    # SSD stuff
    sudo cp $SCRIPTPATH/etc/60-schedulers.rules /etc/udev/rules.d
    if [[ `systemctl is-active fstrim.timer` != "active" ]]; then
        sudo systemctl enable fstrim.timer
    fi
fi

# System tools
$SYS_INSTALL parted

if [[ ! -e /etc/locale.conf ]]; then
    sudo cp $SCRIPTPATH/etc/locale.gen /etc
    sudo locale-gen
    sudo cp $SCRIPTPATH/etc/locale.conf /etc
fi

if [[ ! -e /etc/localtime ]]; then
    sudo ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
    sudo hwclock --systohc --utc
fi

# wireless (wifi-menu and autoconnect)
if [[ $NETCONNECT -eq "wireless" ]]; then
    netctl_service="netctl-auto@wlp2s0.service"
    if [[ `systemctl is-active $netctl_service` != "active" ]]; then
        $SYS_INSTALL iw wpa_supplicant dialog wpa_actiond
        sudo systemctl enable $netctl_service
    fi
else
    $SYS_INSTALL dhcpcd
    NETWORK_MSG="Must enable network manually"
fi

$SYS_INSTALL openssh
if [[ `systemctl is-active sshd.service` != "active" ]]; then
    sudo cp $SCRIPTPATH/etc/sshd_config /etc/ssh/
    systemctl enable sshd.service
fi

if [[ `systemctl is-active avahi-daemon` != "active" ]]; then
    $SYS_INSTALL avahi
    sudo systemctl enable avahi-daemon
fi

if [[ ! -e /home/$CREATE_USER ]]; then
   sudo useradd -m -g users -G wheel -s /usr/bin/zsh $CREATE_USER
   USER_MSG="User $CREATE_USER created. Create password with: passwd $CREATE_USER"
fi

if [[ ! -e /boot/intel-ucode.img ]]; then
    echo "installing ucode"
    UCODE_MSG="See https://wiki.archlinux.org/index.php/Microcode for setting up microcode"
    $SYS_INSTALL intel-ucode
fi

# Window Manger and basic functionality
$SYS_INSTALL xorg-server xorg-xinit xorg-xev xorg-xmodmap \
    i3 i3lock dmenu xautolock xorg-xrdb \
    rxvt-unicode urxvt-perls xclip \
    ttf-dejavu ttf-inconsolata bdf-unifont \
    xf86-input-synaptics \
    pulseaudio pulseaudio-alsa alsa-utils 

if [[ -e ~/.zlogin ]]; then
    ln -s $SCRIPTPATH/.zlogin ~/.zlogin
fi

## Use i3lock to lock the screen on lid close (i3 config handles timeout situation)
if [[ `systemctl is-active i3lock.service` != "active" ]]; then
    sudo cp $SCRIPTPATH/etc/i3lock.service /etc/systemd/system/i3lock.service
    sudo systemctl enable i3lock.service
fi

# Software
## dev tools
$SYS_INSTALL \
    zsh tmux vim \
    tree \
    the_silver_searcher \
    openssh wget rsync \
    cmake \
    lsof smartmontools lm_sensors \
    python2 python2-pip python python-pip

## compression
$SYS_INSTALL unace unrar zip unzip sharutils uudeview cabextract file-roller

## usertools
$SYS_INSTALL \
    firefox \
    apvlv feh \
    libreoffice-still

# system settings
sudo cp $SCRIPTPATH/etc/99-sysctl.conf /etc/sysctl.d/           # very low swappiness
sudo cp $SCRIPTPATH/etc/50-synaptics.conf /etc/X11/xorg.conf.d  # touchpad
sudo cp $SCRIPTPATH/etc/pacman.conf /etc/pacman.conf            # pacman

# yaourt from pacman.conf added repos
$SYS_INSTALL -y yaourt
USR_INSTALL=yaourt $INSTALL_ARGS

$USR_INSTALL pithos otf-inconsolata-powerline-git

if [[ `systemctl is-active dropbox@${CREATE_USER}` != "active" ]]; then
    $USR_INSTALL dropbox
    sudo systemctl enable dropbox@${CREATE_USER}
fi

# manual installation of software
if [[ ! -e $HOME/software/py3status ]]; then
    cd $HOME
    mkdir -p software
    cd software
    git clone https://github.com/ultrabug/py3status.git
    cd py3status
    sudo /usr/bin/python2.7 setup.py install
fi

echo "You need to set your own passwd with passwd"
echo $NETWORK_MSG
echo $UCODE_MSG
echo $USER_MSG
echo "See https://wiki.archlinux.org/index.php/Xorg for info on setting up video driver"
if [[ ! -e /boot/grub ]]; then
    echo "You need to install a bootloader still!!!"
fi

