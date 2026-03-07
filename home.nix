{ config, pkgs, ... }:

{
  home.username = "yeghia";
  home.homeDirectory = "/home/yeghia";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # user packages go here
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
  libreoffice	# office tools
  hyprlock	# lockscreen
  hypridle
  gcc		# C++ compiler
  cmake		# and other dev packages
  clang-tools
  gnumake
  pkg-config
  SDL2
  mesa
  libGL
  libGLU
  glfw
  glew
  aerc		# terminal email
  python3   # python
  pyright   # python language server
  ripgrep
  imv       # image viewer
  hyprsunset    # night light
  zathura   # pdf viewing
  ];
  programs.git = {
  enable = true;
  userName = "yeghia";
  userEmail = "yeghiasargis@yahoo.com";
};

programs.aerc = {
  enable = true;
  extraConfig = {
    ui = {
      timestamp-format = "2006-01-02 15:04";
      this-day-time-format = "15:04";
      sidebar-width = 25;
    };
    compose = {
      editor = "nvim";
    };
  };
};

# neovim customization
programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;


    plugins = with pkgs.vimPlugins; [
    {
      plugin = catppuccin-nvim;
      config = ''
        colorscheme catppuccin-mocha
      '';
    }

    # Indent guides
{
  plugin = indent-blankline-nvim;
  type = "lua";
  config = ''
    require('ibl').setup()
  '';
}

# Git signs
{
  plugin = gitsigns-nvim;
  type = "lua";
  config = ''
    require('gitsigns').setup {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    }
  '';
}

# Auto pairs
{
  plugin = nvim-autopairs;
  type = "lua";
  config = ''
    require('nvim-autopairs').setup()
  '';
}

# LSP config

{
  plugin = nvim-lspconfig;
  type = "lua";
  config = ''
    vim.lsp.config('clangd', {
      on_attach = function(client, bufnr)
        local opts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      end,
    })
    vim.lsp.enable('clangd')
    
    vim.lsp.config('pyright', {
      on_attach = function(client, bufnr)
        local opts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      end,
    })
    vim.lsp.enable('pyright')
  '';
}


# Autocompletion
{
  plugin = nvim-cmp;
  type = "lua";
  config = ''
    local cmp = require('cmp')
    cmp.setup {
      mapping = cmp.mapping.preset.insert {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      },
      sources = {
        { name = "nvim_lsp" },
      },
    }
  '';
}

# LSP completion source
{
  plugin = cmp-nvim-lsp;
  type = "lua";
  config = "";
}

    {
  plugin = lualine-nvim;
  type = "lua";
  config = ''
    require('lualine').setup {
      options = {
        theme = "catppuccin",
        component_separators = "|",
        section_separators = "",
      };
      sections = {
        lualine_a = {"mode"},
        lualine_b = {"branch", "diff", "diagnostics"},
        lualine_c = {"filename"},
        lualine_x = {"encoding", "filetype"},
        lualine_y = {"progress"},
        lualine_z = {"location"},
      },
    }
  '';
}

    {
  plugin = plenary-nvim;
  type = "lua";
  config = ''
    require('plenary')
  '';
}

    # File tree
{
  plugin = nvim-tree-lua;
  type = "lua";
  config = ''
    require('nvim-tree').setup()
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
  '';
}

# Icons for file tree
{
  plugin = nvim-web-devicons;
  type = "lua";
  config = ''
    require('nvim-web-devicons').setup()
  '';
}

# Fuzzy finder
{
  plugin = telescope-nvim;
  type = "lua";
  config = ''
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files)
    vim.keymap.set('n', '<leader>fg', builtin.live_grep)
    vim.keymap.set('n', '<leader>fb', builtin.buffers)
  '';
}

    {
  plugin = nvim-treesitter.withAllGrammars;
  type = "lua";
  config = ''
    require('nvim-treesitter').setup {
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    }
  '';
}
  ];
  
  extraConfig = ''
    set number
    set relativenumber
    set tabstop=4
    set shiftwidth=4
    set expandtab
    set smartindent
    set wrap
    set ignorecase
    set smartcase
    set termguicolors
    set scrolloff=8
    set signcolumn=yes
    set updatetime=50
    let mapleader = " "
  '';
};

xdg.portal = {
  enable = true;
  extraPortals = [ 
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
  ];
};

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


programs.waybar = {
  enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "backlight" "battery" "network" "tray" ];

      "hyprland/workspaces" = {
        format = "{id}";
        on-click = "activate";
      };

      "clock" = {
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
      };

      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-icons = ["" "" "" "" ""];
      };

      "network" = {
        format-wifi = " {essid}";
        format-ethernet = " {ipaddr}";
        format-disconnected = "disconnected";
        tooltip-format = "{ifname}: {ipaddr}";
      };

      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = " muted";
        format-icons = {
          default = ["" "" ""];
        };
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      "backlight" = {
        format = " {percent}%";
      };

      "tray" = {
        spacing = 10;
      };
    };
  };
    style = ''
    * {
      font-family : "JetBrainsMono Nerd Font";
      font-size: 15px;
      border: none;
      border-radius: 0;
      min-height: 0;
    }

    window#waybar {
      background-color: rgba(20, 20, 20, 0.9);
      color: #ffffff;
    }

    #workspaces button {
      padding: 0 8px;
      color: #6c7086;
      background: transparent;
    }

    #workspaces button.active {
      color: #cdd6f4;
      border-bottom: 2px solid #89b4fa;
    }

    #clock {
      color: #ffffff;
      padding: 0 10px;
    }

    #battery {
      color: #b9f5b0;
      padding: 0 10px;
    }

    #battery.warning {
      color: #f9e2af;
    }

    #battery.critical {
      color: #f38ba8;
    }

    #network {
      color: #a8eeff;
      padding: 0 10px;
    }

    #pulseaudio {
      color: #dbb6ff;
      padding: 0 10px;
    }

    #backlight {
      color: #ffe566;
      padding: 0 10px;
    }

    #tray {
      padding: 0 10px;
    }
  '';
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
      "$mod, N, exec, pkill hyprsunset || hyprsunset -t 3500"
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
