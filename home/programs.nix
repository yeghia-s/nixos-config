{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "yeghia";
    userEmail = "yeghiasargis@yahoo.com";
  };

  programs.mangohud.enable = true;  

programs.alacritty = {
  enable = true;
  settings = {
    font = {
      normal.family = "JetBrainsMono Nerd Font";
      size = 12;
    };
  };
};

programs.mpv = {
  enable = true;
  config = {
    gpu-api = "vulkan";
    gpu-context = "waylandvk";
    vo = "gpu-next";
    hwdec = "auto-safe";
  };
};

  programs.aerc = {
    enable = true;
    extraConfig = {
      general = {
        mailcap-file = "~/.config/aerc/mailcap";
      };
      filters = {
        "text/html" = "${pkgs.aerc}/libexec/aerc/filters/html";
        "text/plain" = "${pkgs.aerc}/libexec/aerc/filters/plaintext";
      };
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

  programs.direnv = {
  enable = true;
  nix-direnv.enable = true;
};

  programs.neovim = {
    enable = true;
    extraLuaConfig = ''
    vim.opt.clipboard = "unnamedplus"
  '';
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
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          require('ibl').setup()
        '';
      }
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
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require('nvim-autopairs').setup()
        '';
      }
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
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require('nvim-tree').setup()
          vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
        '';
      }
      {
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
          require('nvim-web-devicons').setup()
        '';
      }
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
          format = "<span font-size='12pt' rise='-2000'>{icon}</span> <span rise='-4500'>{capacity}%</span>";
          format-icons = ["󰁺" "󰁼" "󰁾" "󰂀" "󰂂"];
        };
        "network" = {
          format-wifi = " {essid}";
          format-ethernet = " {ipaddr}";
          format-disconnected = "disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };
        "pulseaudio" = {
          format = "<span font-size='20pt' rise='-2000'>{icon}</span> {volume}%";
          format-muted = "<span font-size='20pt' rise='-2000'></span> muted";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "backlight" = {
          format = "<span font-size='20pt' rise='-2000'>󰃟</span> {percent}%";
        };
        "tray" = {
          spacing = 10;
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font Mono", "JetBrainsMono Nerd Font", monospace;
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

}
