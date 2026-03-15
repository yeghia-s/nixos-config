{ config, pkgs, ... }:
{
  systemd.user.services.hyprlock-on-lock = {
    Unit = {
      Description = "Lock screen on systemd lock signal";
      After = "graphical-session.target";
    };
    Service = {
      ExecStart = "${pkgs.hyprlock}/bin/hyprlock";
      Type = "oneshot";
    };
    Install.WantedBy = [ "lock.target" ];
  };
  
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
      ];
    };
  };
}
