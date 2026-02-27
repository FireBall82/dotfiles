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
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

    };
    kernelModules = [
      "ideapad_laptop"
    ];
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1" # helps with some display issues
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # helps with suspend/resume
    ];
  };
  systemd.services.battery-threshold = {
    description = "Set battery conservation mode";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "set-conservation-mode" ''
        echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
      '';
    };
  };
  networking.hostName = "nixos";
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
    reverseSync.enable = true;
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
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs; [
      sddm-astronaut
      kdePackages.qtmultimedia
    ];
  };
  # Create custom SDDM session for user-installed Hyprland
  services.displayManager.sessionPackages = [
    (pkgs.runCommand "hyprland-user-session"
      {
        passthru.providedSessions = [ "hyprland-user" ];
      }
      ''
        mkdir -p $out/share/wayland-sessions
        cat > $out/share/wayland-sessions/hyprland-user.desktop << EOF
        [Desktop Entry]
        Name=Hyprland (User)
        Comment=Hyprland installed via Home Manager
        Exec=start-hyprland
        Type=Application
        DesktopNames=Hyprland
        EOF
      ''
    )
  ];
  services.auto-cpufreq.enable = false;
  services.power-profiles-daemon.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
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
  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0"; # Force NVIDIA primary
    QML_DISABLE_DISK_CACHE = "1";
    XDG_SESSION_TYPE = "wayland";
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
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    libnotify
    sddm-astronaut
    kdePackages.qtmultimedia
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
    xwayland-satellite
    subversionClient
    stable.ollama
    stable.mako
    stable.clipse
    stable.wl-clipboard
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # NO passwords
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
    openFirewall = true;
  };
  # Fail2ban to block brute force attempts
  services.fail2ban = {
    enable = true;
    maxretry = 3;
  };
  networking.firewall.enable = true;
  services.tailscale.enable = true;
  system.stateVersion = "24.11";
}
