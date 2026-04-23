{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "yeghia";
    userEmail = "yeghiasargis@yahoo.com";
  };

  programs.mangohud.enable = true;  

programs.bash = {
  enable = true;
  shellAliases = {
    weather = "curl wttr.in/Toronto?format=3";
    home = "cd /etc/nixos/home";
    rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    config = "nvim /etc/nixos/configuration.nix";
    nsync = "cd ~/notes && git add -A && git commit -m \"sync $(date +%Y-%m-%d)\" && git push";
    inbox = "nvim ~/notes/inbox.md";
  };
  bashrcExtra = ''

    alias today='nvim ~/notes/daily/$(date +%Y-%m-%d).md'
    alias week='nvim ~/notes/weekly/$(date +%G-W%V).md'

    function edit-secret() {
      local BACKUP_DIR="$HOME/.secret-backups"
      mkdir -p "$BACKUP_DIR"
      age -d "$1" > /tmp/secret_edit && \
      cp /tmp/secret_edit /tmp/secret_edit.orig && \
      nvim /tmp/secret_edit
      if ! cmp -s /tmp/secret_edit /tmp/secret_edit.orig; then
        cp "$1" "$BACKUP_DIR/$(basename $1).$(date +%Y%m%d%H%M%S).bak" && \
        age -p /tmp/secret_edit > "$1" && \
        echo "Re-encrypted and backup saved."
      else
        echo "No changes, skipping re-encryption."
      fi
      shred -u /tmp/secret_edit
      shred -u /tmp/secret_edit.orig
    }

    function lastweek() {
      local label=$(date -d "last week" +%G-W%V)
      local monday=$(date -d "last week monday" +%Y-%m-%d)
      local sunday=$(date -d "$monday +6 days" +%Y-%m-%d)
      local target=~/notes/weekly/$label.md
      if [[ ! -f "$target" ]]; then
        cp ~/notes/templates/weekly.md "$target"
        sed -i "1s/.*/# $label ($monday – $sunday)/" "$target"
      fi
      nvim "$target"
    }
  '';
};

programs.alacritty = {
  enable = true;
  settings = {
    font = {
      normal.family = "JetBrainsMono Nerd Font";
      size = 12;
    };
    window = {
      opacity = 0.3;
      blur = true;
    };
    terminal.shell = {
      program = "bash";
      args = [ "-c" "fastfetch; exec $SHELL" ];
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

programs.zathura = {
  enable = true;
  options = {
    selection-clipboard = "clipboard";
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
              theme = "auto",
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
      {
      plugin = telekasten-nvim;
      type = "lua";
      config = ''
      require('telekasten').setup {
      home = vim.fn.expand("~/notes"),
      dailies = vim.fn.expand("~/notes/daily"),
      weeklies = vim.fn.expand("~/notes/weekly"),
      templates = vim.fn.expand("~/notes/templates"),
      template_new_daily = vim.fn.expand("~/notes/templates/daily.md"),
      template_new_weekly = vim.fn.expand("~/notes/templates/weekly.md"),
        }


        vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<cr>", { desc = "Find notes" })
        vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<cr>", { desc = "Search notes" })
        vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<cr>", { desc = "New note" })
        vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<cr>", { desc = "Daily note" })
        vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<cr>", { desc = "Follow link" })
        vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<cr>", { desc = "Backlinks" })
        vim.keymap.set("n", "<leader>zt", "<cmd>Telekasten show_tags<cr>", { desc = "Tags" })
        vim.keymap.set("n", "<leader>zp", "<cmd>Telekasten panel<cr>", { desc = "Panel" })
        vim.keymap.set("n", "<leader>zi", ":e ~/notes/inbox.md<cr>", { desc = "Inbox" })
        vim.keymap.set("n", "<leader>zw", "<cmd>Telekasten goto_thisweek<cr>", { desc = "Weekly note" })
      '';
    }
    {
      plugin = todo-comments-nvim;
      type = "lua";
      config = ''
        require('todo-comments').setup()
        vim.keymap.set('n', '<leader>zo', '<cmd>TodoTelescope<cr>', { desc = "Todo list" })
      '';
    }
    {
      plugin = render-markdown-nvim;
      type = "lua";
      config = ''
        require('render-markdown').setup({
          file_types = { 'markdown' },
        })
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
        modules-left = [ "hyprland/workspaces" "hyprland/language" "custom/calendar" ];
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
          "custom/calendar" = {
          exec = "khal list now 24h --format '{start-time} {title}' --day-format '' 2>/dev/null | head -1 | cut -c1-30";
          interval = 300;
          format = "󰃭  {}";
          on-click = "alacritty -e khal interactive";
          tooltip-format = "{}";
          tooltip = true;
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
      #language {
        color: #d3d3d3;
        padding: 0 10px;
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
      #custom-calendar {
      color: #a6e3a1;
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
