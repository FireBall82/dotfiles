{ config, pkgs, ... }:
{
  home.file.".config/fuzzel/fuzzel.ini".text = ''
    [main]
    terminal = ${pkgs.foot}/bin/foot
    layer = overlay

    font = JetBrainsMono Nerd Font:size=12:weight=bold
    dpi-aware = no

    icons-enabled = no
    show-actions = no

    # Layout - your settings
    anchor = right
    x-margin = 3
    horizontal-pad = 10
    vertical-pad = 8
    inner-pad = 8

    lines = 30
    tabs = 3

    # Behavior
    fuzzy = yes

    [colors]
    background = 05070Eff
    text = cce0eeff
    match = 50669Aff
    selection = 50669Aff
    selection-text = D8DEE9ff
    selection-match = 88C0D0ff
    border = 50669Aff

    [border]
    width = 2
    radius = 10

    [dmenu]
    exit-immediately-if-empty = yes
  '';

}
