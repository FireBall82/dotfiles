{ config, pkgs, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        shell = "${pkgs.fish}/bin/fish";
        font = "JetBrainsMono Nerd Font:size=11:slant=italic";
        pad = "12x12";
        letter-spacing = "0.5";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      scrollback = {
        lines = 10000;
      };
      cursor = {
        style = "beam";
        blink = "yes";
        blink-rate = "500";
      };
      colors = {
        alpha = "0.9";
        background = "000000";
        foreground = "ffffff";
        regular0 = "000000";
        regular1 = "444444";
        regular2 = "666666";
        regular3 = "888888";
        regular4 = "aaaaaa";
        regular5 = "cccccc";
        regular6 = "dddddd";
        regular7 = "ffffff";
        bright0 = "222222";
        bright1 = "555555";
        bright2 = "777777";
        bright3 = "999999";
        bright4 = "bbbbbb";
        bright5 = "dddddd";
        bright6 = "eeeeee";
        bright7 = "ffffff";
      };
    };
  };
}
