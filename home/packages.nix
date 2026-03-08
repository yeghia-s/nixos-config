{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    rclone	      # remote sync
    wofi              # app launcher
    dunst             # notifications
    hyprpaper         # wallpaper
    grim              # screenshots
    slurp             # screenshot selection
    networkmanagerapplet  # WiFi/network GUI
    brightnessctl     # brightness
    wev               # monitor key events
    nerd-fonts.jetbrains-mono  # icons
    font-awesome      # fonts
    wl-clipboard      # save screenshot to clipboard
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
    mpv               # webcam
    w3m
    aichat
  ];
}
