{ config, pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./hyprland.nix
    ./theme.nix
  ];

  home.username = "yeghia";
  home.homeDirectory = "/home/yeghia";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
