# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  nix.settings.experimental-features = [ "nix-command"  "flakes" ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;  
  hardware.opentabletdriver.enable = true;  
  
  nixpkgs.config.allowUnfree = true;
  # services.pipewire.enable = lib.mkForce false;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  fonts.packages = with pkgs; [
     nerdfonts
     jetbrains-mono
  ];


  # Enable the X11 windowing system.
  # services.xserver = {
  #    enable = true;
  #    displayManager.lightdm.enable = true;
  #    autorun = false;
  #    xkb.layout  = "us";
  #    windowManager.bspwm.enable = true;
  #    windowManager.bspwm.configFile = "/home/duthaegaux/.config/bspwm/themes/bspwm_nord/bspwm/bspwmrc";
  #    windowManager.bspwm.sxhkd.configFile = "/home/duthaegaux/.config/bspwm/themes/bspwm_nord/sxhkd/sxhkdrc";
  #    desktopManager.xterm.enable = false;
  # };
  # services.displayManager.defaultSession = "none+bspwm";

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  programs.hyprland = {
     enable = true;
     withUWSM = true;
     xwayland.enable = true;
  };
  environment.sessionVariables = {
     #WLR_NO_HARDWARE_CURSORS = "1";
     NIXOS_OZONE_WL = "1";
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.pipewire.enable = lib.mkForce false;
  services.flatpak.enable = true;  

  # Enable sound.
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # OR
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   jack.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.fish.enable = true;
  
  services.greetd = {
    enable = true;
    vt = 3;
    settings = {
      initial_session = {
        user = "duthaegaux";
        command = "Hyprland";
      };
      default_session = {
        user = "duthaegaux";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a * %h | %F' --cmd Hyprland";
      };
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.duthaegaux = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
       "wheel"
       "audio"
       "video"
       "storage"
     ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    alsa-lib
    bluez
    firefox
    vscode
    # xorg.xorgserver
    # xorg.xinit
    xorg.xrandr
    # xorg.xset
    # xorg.xf86videofbdev
    # xorg.xf86videovesa
    # xorg.xsetroot
    # xorg.xrdb
    # xorg.xbacklight
    # bspwm
    # sxhkd
    killall
    # polybar
    # conky
    htop
    #picom
    #viewnior
    cmus
    neofetch
    flameshot
    mpv
    unzip
    fish
    alacritty
    nerdfonts
    # feh
    # jq
    # ueberzug
    # w3m
    # imagemagick
    # lxappearance
    # nitrogen

    waybar
    swww
    fastfetch
    kitty
    rofi-wayland
    hyprlock
    networkmanagerapplet
    yazi
    cmus
    celluloid
    pulsemixer
    waypaper
    brightnessctl
    grimblast
    papirus-icon-theme
    nwg-look
    telegram-desktop
    yandex-music
    python3
    xfce.thunar
    blueman
    iptables
    ipset
    openvpn    
    networkmanager-openvpn
    discord   
    jdk
    feh
    aseprite
    opentabletdriver
    opera
    
    (waybar.overrideAttrs (oldAttrs: {
       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
       })
    )   
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

