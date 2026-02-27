{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      hyprland-plugins,
      ...
    }@inputs:
    {
      homeConfigurations.diller = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          ./modules/hyprland/hyprland.nix
        ];
        extraSpecialArgs = {
          inherit hyprland-plugins;
          inherit inputs;
        };
      };
    };
}
