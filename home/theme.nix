{ config, pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  home.file.".config/spotify-player/theme.toml".text = ''
  [[themes]]
  name = "catppuccin-mocha"
  [themes.palette]
  background = "#1e1e2e"
  foreground = "#cdd6f4"
  black = "#45475a"
  blue = "#89b4fa"
  cyan = "#89dceb"
  green = "#a6e3a1"
  magenta = "#cba4f7"
  red = "#f38ba8"
  white = "#bac2de"
  yellow = "#f9e2af"
  bright_black = "#585b70"
  bright_blue = "#89b4fa"
  bright_cyan = "#89dceb"
  bright_green = "#a6e3a1"
  bright_magenta = "#cba4f7"
  bright_red = "#f38ba8"
  bright_white = "#a6adc8"
  bright_yellow = "#f9e2af"
'';

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
}
