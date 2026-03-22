{ config, pkgs, lib, ... }:

{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/vdirsyncer.yaml;
    secrets = {
      vdirsyncer_client_id = {};
      vdirsyncer_client_secret = {};
      vdirsyncer_baikal_password = {};
    };
  };

  home.packages = with pkgs; [ vdirsyncer khal ];

  # vdirsyncer config references the sops-decrypted secret paths at runtime
home.activation.vdirsyncerConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
  mkdir -p "${config.home.homeDirectory}/.config/vdirsyncer"
  cat > "${config.home.homeDirectory}/.config/vdirsyncer/config" <<EOF
  [general]
  status_path = "${config.home.homeDirectory}/.local/share/vdirsyncer/status/"

  [pair google_calendar]
  a = "google_remote"
  b = "google_local"
  collections = ["from a", "from b"]
  conflict_resolution = "a wins"

  [storage google_remote]
  type = "google_calendar"
  token_file = "${config.home.homeDirectory}/.local/share/vdirsyncer/google_token"
  client_id = "$(cat ${config.sops.secrets.vdirsyncer_client_id.path})"
  client_secret = "$(cat ${config.sops.secrets.vdirsyncer_client_secret.path})"

  [storage google_local]
  type = "filesystem"
  path = "${config.home.homeDirectory}/.local/share/vdirsyncer/calendars/"
  fileext = ".ics"

  [pair baikal]
  a = "baikal_remote"
  b = "baikal_local"
  collections = ["from a"]
  conflict_resolution = "a wins"

  [storage baikal_remote]
  type = "caldav"
  url = "https://dav.armstream.stream/dav.php/calendars/yeghiasargis@yahoo.com/"
  username = "yeghiasargis@yahoo.com"
  password = "$(cat ${config.sops.secrets.vdirsyncer_baikal_password.path})"

  [storage baikal_local]
  type = "filesystem"
  path = "${config.home.homeDirectory}/.local/share/vdirsyncer/baikal/"
  fileext = ".ics"
  EOF
'';

  xdg.configFile."khal/config".text = ''
    [calendars]
   # [[personal]]
   # path = ${config.home.homeDirectory}/.local/share/vdirsyncer/calendars/*
   # type = discover
   # color = light blue

    [[baikal]]
    path = ${config.home.homeDirectory}/.local/share/vdirsyncer/baikal/*
    type = discover
    color = light green

    [default]
    default_calendar = default 
    highlight_event_days = true

    [locale]
    timeformat = %H:%M
    dateformat = %Y-%m-%d
    datetimeformat = %Y-%m-%d %H:%M
  '';

  systemd.user.services.vdirsyncer = {
    Unit.Description = "vdirsyncer calendar sync";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
    };
  };

  systemd.user.timers.vdirsyncer = {
    Unit.Description = "vdirsyncer calendar sync timer";
    Timer = {
      OnCalendar = "*:0/15";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
