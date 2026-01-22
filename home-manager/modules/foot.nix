{ config, pkgs, ... }:
{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        shell = "/run/current-system/sw/bin/fish";
        font = "JetBrainsMono Nerd Font:size=11:slant=italic";
        pad = "5x5";
      };

      colors = {
        alpha = "0.8";
      };
    };
  };
}
