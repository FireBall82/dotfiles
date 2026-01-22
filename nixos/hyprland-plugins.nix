{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  hyprPluginPkgs = inputs.hyprland-plugins.packages.${pkgs.system};
  hyprPluginDir = pkgs.symlinkJoin {
    name = "hyrpland-plugins";
    paths = with hyprPluginPkgs; [
      hyprbars
      hyprexpo
    ];
  };
in
{
  environment.sessionVariables = {
    HYPR_PLUGIN_PATH = "${hyprPluginDir}/lib";
  };
}
