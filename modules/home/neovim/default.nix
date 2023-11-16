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
    # keymaps = [
    #   {
    #     mode = "n";
    #     key = "<leader>pt";
    #     action = "<cmd>NvimTreeToggle<cr>";
    #     desc = "Toggle the visibility of the file tree in the left sidebar.";
    #   }
    #   {
    #     mode = "n";
    #     key = "<leader>mm";
    #     action = "<cmd>MinimapToggle<cr>";
    #     desc = "Toggle the visibility of the file minimap in the right sidebar.";
    #   }
    # ];
    extraConfigLua = ''
      vim.api.nvim_set_keymap('v', 'f', '<Plug>SnipRun', {silent = true})
      vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>SnipRunOperator', {silent = true})
      vim.api.nvim_set_keymap('n', '<leader>ff', '<Plug>SnipRun', {silent = true})
      vim.api.nvim_set_keymap('n', '<leader>mm', "<cmd>MinimapToggle<cr>", {})
      vim.api.nvim_set_keymap('n', '<leader>pt', '<cmd>NvimTreeToggle<cr>', {})
      -- require('aerial').setup({})
    '';
    extraPlugins = with pkgs.vimPlugins; [
      telescope-symbols-nvim # possibly switch this to icon-picker.nvim eventually
      minimap-vim
      #aerial-nvim
    ];
    colorschemes.tokyonight = {
      enable = true;
      style = "night";
    };
    plugins = {
      undotree.enable = true;
      treesitter.enable = true;
      treesitter-context.enable = true;
      ts-autotag.enable = true;
      copilot-lua.enable = true;
      nvim-tree = {
        enable = true;
        updateFocusedFile.enable = true;
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
            settings = {
              formatting = {
                command = [ "nixpkgs-fmt" ];
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
      }; # End Lsp
    }; # End Nvim Plugins
  };
}
