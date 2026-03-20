{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "FireBall82";
        email = "romennegrik82@gmail.com";
      };
    };
  };
  home.packages = with pkgs; [
    lazygit
    gh
  ];
}
