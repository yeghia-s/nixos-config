# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # fingerprint scanner
      ./fingerprint.nix 
    ];
  
  # steam
  programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
#   services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yeghia = {
    isNormalUser = true;
    description = "Yeghia";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

services.gnome.gnome-keyring.enable = true;
services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-password --cmd 'uwsm start hyprland-uwsm.desktop'";
      user = "greeter";
    };
  };
};

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  kdePackages.breeze-icons
  kdePackages.breeze
  acpi
  libsForQt5.qt5.qtquickcontrols2
  libsForQt5.qt5.qtgraphicaleffects
  gnome-icon-theme
  hicolor-icon-theme
  thunderbird
  spotify
  wget
  neovim
  git
  alacritty
  ];

services.udev.extraRules = ''
  SUBSYSTEM=="leds", KERNEL=="platform::mute", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chmod 0666 /sys/class/leds/%k/brightness"
  SUBSYSTEM=="leds", KERNEL=="platform::micmute", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chmod 0666 /sys/class/leds/%k/brightness"
'';

services.syncthing = {
  enable = true;
  user = "yeghia";
  dataDir = "/home/yeghia";
  configDir = "/home/yeghia/.config/syncthing";
  openDefaultPorts = true;
};

systemd.sleep.settings.Sleep = {
  HibernateDelaySec = "3600";
};

services.logind = {
  lidSwitch = "suspend";
  lidSwitchExternalPower = "suspend";
};

  gtk.iconCache.enable = true;

  xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
};

environment.shellAliases = {
  weather = "curl wttr.in/Toronto?format=3";
  home = "cd /etc/nixos/home";
  yeghiserver = "ssh yeghia@yeghiserver.duckdns.org";
  rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
  config = "nvim /etc/nixos/configuration.nix";
};

hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
};

programs.hyprland = {
  enable = true;
  xwayland.enable = true;
  withUWSM = true;
};

services.displayManager.defaultSession = "hyprland-uwsm";

# services.displayManager.sddm = {
#   enable = true;
#   wayland.enable = true;
#   theme = "breeze";
# };

services.envfs.enable = true; # Often helps with path issues
xdg.icons.enable = true; # Ensures icon theme caches are updated

services.power-profiles-daemon.enable = false;

services.tlp = {
  enable = true;
  settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    START_CHARGE_THRESH_BAT0 = 20;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };
};

services.thermald.enable = true;
powerManagement.powertop.enable = true;

hardware.cpu.intel.updateMicrocode = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
      enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
