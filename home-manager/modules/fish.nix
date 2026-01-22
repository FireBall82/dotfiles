{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
          set fish_greeting # Disable greeting
          # Source pywal colors
      if test -e ~/.cache/wal/sequences
        cat ~/.cache/wal/sequences
      end

      # Reload starship with pywal colors
      if test -e ~/.cache/wal/colors-starship.toml
        set -gx STARSHIP_CONFIG ~/.cache/wal/colors-starship.toml
      end
      echo -ne '\e[4 q'
    '';
    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }

    ];
    shellAliases = {
      config = "cd / && cd etc/nixos && sudo nvim configuration.nix";
      rebuild = "sudo nixos-rebuild switch --flake .#diller";
      rebuild-test = "sudo nixos-rebuild test --flake .#diller";
      rebuild-home = "home-manager switch";
      rebuild-update = "cd / && cd etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --flake .#diller";
    };
  };
  home.packages = with pkgs; [
    fzf
    grc
  ];
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "[╭─](bold green)"
        "$os"
        "$username"
        "$directory"
        "$git_branch"
        "$git_status"
        "$all"
        "$line_break"
        "[╰─](bold green)$character"
      ];

      # NixOS symbol
      os = {
        disabled = false;
        style = "bold blue";
        symbols = {
          NixOS = " ";
        };
      };

      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[](bold red)";
      };

      directory = {
        style = "bold cyan";
        format = "[$path]($style)[$read_only]($read_only_style) ";
        truncation_length = 3;
      };

      git_branch = {
        symbol = "";
        style = "bold purple";
        format = "[$symbol $branch]($style) ";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        style = "bold red";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = "$";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };

      username = {
        style_user = "bold blue";
        format = "[$user]($style) ";
        show_always = true;
      };
    };
  };
}
