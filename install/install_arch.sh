SYS_INSTALL="sudo pacman -S --noconfir --needed --ignore all"
CREATE_USER=garrett
set -e  # errors cause failure

if [[ ! -e /etc/localtime ]]; then
    ln -sf /usr/share/zoneinfo/Zone/SubZone /etc/localtime
    hwclock --systohc --utc
fi

# wireless (wifi-menu and autoconnect)
netctl_service="netctl-auto@wlp2s0.service"
if [[ `systemctl is-active $netctl_service` != "active" ]]; then
    $SYS_INSTALL iw wpa_supplicant dialog wpa_actiond
    systemctl enable $netctl_service
fi

if [[ ! -e /home/$CREATE_USER ]]; then
   useradd -m -g users -G wheel $CREATE_USER
fi

if [[ ! -e /boot/intel-ucode.img ]]; then
    echo "installing ucode"
    $SYS_INSTALL intel-ucode 
fi

# graphical interface and user manager
$SYS_INSTALL xorg-server xorg-xinit xorg-xev slim i3 termite 

# dev tools
$SYS_INSTALL \
    git \
    zsh tmux vim \
    wget \
    cmake \
    python2 

# compression
$SYS_INSTALL unace unrar zip unzip sharutils uudeview cabextract file-roller

# usertools
$SYS_INSTALL \
    firefox \
    apvlv 

echo "See https://wiki.archlinux.org/index.php/Microcode for setting up microcode"
echo "See https://wiki.archlinux.org/index.php/Xorg for info on setting up video driver"

