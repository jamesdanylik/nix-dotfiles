{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = " ";
      # for minimap.vim
      minimap_block_filetypes = [ "fugitive" "nerdtree" "tagbar" "fzf" "nvim-tree" "NvimTree" ];
      minimap_block_buftypes = [ "nofile" "nowrite" "quickfix" "terminal" "prompt" "NvimTree" ];
      minimap_close_filetypes = [ "startify" "netrw" "vim-plug" ];
    };
    options = {
      relativenumber = true;
      nu = true;
    };
    extraPackages = [
      pkgs.ripgrep
      pkgs.nixpkgs-fmt
      pkgs.code-minimap
    ];
    autoCmd = [
      {
        event = "BufWritePre";
        pattern = [ "*.py" "*.nix" ];
        callback = { __raw = "function() vim.lsp.buf.format() end"; };
      }
    ];
    keymaps = [
      {
        mode = "n";
        key = "<leader>pt";
        action = "<cmd>NvimTreeToggle<cr>";
        options.desc = "Toggle left sidebar file tree";
      }
      {
        mode = "n";
        key = "<leader>mm";
        action = "<cmd>MinimapToggle<cr>";
        options.desc = "Toggle right sidebar minimap";
      }
      {
        mode = "n";
        key = "<leader>ut";
        action = "<cmd>UndotreeToggle<cr>";
        options.desc = "Toggle right sidebar undotree";
      }
      {
        mode = "n";
        key = "<leader>do";
        action = "<cmd>DiffviewOpen<cr>";
        options.desc = "Open DiffView for current changeset";
      }
      {
        mode = "n";
        key = "<leader>df";
        action = "<cmd>DiffviewFileHistory<cr>";
        options.desc = "Open DiffView for current file";
      }
      {
        mode = "n";
        key = "<leader>dc";
        action = "<cmd>DiffviewClose<cr>";
        options.desc = "Close DiffView";
      }
    ];
    extraConfigLua = ''
      vim.opt.fillchars:append { diff = "╱" }
    '';
    extraPlugins = with pkgs.vimPlugins; [
      telescope-symbols-nvim # possibly switch this to icon-picker.nvim eventually
      minimap-vim
    ];
    colorschemes.tokyonight = {
      enable = true;
      style = "night";
    };
    plugins = {
      undotree = {
        enable = true;
        windowLayout = 3;
      };
      treesitter.enable = true;
      treesitter-context.enable = true;
      ts-autotag.enable = true;
      gitsigns.enable = true;
      fugitive.enable = true;
      diffview.enable = true;
      copilot-lua.enable = true;
      leap.enable = true;
      lualine = {
        enable = true;
        globalstatus = true;
        extensions = [ "nvim-tree" ];
      };
      harpoon = {
        enable = true;
        keymaps = {
          addFile = "<leader>ha";
          toggleQuickMenu = "<leader>hm";
          navFile = {
            "1" = "<C-1>";
            "2" = "<C-2>";
            "3" = "<C-3>";
            "4" = "<C-4>";
          };
        };
      };
      nvim-tree = {
        enable = true;
        updateFocusedFile.enable = true;
        view.preserveWindowProportions = true;
      };
      rainbow-delimiters = {
        enable = true;
        strategy = {
          default = "global";
        };
      };
      sniprun = {
        enable = true;
        interpreterOptions = {
          Generic = {
            NixConfig = {
              supported_filetypes = [ "nix" ];
              extension = ".nix";
              interpreter = "nix eval --extra-experimental-features nix-command --file";
              compiler = "";
              boilerplate_pre = "{";
              boilerplate_post = "}";
            };
          };
        };
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>pf" = "find_files";
          "<leader>ps" = "live_grep";
          "<leader>jd" = "lsp_definitions";
          "<leader>tt" = "builtin";
          "<leader>ti" = "symbols";
          "<leader>tk" = "keymaps";
        };
      };
      comment-nvim.enable = true;
      nvim-cmp = {
        enable = true;
        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<Tab>" = "cmp.mapping.confirm({ select = true })";
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "nvim_lsp_signature_help"; }
          { name = "path"; }
        ];
      };
      lsp = {
        enable = true;
        servers = {
          pylsp = {
            enable = true;
            settings = {
              plugins = {
                autopep8.enabled = true;
                mccabe.enabled = true;
                pycodestyle.enabled = true;
                pyflakes.enabled = true;
                black.enabled = true;
                rope.enabled = true;
              };
            };
          };
          nil_ls = {
            enable = true;
            extraOptions.settings = {
              nil = {
                formatting = {
                  command = [ "nixpkgs-fmt" ];
                };
                nix = {
                  maxMemoryMB = 4096;
                  flake = {
                    autoArchive = true;
                    autoEvalInputs = true;
                  };
                };
              };
            };
          };
          lua-ls = {
            enable = true;
          };
          tsserver = {
            enable = true;
          };
          eslint = {
            enable = true;
          };
          vuels = {
            enable = true;
          };
        };
      };
    };
  };
}
