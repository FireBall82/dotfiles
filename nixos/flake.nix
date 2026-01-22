{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    hyprland.url = "github:hyprwm/Hyprland";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs =
    {
      nixpkgs,
      stable,
      hyprland,
      hyprland-plugins,
      spicetify-nix,
      rose-pine-hyprcursor,
      quickshell,
      noctalia,
      ...
    }@inputs:
    {
      nixosConfigurations.diller = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix
          ./hyprland-plugins.nix
        ];

        specialArgs = {
          stable = import stable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.diller = ./home.nix;
          };
          inputs = {
            inherit
              hyprland
              hyprland-plugins
              spicetify-nix
              rose-pine-hyprcursor
              quickshell
              noctalia
              ;
          };
        };
      };
    };
}
