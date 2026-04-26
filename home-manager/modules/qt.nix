{ config, pkgs, ... }:

{
  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "qt6ct";
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  home.packages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct
    qt5.qtwayland
    qt6.qtwayland
    kdePackages.qtstyleplugin-kvantum
  ];

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  # Qt palette (only fallback apps)
  xdg.configFile."qt6ct/colors/Pure.conf".text = ''
    [ColorScheme]
    active_colors=#ffffff,#000000,#0f0f0f,#ffffff,#000000,#ffffff,#ffffff,#000000,#ffffff,#ffffff,#000000,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff,#ffffff
    inactive_colors=#c0c0c0,#000000,#0f0f0f,#c0c0c0,#000000,#c0c0c0,#c0c0c0,#000000,#c0c0c0,#c0c0c0,#000000,#c0c0c0,#c0c0c0,#c0c0c0,#c0c0c0,#c0c0c0
    disabled_colors=#7a7a7a,#000000,#0f0f0f,#7a7a7a,#000000,#7a7a7a,#7a7a7a,#000000,#7a7a7a,#7a7a7a,#000000,#7a7a7a,#7a7a7a,#7a7a7a,#7a7a7a,#7a7a7a
  '';
}
