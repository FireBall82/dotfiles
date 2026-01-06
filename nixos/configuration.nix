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
    # Include the results of the hardware scan.
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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
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
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;
  programs.adb.enable = true;
  #Required by networking
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
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
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
      enabledCustomApps = with spicePkgs.apps; [
      ];
      enabledSnippets = with spicePkgs.snippets; [
      ];

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

  #Install steam
  programs.steam.enable = true;
  #Git config
  programs.git = {
    enable = true;
    config = {
      user.name = "FireBall82";
      user.email = "romennegrik82@gmail.com";
      init.defaultBranch = "master";
      pull.rebase = true;
    };
  };
  #Neovim config
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  #docker
  virtualisation.docker.enable = true;
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
    nerd-fonts.heavy-data
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    #-------
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
