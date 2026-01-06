{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    hyprland.url = "github:hyprwm/Hyprland";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
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
      zen-browser,
      spicetify-nix,
      rose-pine-hyprcursor,
      ...
    }:
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
          inputs = {
            inherit
              hyprland
              hyprland-plugins
              zen-browser
              spicetify-nix
              rose-pine-hyprcursor
              ;
          };
        };
      };
    };
}
