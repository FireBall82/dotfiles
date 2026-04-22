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
    background=31033aCC
    text=f3f2f3ff
    prompt=6933ffff
    placeholder=ff3353ff
    input=e34dffff
    match=ff3353ff
    selection=e34dff80
    selection-text=f3f2f3ff
    selection-match=231825ff
    counter=6933ffff
    border=e34dffff
    [border]
            width = 2
            radius = 10

            [dmenu]
            exit-immediately-if-empty = yes
  '';

}
