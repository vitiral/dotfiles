# Edit this configuration file to define what should be installed on # your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hardware, ... }:
let
  setxkbmapPackages = with pkgs.xorg; {
    inherit xinput xset setxkbmap xmodmap; };

  i3Packages = with pkgs; {
    inherit i3-gaps i3status i3lock-fancy;
    inherit (xorg) xrandr xbacklight xset;
    inherit (pythonPackages) alot py3status;
  };

  terminalApps = with pkgs; [
    # pulseaudio
    acpi
    # fzf
    gitAndTools.gitFull
    gitAndTools.hub
    htop
    iotop
    jq
    libnotify
    lm_sensors
    nix-index
    nix-repl
    nix-zsh-completions
    networkmanagerapplet
    networkmanager_openconnect
    oh-my-zsh
    openconnect
    openssl
    psmisc
    pythonFull
    python2Full
    rxvt_unicode_with-plugins
    tmux
    vim
    unzip
    wget
    xcape
    xsel
    zsh
  ];

  desktopApps = with pkgs; [
    chromium
    firefox
    libreoffice
    vlc
  ];

in {
  # ---- HARDWARE ----
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.device = "/dev/sda";
  # boot.loader.grub.extraEntries = ''
  #   menuentry "Windows 7" {
  #     chainloader (hd0,1)+1
  #   }
  # '';

  # Set your time zone.
  time.timeZone = "America/Denver";
  
  # ---- BASIC CONFIG ----

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
  };

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; 
    ( builtins.attrValues (
      i3Packages // 
      setxkbmapPackages 
    ) )
    ++ terminalApps
    ++ desktopApps;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # ---- NETWORKING ----
  networking.hostName = "garrett-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Enables wireless support via network manager
  # networking.firewall.enable = true;
  # networking.firewall.autoLoadConntrackHelpers = true;
  # networking.nameservers = ["10.116.133.40" "10.117.30.40"];
  # networking.domain = "pw.solidfire.net";

  # Open ports in the firewall.
  # networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];


  # ---- SERVICES ----
  services = {
    nixosManual.showManual = true;
    openssh.enable = true; 	# Enable the OpenSSH daemon.
    printing.enable = true; 	# Enable CUPS to print documents.
    dbus.enable = true;
    upower.enable = true;
    acpid.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      # Enable touchpad support.
      libinput.enable = true;

      # Enable the i3 window manager
      windowManager.i3.enable = true;
      windowManager.default = "i3";
      
      displayManager.lightdm.enable = true;

      # xkbOptions = "eurosign:e";
      # xkbOptions = "ctrl:nocaps";
    };
  };

  systemd.user.services."xcape" = {
    enable = true;
    description = "xcape to use CTRL as ESC when pressed alone";
    wantedBy = [ "default.target" ];
    serviceConfig.Type = "forking";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.xcape}/bin/xcape";
  };

  # services.xserver.displayManager.sessionCommands = ''
  #   xrdb "${pkgs.writeText "xrdb.conf" ''
  #     ! urxvt*font: xft:Inconsolata\ Nerd\ Font:style=Medium:size=13
  #     
  #     URxvt*loginShell: false
  #     URxvt.letterSpace: 0
  #     URxvt*background: black
  #     URxvt*foreground: grey
  #     URxvt*color4: CornflowerBlue
  #     URxvt*color12: pink
  #     
  #     ! This is one way to remove the ctrl+i == TAB feature, however it has to be integrated
  #     ! with vim (which somehow escapes it)
  #     ! URxvt.keysym.C-i: \033[33~
  #     
  #     URxvt.perl-ext-common: default,clipboard,keyboard-select
  #     
  #     ! copy paste
  #     URxvt.iso14755: false
  #     URxvt.clipboard.copycmd: xsel -ib
  #     URxvt.clipboard.pastecmd: xsel -ob
  #     !! mac like copy/paste with Alt
  #     URxvt.keysym.M-c:     perl:clipboard:copy
  #     URxvt.keysym.M-v:     perl:clipboard:paste
  #     ! standard termial copy/paste
  #     URxvt.keysym.S-C-C:   perl:clipboard:copy
  #     URxvt.keysym.S-C-V:   perl:clipboard:paste
  #     
  #     ! Text selection (visual mode)
  #     URxvt.keysym.M-S-V: perl:keyboard-select:activate
  #   ''}"
  # '';


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.garrett = {
    name="garrett";
    group="users";
    extraGroups = [
      "wheel" 
      # "disk" 
      # "audio" "video"
      # "networkmanager" 
      # "systemd-journal"
    ];
    # createHome = true;
    uid = 1000;
    # home = /home/garrett;
    shell = /run/current-system/sw/bin/zsh;
  };
  security.sudo.wheelNeedsPassword = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
