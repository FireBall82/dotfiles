{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 80;
        offset = "10x40";
        origin = "bottom-right";
        font = "JetBrains Mono 10";
        format = "<b>%a</b>\\n%s\\n%b";
        corner_radius = 0;
        frame_width = 1;
        frame_color = "#ffffff";
        separator_color = "#333333";
        background = "#000000";
        foreground = "#ffffff";
        timeout = 5;
        alignment = "left";
        word_wrap = true;
        markup = "full";
        padding = 5;
        horizontal_padding = 2;
        gap_size = 2;
      };

      urgency_low = {
        background = "#000000";
        foreground = "#555555";
        frame_color = "#333333";
        timeout = 3;
      };

      urgency_normal = {
        background = "#000000";
        foreground = "#ffffff";
        frame_color = "#ffffff";
        timeout = 5;
      };

      urgency_critical = {
        background = "#000000";
        foreground = "#ffffff";
        frame_color = "#ff5555";
        timeout = 0;
      };
    };
  };
}
