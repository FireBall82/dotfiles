{
  description = "flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      stable,
      spicetify-nix,
      quickshell,
      noctalia,
      ...
    }@inputs:
    {
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
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.diller = ./home.nix;
          };
          inputs = {
            inherit
              spicetify-nix
              quickshell
              noctalia
              ;
          };
        };
      };
    };
}
