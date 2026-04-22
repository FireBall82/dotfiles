{ config, pkgs, ... }:
{
  home.username = "diller";
  home.homeDirectory = "/home/diller";
  home.stateVersion = "24.11";
  imports = [
    ./modules/hyprland/hyprland.nix
    ./modules/waybar/waybar.nix
    ./modules/fish.nix
    ./modules/fuzzel.nix
    ./modules/mako.nix
    ./modules/foot.nix
    ./modules/git.nix
    ./modules/niri/niri.nix
  ];

  programs.home-manager.enable = true;
}
