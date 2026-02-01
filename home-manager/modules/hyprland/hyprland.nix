{
  config,
  pkgs,
  lib,
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
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    ];
    settings = {
      # Monitors
      monitor = [
        "eDP-1, 2560x1600@120, 0x0, 1.6"
        "HDMI-A-5, 1920x1080@120, -1080x0, 1, transform,3"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      workspace = [
        "1,monitor:eDP-1"
        "2,monitor:eDP-1"
        "3,monitor:HDMI-A-5"
        "4,monitor:HDMI-A-5"
        "5,monitor:HDMI-A-5"
        "6,monitor:eDP-1"
        "7,monitor:eDP-1"
        "8,monitor:eDP-1"
        "9,monitor:eDP-1"
        "10,monitor:HDMI-A-5"
      ];

      # Variables
      "$terminal" = "foot";
      "$fileManager" = "/home/diller/.config/hypr/scripts/yazi.sh";
      "$menu" = "fuzzel";
      "$mainMod" = "SUPER";

      # Autostart
      exec-once = [
        "noctalia-shell & clipse --listen & playerctld daemon"
        "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"
      ];

      # Environment
      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,15"
      ];

      # General
      general = {
        gaps_in = 2;
        gaps_out = 15;
        border_size = 2;
        "col.active_border" = "rgba(6F92C6ee) rgba(3D5988ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = true;
        layout = "dwindle";
      };

      # Plugin settings
      plugin = {
        hyprbars = {
          bar_height = 0;
          bar_color = "rgba(1e1e1e95)";
          bar_text_size = 10;
          bar_text_font = "Jetbrains Mono Nerd Font Mono Bold";
          bar_button_padding = 5;
          bar_padding = 6;
          bar_precedence_over_border = false;
          hyprbars-button = [
            "rgb(659df7), 10, , hyprctl dispatch killactive"
            "rgb(65b3f7), 10, , hyprctl dispatch fullscreen 1"
            "rgb(65f7ed), 10, , hyprctl dispatch togglefloating"
          ];
        };
        hyprexpo = {
          columns = 3;
          rows = 3;
          gap_size = 2;
          bg_col = "rgb(111111)";
          workspace_method = "workspace 1";
          enable_scroll = false;
        };
      };

      # Decoration
      decoration = {
        rounding = 5;

        blur = {
          enabled = true;
          xray = false;
          special = false;
          new_optimizations = true;
          size = 3;
          passes = 2;
          brightness = 1;
          noise = 0.04;
          contrast = 1;
          popups = false;
          popups_ignorealpha = 0.6;
          input_methods = true;
          input_methods_ignorealpha = 0.8;
        };

        shadow = {
          enabled = true;
          ignore_window = true;
          range = 30;
          offset = "0 2";
          render_power = 4;
          color = "rgba(00000010)";
        };

        dim_inactive = false;
        dim_strength = 0.025;
        dim_special = 0.07;
        active_opacity = 0.95;
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
        pseudotile = true;
        preserve_split = true;
      };

      # Master
      master = {
        new_status = "master";
      };

      # Misc
      misc = {
        enable_anr_dialog = false;
        vfr = true;
        vrr = 1;
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
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

      # Keybindings
      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, B, exec, firefox"
        "$mainMod, C, killactive,"
        "$mainMod, E, exec, $terminal $fileManager"
        "$mainMod, T, togglefloating,"
        "$mainMod, D, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, M, exec, hyprctl dispatch exit"
        "$mainMod, R, submap, resize"

        # Focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

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

    # Resize submap
    extraConfig = ''
      submap = resize
      bind = , left,  resizeactive, -20 0
      bind = , right, resizeactive,  20 0
      bind = , up,    resizeactive,  0 -20
      bind = , down,  resizeactive,  0  20
      bind = SHIFT, left, resizeactive, -60 0
      bind = SHIFT, right, resizeactive,  60 0
      bind = SHIFT, up, resizeactive,  0 -60
      bind = SHIFT, down, resizeactive,  0  60
      bind = , escape, submap, reset
      bind = , return, submap, reset
      submap = reset
    '';
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
       #!/bin/sh
    cat ~/.cache/wal/sequences
    yazi
     
  '';

  home.file.".config/hypr/scripts/yazi.sh".executable = true;
}
