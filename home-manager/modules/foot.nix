{ config, pkgs, ... }:
{
  home.file."/.config/foot/foot.ini".text = ''
        shell=/run/current-system/sw/bin/fish
    font=JetBrainsMono Nerd Font:size=11:slant=italic
    [colors]
    alpha = 0.8

  '';
}
