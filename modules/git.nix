{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        userName = "FireBall82";
        userEmail = "romennegrik82@gmail.com";
      };
    };
  };
  home.packages = with pkgs; [
    lazygit
    gh
  ];
}
