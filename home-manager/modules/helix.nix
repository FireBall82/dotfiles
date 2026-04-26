{ config, pkgs, ... }:
{
  home.file.".config/helix/themes/mono.toml".text = ''
    "ui.background" = { }
    "ui.text" = { fg = "#cccccc" }
    "ui.cursor" = { fg = "#000000", bg = "#ffffff" }
    "ui.selection" = { bg = "#333333" }

    "comment" = { fg = "#666666", modifiers = ["italic"] }
    "keyword" = { fg = "#ffffff" }
    "string" = { fg = "#aaaaaa" }
    "type" = { fg = "#dddddd" }
    "function" = { fg = "#eeeeee" }
  '';
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "mono";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages = {
      language-server.nil = {
        command = "${pkgs.nil}/bin/nil";
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
      ];
    };

    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
  };
}
