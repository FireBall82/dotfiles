{ config, pkgs, ... }:
{
  home.file.".config/hypr/hyprland.conf" = {
    force = true;
    source = ./hyprland.conf;
  };
  home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  home.file.".config/hypr/scripts/yazi.sh" = {
    source = ./scripts/yazi.sh;
  };
}
