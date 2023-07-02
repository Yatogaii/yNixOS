# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <home-manager/nixos>
      ./hardware-configuration.nix
      ./virtualization.nix 
      ./network.nix
      ./nur.nix
      ./cachix.nix
    ];

  nix.settings.substituters = ["https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
#  networking.proxy.default = "http://127.0.0.1:7890/";
#  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      sarasa-gothic  #更纱黑体
      source-code-pro
      hack-font
      jetbrains-mono
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      fira-code-symbols
    ];
  };

  # 简单配置一下 fontconfig 字体顺序，以免 fallback 到不想要的字体
  fonts.fontconfig = {
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "jetbrains-mono"
        "DejaVu Sans Mono"
        "Noto Sans Mono CJK SC"
        "Sarasa Mono SC"
      ];
      sansSerif = [
        "Source Han Sans SC"
        "sarasa-gothic"  #更纱黑体
        "Noto Sans CJK SC"
        "DejaVu Sans"
      ];
      serif = [
        "Source Han Serif SC"
        "sarasa-gothic"
        "Noto Serif CJK SC"
        "DejaVu Serif"
      ];
    };
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    # fcitx5.engines = with pkgs.fcitx-engines; [ rime ];
    # fcitx5.enableRimeData= true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };
  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver = {
    enable = true;
    dpi = 120;
    displayManager.gdm.enable = true;
    displayManager.defaultSession = "xfce+bspwm";
    displayManager.sessionCommands = ''
      Xft.dpi: 120
      Xft.hinting: true
      Xft.hintstyle: hintslight
    '';
    desktopManager.xfce.enable = true;
#    desktopManager.cinnamon.enable = true;
#    desktopManager.plasma5.enable = true;
#    desktopManager.gnome.enable = true;
    windowManager.bspwm.enable = true;
    layout = "us";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    libinput.touchpad.naturalScrolling = false;
    libinput.touchpad.tapping = true;
    libinput.touchpad.middleEmulation = true;
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ykh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" "networkmanager" "vboxusers"  "libvirtd" "kvm"]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$SNnKtAcvCiORT04i$W7yrsTCQ5ddPaZ6UApIAFYqwVmG94AVzWV0X3q2e8h7xQLMurz.3/XkfSLDhv7FowU3lguXJgLSAe3FLf8mwe0";
    shell = pkgs.zsh;
  };
  # home-manager
  home-manager.users.ykh = {pkgs, ...} : {
    home.stateVersion = "23.05";
    imports = [ ./home-manager/home.nix ];
  };
  home-manager.useGlobalPkgs = true;

  environment.pathsToLink = [ "/share/zsh" "/libexec" ];




  # overlays to enable v4l2 in mpv
  nixpkgs.overlays = with pkgs; [
    (self: super: {
      mpv-unwrapped = super.mpv-unwrapped.override {
        ffmpeg_5 = ffmpeg_5-full;
      };
    })

    (self: super: {
      qemu_full = super.qemu_full.overrideAttrs (oldAttrs: {
        postPatch = oldAttrs.postPatch + ''
          sed -i 's/GUI_REFRESH_INTERVAL_DEFAULT 30/GUI_REFRESH_INTERVAL_DEFAULT 16/g' include/ui/console.h
        '';
      });
    })
  ];
  # overlays to enable 60fps in VM
  # QEMU 8.0: https://github.com/Yatogaii/qemu-60fps/archive/6cb20ea.tar.gz

#  virtualisation.qemu.package = pkgs.qemu_full;




  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    neovide
    # for neovim clipboard
    xclip
  
    polybar
    wget
    httpie
    emacs
    sxhkd
    pkgs.docker
    pkgs.rofi
    pkgs.i3lock
    i3lock-color
    xorg.xbacklight
    firefox
    git
    python39
    python39Packages.pip
    go
    clash
    zotero
    onedrive
    keepassxc
    libgccjit
    joshuto
    kitty
    picom
    nomacs
    nitrogen
    imagemagick
    acpilight
    i3lock
    acpi
    acpid
    # for xbox streaming
    mpv-unwrapped
    usbutils
    v4l-utils

    clash-verge
    cpupower-gui
    proxychains-ng

    # appimage
    appimage-run
    # remmina
    remmina
    # telegram
    tdesktop
    # system monitor 
    nmon
    htop
    obs-studio
    freerdp
    krusader
    powertop
    p7zip
    wpsoffice
    rar
  # GNOME utils
    #gnome.gpaste
    #gnome.vinagre
    #gnome.geary
    #gnome.gvfs
    #gnome.eog
    #gnomeExtensions.tweaks-in-system-menu
    #gnomeExtensions.battery-time-2
    #gnomeExtensions.dash-to-panel
    #gnome.gnome-tweaks
    #gnomeExtensions.screenshot-tool
    fprintd
    fprintd-tod
    steam
    discord

    # for flatpak
    flatpak
    ventoy
     
    # powermanagement
    tlp
    # win10 vm remote display
    moonlight-qt
    bilibili
    
    spotify
    spotify-tray
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh.enable = true;
  

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
#  services.emacs.install = true;
#  services.emacs.enable = true;
  
  # enable flatpak 
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk  pkgs.xdg-desktop-portal-kde ];
  services.flatpak.enable = true;


  # fingerprint
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # for backlight
  services.udev.packages = with pkgs; [acpilight];
  hardware.acpilight.enable = true;

  # power management
  services.tlp.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;
  documentation.nixos.enable = true;

  # enable swapfile 16G
  fileSystems."/swapfile" = {
    device = "/swapfile";
    fsType = "swap";
  };
  swapDevices = [ { device = "/swapfile"; } ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

