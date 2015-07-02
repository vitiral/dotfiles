# cleanup home folder
cd ~
rm .bash*
mkdir projects software
SYS_INSTALL="sudo apt-get install"

# update and upgrade
sudo apt-get update
sudo apt-get upgrade

# system specific tools
$SYS_INSTALL flashplugin-installer ubuntu-restricted-extras
$SYS_INSTALL build-essential
$SYS_INSTALL libpng12-dev libfreetype6-dev  # needed for matplotlib
$SYS_INSTALL openjdk-7-jdk

## note: still need to manually disable desktop integration prompts
$SYS_INSTALL unity-tweak-tool

# Install microcode. Check microcode with `dmesg | grep microcode`
# $SYS_INSTALL microcode.ctl intel-microcode

# disable search feature (amazon can't spy on me)
gsettings set com.canonical.Unity.Lenses remote-content-search none 

# check this out
# http://www.unixmen.com/autmatically-disable-touchpad-typing-ubuntu/
# http://www.unixmen.com/how-to-improve-laptop-battery-life-and-usage-in-linux-using-tlp/
