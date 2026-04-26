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
    background=000000b3
    text=ffffffff
    prompt=ffffffff
    placeholder=ffffffff
    input=ffffffff

    match=ffffffff
    selection=ffffffff
    selection-text=000000ff

    counter=ffffffff
    border=ffffffff
        [border]
                        width = 2
                        radius = 10

                        [dmenu]
                        exit-immediately-if-empty = yes
  '';

}
