{ self, inputs, ... }:
{
  flake.nixosModules.neovim =
    { pkgs, lib, ... }:
    {
      programs.neovim = {
        # inherit pkgs;
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      wrappers.control_type = "exclude";
      wrappers.packages.neovim = true;

      packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
        inherit pkgs;

        extraPackages = with pkgs; [
          rust-analyzer
          clang-tools
          nixd
          gopls
          zls
          lua-language-server
          ripgrep
          fd
        ];

        specs.options = {
          before = [ "INIT_MAIN" ];
          data = null;
          config = ''
            vim.g.mapleader = " "
            vim.opt.number = true
            vim.opt.relativenumber = true
            vim.opt.signcolumn = "yes"
            vim.opt.updatetime = 250
            vim.opt.termguicolors = true
            vim.opt.scrolloff = 5
            vim.opt.splitright = true
            vim.opt.splitbelow = true
          '';
        };

        specs.treesitter = {
          data = pkgs.vimPlugins.nvim-treesitter.withPlugins (
            p: with p; [
              tree-sitter-rust
              tree-sitter-c
              tree-sitter-cpp
              tree-sitter-nix
              tree-sitter-go
              tree-sitter-zig
              tree-sitter-java
              tree-sitter-lua
              tree-sitter-asm
            ]
          );
          after = [ "options" ];
          config = ''
            vim.api.nvim_create_autocmd("FileType", {
              callback = function(ev)
                pcall(vim.treesitter.start, ev.buf)
              end,
            })
          '';
        };

        specs.lspconfig = {
          data = pkgs.vimPlugins.nvim-lspconfig;
          after = [ "cmp" ];
          config = ''
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("*", { capabilities = capabilities })
            vim.lsp.enable({ "rust_analyzer", "clangd", "nixd", "gopls", "zls", "lua_ls" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition)
            vim.keymap.set("n", "gr", vim.lsp.buf.references)
            vim.keymap.set("n", "K", vim.lsp.buf.hover)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
          '';
        };

        specs.cmp = {
          data = pkgs.vimPlugins.nvim-cmp;
          config = ''
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
              snippet = {
                expand = function(args) luasnip.lsp_expand(args.body) end,
              },
              mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                  else fallback() end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                  else fallback() end
                end, { "i", "s" }),
              }),
              sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
              }),
            })
          '';
        };

        specs.cmp-deps = {
          lazy = false;
          data = with pkgs.vimPlugins; [
            cmp-nvim-lsp
            cmp-buffer
            cmp-path
            cmp_luasnip
            luasnip
          ];
        };

        specs.telescope = {
          data = pkgs.vimPlugins.telescope-nvim;
          config = ''
            local telescope = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", telescope.find_files)
            vim.keymap.set("n", "<leader>fg", telescope.live_grep)
            vim.keymap.set("n", "<leader>fb", telescope.buffers)
            vim.keymap.set("n", "<leader>fd", telescope.diagnostics)
          '';
        };

        specs.plenary = pkgs.vimPlugins.plenary-nvim;

        specs.nvim-tree = {
          data = pkgs.vimPlugins.nvim-tree-lua;
          config = ''
            require("nvim-tree").setup({
              view = { width = 30 },
              renderer = { group_empty = true },
              filters = { dotfiles = false },
            })
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
          '';
        };

        specs.devicons = pkgs.vimPlugins.nvim-web-devicons;

        specs.lualine = {
          data = pkgs.vimPlugins.lualine-nvim;
          config = ''
            require("lualine").setup({
              options = { theme = "auto", globalstatus = true },
              sections = {
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "diagnostics", "filetype" },
              },
            })
          '';
        };

        specs.gitsigns = {
          data = pkgs.vimPlugins.gitsigns-nvim;
          config = ''require("gitsigns").setup()'';
        };

        specs.autopairs = {
          data = pkgs.vimPlugins.nvim-autopairs;
          config = ''require("nvim-autopairs").setup()'';
        };

        specs.comment = {
          data = pkgs.vimPlugins.comment-nvim;
          config = ''
            require("Comment").setup()
            vim.keymap.set("n", "<leader>/", "gcc", { remap = true })
            vim.keymap.set("v", "<leader>/", "gc", { remap = true })
          '';
        };

        specs.sleuth = pkgs.vimPlugins.vim-sleuth;
      };
    };
}
