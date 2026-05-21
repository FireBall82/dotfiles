{ config, pkgs, ... }:
{
  # home.file.".config/helix/themes/mono.toml".text = ''
  #      "ui.background" = { }
  # "ui.text" = { fg = "#cccccc" }
  # "ui.cursor" = { fg = "#000000", bg = "#ffffff" }
  # "ui.selection" = { bg = "#333333" }

  # "comment" = { fg = "#666666", modifiers = ["italic"] }
  # "keyword" = { fg = "#ffffff" }
  # "string" = { fg = "#aaaaaa" }
  # "type" = { fg = "#dddddd" }
  # "function" = { fg = "#eeeeee" }
  # '';
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "amberwood_transparent";
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
      language-server.rust-analyzer = {
        command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      };
      language-server.pyright = {
        command = "${pkgs.pyright}/bin/pyright-langserver";
        args = [ "--stdio" ];
      };
      language-server.ruff = {
        command = "${pkgs.ruff}/bin/ruff";
        args = [ "server" ];
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
        {
          name = "python";
          auto-format = true;
          formatter.command = "${pkgs.ruff}/bin/ruff";
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
        }
      ];
    };
    themes = {
      amberwood_transparent = {
        "inherits" = "amberwood";
        "ui.background" = { };
      };
    };

  };
}
