{ config, pkgs, ... }:
{
#  home.file."scripts/wallpaper.sh" = {
#    executable = true;
#    text = ''
#      #!/bin/sh
#      mpvpaper -o "--loop-file=inf --panscan=1.0 no-audio --vo=gpu --hwdec=no" "*" /home/yeghia/Videos/64729-510542342_medium.mp4
#    '';
#  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
        };
      };
      animations = {
      enabled = true;
      bezier = [
        "smoothOut, 0.36, 0, 0.66, -0.56"
        "overshot, 0.05, 0.9, 0.1, 1.05"
      ];
      animation = [
        "windows, 1, 5, overshot, slide"
        "windowsOut, 1, 4, smoothOut, slide"
        "fade, 1, 4, default"
        "workspaces, 1, 4, overshot, slide"
      ];
    };
      monitor = ",preferred,auto,1";
      exec-once = [
        "waybar"
        "nm-applet --indicator"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "swww-daemon && swww img /home/yeghia/Pictures/wallpapers/nixos.wallpaper3.jpg"
        "/run/current-system/sw/bin/gnome-keyring-daemon --start --components=secrets"
      #  "bash /home/yeghia/scripts/wallpaper.sh"
      ];
      misc = {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      };
      input = {
        kb_layout = "us,ca,de,am";
        kb_variant = ",,,phonetic";
        kb_options = "grp:alt_shift_toggle";
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
        "$mod, V, togglefloating"
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"
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
        "$mod, N, exec, pkill hyprsunset || hyprsunset -t 3500"
        "$mod, L, exec, hyprlock"
        "$mod, P, exec, playerctl play-pause"
        "$mod, K, exec, playerctl next"
        "$mod, J, exec, playerctl previous"
        ", Print, exec, bash -c 'FILE=~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png && grim -g \"$(slurp)\" $FILE && wl-copy < $FILE'"
        ", XF86AudioMute, exec, toggle-mute"
        ", XF86AudioMicMute, exec, toggle-micmute"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86Display, exec, hyprctl keyword monitor ,preferred,auto,1"
      ];
      binde = [
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
 };
}
