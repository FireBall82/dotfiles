{
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      #inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    ];
    settings = {
      # Monitors
      monitor = [
        "eDP-1, 2560x1600@165.04, 0x0, 1.6"
        "HDMI-A-1, 1920x1080@119.88, -1080x0, 1, transform,3"
      ];

      xwayland = {
        force_zero_scaling = true;
      };
      cursor = {
        inactive_timeout = 0;
        no_hardware_cursors = true;
      };

      workspace =
        let
          edpWorkspaces = [
            1
            2
            6
            7
            8
            9
          ];
          hdmiWorkspaces = [
            3
            4
            5
            10
          ];
        in
        (map (n: "${toString n},monitor:eDP-1") edpWorkspaces)
        ++ (map (n: "${toString n},monitor:HDMI-A-1") hdmiWorkspaces);

      # Variables
      "$terminal" = "foot";
      "$fileManager" = "/home/diller/.config/hypr/scripts/yazi.sh";
      "$menu" = "fuzzel";
      "$mainMod" = "SUPER";

      # Autostart
      exec-once = [
        "noctalia-shell"
        "clipse --listen & playerctld daemon"
        "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"
      ];

      # Environment
      env = [
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_QPA_PLATFORM,wayland;xcb"
        "HYPRCURSOR_SIZE,15"
        "QT_STYLE_OVERRIDE,kvantum"
      ];

      # General
      general = {
        gaps_in = 2;
        gaps_out = 15;
        "col.active_border" = "rgba(ffffffff) rgba(ffffffff) 45deg";
        "col.inactive_border" = "rgba(000000ff)";
        border_size = 2;
        resize_on_border = false;
        allow_tearing = true;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 5;

        blur = {
          enabled = false;
          xray = false;
          special = false;
          new_optimizations = true;
          size = 2;
          passes = 1;
          brightness = 1;
          noise = 0.04;
          contrast = 1;
          popups = false;
          popups_ignorealpha = 0.6;
          input_methods = true;
          input_methods_ignorealpha = 0.8;
        };

        shadow = {
          enabled = false;
          # ignore_window = true;
          range = 30;
          offset = "0 2";
          render_power = 4;
          color = "rgba(00000010)";
        };

        dim_inactive = false;
        dim_strength = 0.025;
        dim_special = 0.07;
        active_opacity = 1;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1;
      };

      # Animations
      animations = {
        enabled = true;

        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.0"
          "winOut, 0.3, -0.3, 0, 1"
          "instant, 0, 0, 1, 1"
        ];

        animation = [
          "windowsIn, 1, 3, winIn, slide"
          "windowsOut, 1, 2, winOut, slide"
          "windowsMove, 1, 3, wind, slide"
          "border, 1, 5, default"
          "fade, 1, 4, wind"
          "workspaces, 1, 0.01, instant"
          "specialWorkspace, 1, 0.01, instant"
        ];
      };

      # Dwindle
      dwindle = {
        # pseudotile = true;
        preserve_split = true;
      };

      # Master
      master = {
        new_status = "master";
      };

      # Misc
      misc = {
        enable_anr_dialog = false;
        # vfr = false;
        vrr = 0;
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        disable_autoreload = false;
      };

      # Input
      input = {
        kb_layout = "us,ua";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        sensitivity = -0.3;

        touchpad = {
          natural_scroll = false;
        };
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.3;
      };

      render = {
        new_render_scheduling = false;
        direct_scanout = false;
      };

      debug = {
        disable_logs = false;
        overlay = false;
      };
      # layerrule = "ignore_alpha on, match:namespace noctalia-bar-content-eDP-1";
      # Keybindings
      bind =
        (builtins.genList (
          i:
          let
            n = toString (i + 1);
          in
          "$mainMod, ${n}, workspace, ${n}"
        ) 9)
        ++ (builtins.genList (
          i:
          let
            n = toString (i + 1);
          in
          "$mainMod SHIFT, ${n}, movetoworkspace, ${n}"
        ) 9)
        ++ [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, B, exec, firefox"
          "$mainMod, C, killactive,"
          "$mainMod, E, exec, $terminal $fileManager"
          "$mainMod, T, togglefloating,"
          "$mainMod, D, exec, $menu"
          # "$mainMod, P, pseudo,"
          "$mainMod, F, fullscreen, 0,"
          # "$mainMod, J, togglesplit,"
          "$mainMod, M, exec, hyprctl dispatch exit"
          # "$mainMod, W, hyprexpo:expo, toggle"
          "$mainMod, P, exec, hyprshot -m output"

          # Focus
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, equal, resizeactive, 50 0"
          "$mainMod, minus, resizeactive, -50 0"
          "SUPER SHIFT, equal, resizeactive, 0 50"
          "SUPER SHIFT, minus, resizeactive, 0 -50"

          # Special workspace
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # Scroll workspaces
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioStop, exec, playerctl stop"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
  home.file.".config/hypr/hyprpaper.conf".text = ''
         # Preload wallpaper into memory (optional)
    preload =/home/diller/Downloads/wallpapersden.com_black-hole-hd-digital_3840x1620.jpg
    wallpaper {
        monitor = eDP-1
        path =  /home/diller/Downloads/wallpapersden.com_black-hole-hd-digital_3840x1620.jpg
      fit_mode = cover
    }

    wallpaper {
        monitor = HDMI-A-5
        path = /home/diller/Downloads/wallpapersden.com_black-hole-hd-digital_3840x1620.jpg
       fit_mode = cover
    }

  '';
  home.file.".config/hypr/scripts/yazi.sh".text = ''
       #!${pkgs.fish}/bin/fish
    cat ~/.cache/wal/sequences
    yazi
     
  '';

  home.file.".config/hypr/scripts/yazi.sh".executable = true;

}
