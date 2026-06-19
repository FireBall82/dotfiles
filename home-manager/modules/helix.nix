{ config, pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "amberwood_transparent";
      editor = {
        line-number = "relative";
        cursorline = true;
        auto-save = true;
        completion-trigger-len = 1;
        color-modes = true;
        indent-guides.render = true;
        soft-wrap.enable = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-type"
          ];
          separator = "│";
        };
        file-picker = {
          hidden = false;
          git-ignore = true;
        };
      };
    };
    languages = {
      language-server.nil = {
        command = "${pkgs.nil}/bin/nil";
      };
      language-server.rust-analyzer = {
        command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      };
      language-server.qmlls = {
        command = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
        config.diagnostics = false;
      };
      language-server.pyright = {
        command = "${pkgs.pyright}/bin/pyright-langserver";
        args = [ "--stdio" ];
      };
      language-server.ruff = {
        command = "${pkgs.ruff}/bin/ruff";
        args = [ "server" ];
      };
      language-server.just-lsp = {
        command = "${pkgs.just-lsp}/bin/just-lsp";
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
          language-servers = [
            "pyright"
            "ruff"
          ];
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = [
              "format"
              "-"
            ];
          };
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
        }
        {
          name = "just";
          auto-format = true;
          language-servers = [ "just-lsp" ];
        }
        {
          name = "qml";
          auto-format = true;
          file-types = [ "qml" ];
          scope = "source.qml";
          language-servers = [ "qmlls" ];
          diagnostic-severity = "error";
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
