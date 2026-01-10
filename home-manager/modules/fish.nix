{ config, pkgs, ... }:
{
  home.file.".config/fish/config.fish".text = ''
     function fish_greeting
    end
    function fish_prompt
        echo ' -'$PWD '->'
    end
    if status is-interactive
        # Commands to run in interactive sessions can go here
    end
    set -gx EDITOR "nvim"
    set -gx VISUAL "nvim"

    alias config='cd / && cd etc/nixos && sudo nvim configuration.nix'
    alias rebuild='sudo nixos-rebuild switch --flake /etc/nixos/#diller'
    cat ~/.cache/wal/sequences
  '';
}
