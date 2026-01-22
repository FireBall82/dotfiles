{
  config,
  inputs,
  stable,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.nixosModules.default
    ./hardware-configuration.nix
    (import ./hyprland-plugins.nix {
      inherit
        config
        pkgs
        lib
        inputs
        ;
    })
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

    };
    kernelParams = [
      "nvidia-drm.modeset=1"
    ];
  };
  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  #Enable OpenGL
  hardware.graphics = {
    enable = true;
  };
  #Nvidia driver
  services.xserver.videoDrivers = [
    "nvidia"
    "modesetting"
    "intel"
  ];
  #nvidia config
  hardware.nvidia = {
    #Modesetting is required.
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    #package
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  #nvidia prime config
  hardware.nvidia.prime = {
    #Offload(better power consumption)
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    #Bus ID values
    intelBusId = "PCI:0:0:2";
    nvidiaBusId = "PCI:0:1:0";
  };

  # Enable networking
  networking.networkmanager.enable = true;
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        ControllerMode = "bredr"; # Fix frequent Bluetooth audio dropouts
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

  services.xserver.enable = false;
  #Required by networking
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  #auto-cpufreq
  services.auto-cpufreq.enable = true;
  services.power-profiles-daemon.enable = false;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  #Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  #Zram swap
  zramSwap.enable = true;
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  #blueman
  services.blueman.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.diller = {
    isNormalUser = true;
    description = "Diller";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
    ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kolourpaint
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  #Spicetify
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

  #Install steam
  programs.steam.enable = true;
  #Neovim config
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  #docker
  virtualisation.docker.enable = true;
  programs.niri.enable = true;
  #Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  environment.sessionVariables = {
    CURL_HTTP_VERSION = "1.1";
    #Cursor fix
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "0";
    MOZ_WEBRENDER = "1";
    NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GL_YIELD = "USLEEP"; # reduces stutter
    __GL_SYNC_TO_VBLANK = "1"; # enable vsync for NVIDIA
    __NV_PRIME_RENDER_OFFLOAD = "1"; # enable offloading to NVIDIA
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; # use NVIDIA GLX library
    __VK_LAYER_NV_optimus = "NVIDIA_only"; # Vulkan offload
  };
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    foot
    pywal
    stable.spotify
    stable.telegram-desktop
    stable.discord
    stable.librewolf
    daggerfall-unity
    waypaper
    neovim
    hyprcursor
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    libnotify
    auto-cpufreq
    fastfetch
    gamescope
    btop
    rpm
    cmatrix
    protontricks
    stable.vlc
    playerctl
    yazi
    vesktop
    stable.gparted
    obs-studio
    #hyprland plugins dependencies
    #------:
    cairo
    cpio
    meson
    gcc
    pango
    gtk4
    cmake
    #-------
    tor
    torsocks
    torctl
    pwvucontrol
    lshw
    cava
    waybar
    pywalfox-native
    stable.zoom-us
    lenovo-legion
    hyprpaper
    unzip
    redis
    stable.audacity
    docker
    docker-compose
    man
    fuzzel
    stable.thunderbird
    fish
    vscode
    python3
    pavucontrol
    wine64
    stable.ranger
    stable.calcurse
    gccgo14
    stable.tree
    stable.curl
    stable.w3m
    stable.brightnessctl
    git
    subversionClient
    stable.ollama
    stable.mako
    stable.clipse
    stable.wl-clipboard
  ];
  # services.openssh.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.11";
}
