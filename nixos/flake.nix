{
  description = "stable and hyprland plugins flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
  };
};

  outputs = { self, nixpkgs, stable, hyprland, hyprland-plugins, ... }: {
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
        inherit hyprland hyprland-plugins;
        };
      };
    };
  };
}
