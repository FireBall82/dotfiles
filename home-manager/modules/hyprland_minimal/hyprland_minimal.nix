# homes/hyprland-minimal.nix
{ pkgs, ... }:
{
  # launch script
  home.file.".local/bin/hyprland-minimal" = {
    text = ''
      #!/bin/sh
        export HYPRLAND_CONFIG=$HOME/.config/hypr/hyprland-minimal.conf
        exec start-hyprland'';
    executable = true;
  };

  # raw hyprland config — no HM module, just a plain file
  home.file.".config/hypr/hyprland-minimal.conf".text = ''
        monitor = eDP-1, 2560x1600@165.04, 0x0, 1.6
        monitor = HDMI-A-1, 1920x1080@119.88, -1080x0, 1, transform, 3
        monitor = , preferred, auto, 1

        xwayland {
          force_zero_scaling = true
        }

        cursor {
          inactive_timeout = 0
          no_hardware_cursors = true
        }

        $terminal = foot
        $fileManager = /home/diller/.config/hypr/scripts/yazi.sh
        $menu = fuzzel
        $mainMod = SUPER
        exec-once =hyprpaper --config /home/diller/.config/hypr/hyprpaper_minimal.conf
        exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland
        exec-once = /run/current-system/sw/libexec/polkit-gnome-authentication-agent-1
        exec-once = sleep 2 && qs -p .config/quickshell/shell.qml 
    exec-once = dunst
        env = QT_QPA_PLATFORMTHEME,qt5ct
        env = QT_QPA_PLATFORM,wayland;xcb
        env = HYPRCURSOR_SIZE,15
        env = XCURSOR_SIZE,24
        env = QT_STYLE_OVERRIDE,Fusion

        general {
          gaps_in = 2
          gaps_out = 4
          col.active_border = rgba(ffffffff)
          col.inactive_border = rgba(000000ff)
          border_size = 1
          layout = dwindle
          allow_tearing = true
        }

        decoration {
          rounding = 0
          blur {
            enabled = false
          }
          shadow {
            enabled = false
          }
          dim_inactive = false
          active_opacity = 1
          inactive_opacity = 1
        }

        animations {
          enabled = false
        }

        dwindle {
          preserve_split = true
        }

        misc {
          enable_anr_dialog = false
          vrr = 0
          force_default_wallpaper = 0
          disable_hyprland_logo = true
          animate_manual_resizes = false
          animate_mouse_windowdragging = false
        }

        input {
          kb_layout = us,ua
          kb_options = grp:alt_shift_toggle
          follow_mouse = 1
          sensitivity = -0.3
          touchpad {
            natural_scroll = false
          }
        }

        render {
          new_render_scheduling = true
          direct_scanout = true
         }
        # workspace binds
        bind = $mainMod, 1, workspace, 1
        bind = $mainMod, 2, workspace, 2
        bind = $mainMod, 3, workspace, 3
        bind = $mainMod, 4, workspace, 4
        bind = $mainMod, 5, workspace, 5
        bind = $mainMod, 6, workspace, 6
        bind = $mainMod, 7, workspace, 7
        bind = $mainMod, 8, workspace, 8
        bind = $mainMod, 9, workspace, 9
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9

        bind = $mainMod, Q, exec, $terminal
        bind = $mainMod, E, exec, $terminal $fileManager
        bind = $mainMod, B, exec, firefox
        bind = $mainMod, C, killactive,
        bind = $mainMod, T, togglefloating,
        bind = $mainMod, D, exec, $menu
        bind = $mainMod, F, fullscreen, 0
        bind = $mainMod, M, exec, hyprctl dispatch exit
        bind = $mainMod, P, exec, hyprshot -m output
        bind = $mainMod SHIFT, P, exec, hyprshot -m region
        bind = $mainMod, left, movefocus, l
        bind = $mainMod, right, movefocus, r
        bind = $mainMod, up, movefocus, u
        bind = $mainMod, down, movefocus, d
        bind = $mainMod, equal, resizeactive, 50 0
        bind = $mainMod, minus, resizeactive, -50 0
        bind = SUPER SHIFT, equal, resizeactive, 0 50
        bind = SUPER SHIFT, minus, resizeactive, 0 -50
        bind = $mainMod, S, togglespecialworkspace, magic
        bind = $mainMod SHIFT, S, movetoworkspace, special:magic
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
        bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-

        bindl = ,XF86AudioPlay, exec, playerctl play-pause
        bindl = ,XF86AudioStop, exec, playerctl stop
        bindl = ,XF86AudioNext, exec, playerctl next
        bindl = ,XF86AudioPrev, exec, playerctl previous
  '';
  home.file.".config/hypr/hyprpaper_minimal.conf".text = ''
     
    preload =/home/diller/Pictures/Wallpapers/0-dot-hands.jpg
           wallpaper {
           monitor = eDP-1
           path =  /home/diller/Pictures/Wallpapers/0-dot-hands.jpg
         fit_mode = cover
       }

       wallpaper {
           monitor = HDMI-A-5
           path = /home/diller/Pictures/Wallpapers/0-dot-hands.jpg
                     fit_mode = cover
       }
  '';
}
