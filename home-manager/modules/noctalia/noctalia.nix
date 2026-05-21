{ config, pkgs, ... }:
{
  home.file.".config/noctalia/settings.json" = {
    source = ./settings.json;
    force = true;
  };
}
