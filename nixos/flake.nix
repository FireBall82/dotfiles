{
  description = "stable flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, stable, ... }: {
    nixosConfigurations.diller = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
      ];

      specialArgs = {
        stable = import stable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };
    };
  };
}
