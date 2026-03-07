{ config, pkgs, ... }:

{
  home.username = "yeghia";
  home.homeDirectory = "/home/yeghia";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # user packages go here
  ];
  programs.git = {
  enable = true;
  userName = "yeghia";
  userEmail = "yeghiasargis@yahoo.com";
};
}
