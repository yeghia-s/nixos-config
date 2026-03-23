{ config, pkgs, ... }:

let
  toggleMute = pkgs.writeShellScriptBin "toggle-mute" ''
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c '\[MUTED\]')
    echo $MUTED > /sys/class/leds/platform::mute/brightness
  '';

  toggleMicMute = pkgs.writeShellScriptBin "toggle-micmute" ''
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -c '\[MUTED\]')
    echo $MUTED > /sys/class/leds/platform::micmute/brightness
  '';
in
{
  home.packages = with pkgs; [
    wf-recorder       # screen recorder
    mpvpaper          # video wallpaper
    file              # file information
    vesktop           # discord client
    terraform         # VM through code
    age
    sops              # secrets
    strawberry        # music organizer/player
    easyeffects       # audio equalizer
    jellyfin-mpv-shim # jellyfin mpv player
    tree              # view file structure
    tmux              # sessions
    toggleMute        # toggle mute script
    toggleMicMute     # toggle mic mute
    starsector        # space game
    unzip             # zip file tool
    jq                # json
    wlr-randr         # resolution info
    steamguard-cli    # steam authenticator
    gamescope         # session compositor
    feishin           # music player (for navidrome)
    calibre           # epub reader
    qbittorrent       # torrent client
    wl-clipboard      # nvim clipboard copy
    rclone	          # remote sync
    wofi              # app launcher
    dunst             # notifications
    grim              # screenshots
    slurp             # screenshot selection
    networkmanagerapplet  # WiFi/network GUI
    brightnessctl     # brightness
    wev               # monitor key events
    nerd-fonts.jetbrains-mono  # icons
    font-awesome      # fonts
    libreoffice       # office tools
    hyprlock          # lockscreen
    hypridle
    gcc               # C++ compiler
    cmake             # and other dev packages
    clang-tools
    gnumake
    pkg-config
    SDL2
    mesa
    libGL
    libGLU
    glfw
    glew
    glm               # math library
    python3           # python
    pyright           # python language server
    ripgrep
    imv               # image viewer
    hyprsunset        # night light
    zathura           # pdf viewing
    keepassxc         # password manager
    chromium          # web browser
    obsidian          # note-taking
    spotify-player    # terminal spotify
    mpv               # video, webcam
    w3m
    aichat
  ];
}
