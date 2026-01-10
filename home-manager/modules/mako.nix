{ config, pkgs, ... }:
{
  home.file."/.config/mako/config".text = ''
        background-color=#05070E
    text-color=#ffffff
    border-color=#50669A
    border-size=2
    padding=5
    margin=5
    default-timeout=4000
    border-radius=8
    font=JetBrainsMono Nerd Font 12
    max-visible=5
    anchor=top-right
    history=1
    group-by=app-name

  '';
}
