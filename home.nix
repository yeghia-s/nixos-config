{ config, pkgs, ... }:

{
  home.username = "yeghia";
  home.homeDirectory = "/home/yeghia";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # user packages go here
  waybar        # status bar
  wofi          # app launcher
  dunst         # notifications
  hyprpaper     # wallpaper
  grim          # screenshots
  slurp         # screenshot selection
  ];
  programs.git = {
  enable = true;
  userName = "yeghia";
  userEmail = "yeghiasargis@yahoo.com";
};

home.pointerCursor = {
  gtk.enable = true;
  name = "Adwaita";
  package = pkgs.adwaita-icon-theme;
  size = 24;
};

wayland.windowManager.hyprland = {
  enable = true;
  settings = {
    monitor = ",preferred,auto,1";
    
    exec-once = [
      "waybar"
    ];

    input = {
      kb_layout = "us";
      touchpad.natural_scroll = true;
    };

    "$mod" = "SUPER";

    bind = [
      "$mod, Return, exec, alacritty"
      "$mod, Q, killactive"
      "$mod, M, exit"
      "$mod, Space, exec, wofi --show drun"
      "$mod, F, fullscreen"
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      "$mod, V, togglefloating"           # toggle floating window
      "$mod SHIFT, left, movewindow, l"   # move window left
      "$mod SHIFT, right, movewindow, r"  # move window right
      "$mod SHIFT, up, movewindow, u"     # move window up
      "$mod SHIFT, down, movewindow, d"   # move window down
      ", Print, exec, grim -g \"$(slurp)\" ~/screenshot.png"  # screenshot
    ];

    bindm = [
      "$mod, mouse:272, movewindow"   # Super + left click drag to move
      "$mod, mouse:273, resizewindow" # Super + right click drag to resize
    ];
  };
};

}
