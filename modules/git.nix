{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        userName = "FireBall82";
        userEmail = "romennegrik82@gmail.com";
      };
      extraConfig = {
        init.defaultBranch = "main"; # This line
        push.autoSetupRemote = true;
      };
    };
  };
  home.packages = with pkgs; [
    lazygit
    gh
  ];
}
