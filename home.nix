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
  networkmanagerapplet	# WiFi/network GUI
  brightnessctl	# brightness
  wev		# monitor key events
  nerd-fonts.jetbrains-mono	# icons
  font-awesome	# fonts
  wl-clipboard	# save screenshot to clipboard
  ];
  programs.git = {
  enable = true;
  userName = "yeghia";
  userEmail = "yeghiasargis@yahoo.com";
};

xdg.portal = {
  enable = true;
  extraPortals = [ 
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
  ];
};

home.pointerCursor = {
  gtk.enable = true;
  name = "Adwaita";
  package = pkgs.adwaita-icon-theme;
  size = 24;
};

gtk = {
  enable = true;
  theme = {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };
  gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
};

dconf.settings = {
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };
};

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

wayland.windowManager.hyprland = {
  enable = true;
  settings = {
    monitor = ",preferred,auto,1";
    
    exec-once = [
      "waybar"
      "nm-applet --indicator"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
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
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      ", Print, exec, bash -c 'FILE=~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png && grim -g \"$(slurp)\" $FILE && wl-copy < $FILE'"
      # Audio
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      # Brightness
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"

      # Display (F7)
      ", XF86Display, exec, hyprctl keyword monitor ,preferred,auto,1"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"   # Super + left click drag to move
      "$mod, mouse:273, resizewindow" # Super + right click drag to resize
    ];
  };
};

}
