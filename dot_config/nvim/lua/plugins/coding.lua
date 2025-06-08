return {
  -- CMP
  {
    "saghen/blink.cmp",
    event = { "InsertEnter" },
    version = "*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "mikavilpas/blink-ripgrep.nvim",
      "saghen/blink.compat",
    },
    opts = {
      keymap = {
        preset = "enter",
        ["<Esc>"] = { "cancel", "fallback" },
      },
      cmdline = {
        keymap = {
          preset = "enter",
          ["<Tab>"] = { "show", "select_next", "fallback" },
          ["<S-Tab>"] = { "show", "select_prev", "fallback" },
        },
      },
      completion = {
        menu = {
          border = "rounded",
          winblend = 10,
          auto_show = false,
        },
        documentation = {
          auto_show = true,
          window = {
            border = "rounded",
          },
        },
        ghost_text = {
          enabled = false,
        },
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= "cmdline"
            end,
          },
        },
      },
      signature = { enabled = false },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "obsidian_tags", "obsidian", "obsidian_new", "lsp", "path", "snippets", "markdown", "ripgrep" },
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
        providers = {
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            score_offset = -10,
            opts = {
              prefix_min_len = 5,
            },
          },
          markdown = { name = "RenderMarkdown", module = "render-markdown.integ.blink", fallbacks = { "lsp" } },
          obsidian = { name = "obsidian", module = "blink.compat.source" },
          obsidian_new = { name = "obsidian_new", module = "blink.compat.source" },
          obsidian_tags = { name = "obsidian_tags", module = "blink.compat.source" },
        },
      },
    },
    opts_extend = { "sources.default" },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      -- Highlight groups
      vim.cmd([[
        highlight BlinkCmpMenu guibg=#03142f
        highlight BlinkCmpMenuBorder guifg=#1c2e5f guibg=#03142f
      ]])
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    init = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.general = {
        positionEncodings = { "utf-16" },
      }

      vim.lsp.config("*", {
        offset_encoding = "utf-16",
        capabilities = capabilities,
      })

      vim.lsp.enable({
        "biome",
        "cssls",
        "css_variables",
        -- "cssmodules_ls",
        "cspell_lsp",
        "denols",
        -- "elmls",
        "eslint",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "rust_analyzer",
        "stylelint_lsp",
        -- "svelte",
        "tailwindcss",
        "ts_ls",
        -- "yamlls",
      })
    end,

    vim.api.nvim_create_user_command("LspRestartAll", function()
      for _, client in pairs(vim.lsp.get_clients()) do
        if client.stop then
          client:stop()
        end
      end
      vim.cmd("edit")
    end, {
      desc = "Restart all LSP clients",
    }),
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = function()
      local util = require("conform.util")
      --- 1度目の保存は import の削除などをしない弱い?フォーマットのみを実行し、2度目の保存でより強力なフォーマットを実行する
      --- @param weak conform.FormatterConfigOverride
      --- @param strong conform.FormatterConfigOverride
      --- @param common conform.FormatterConfigOverride
      local smart_formatter = function(weak, strong, common)
        return function(bufnr)
          local ok, modified = pcall(vim.api.nvim_get_option_value, "modified", { buf = bufnr })
          if ok and not modified then
            return vim.tbl_extend("force", common or {}, strong)
          else
            return vim.tbl_extend("force", common or {}, weak)
          end
        end
      end

      --- @type conform.setupOpts
      return {
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "biome", "prettierd", "eslint_d" },
          javascriptreact = { "biome", "prettierd", "eslint_d" },
          typescript = { "biome", "prettierd", "eslint_d" },
          typescriptreact = { "biome", "prettierd", "eslint_d" },
          rust = { "rustfmt" },
          markdown = { "prettierd" },
          toml = { "taplo" },
        },
        default_format_opts = {
          lsp_format = "fallback",
          timeout_ms = 500,
        },
        format_on_save = function()
          -- :w! で保存したときはフォーマットしない
          if vim.v.cmdbang == 1 then
            return nil
          end
          return {}
        end,
        formatters = {
          biome = smart_formatter({
            args = { "format", "--stdin-file-path", "$FILENAME" },
          }, {
            args = { "check", "--write", "--stdin-file-path", "$FILENAME" },
          }, {
            require_cwd = true,
          }),
          prettierd = {
            -- biome が有効な場合は prettierd を無効化する
            condition = function(_, ctx)
              local biome_available = require("conform").get_formatter_info("biome").available
              local formatters = require("conform").list_formatters_for_buffer(ctx.buf)
              return not (biome_available and vim.tbl_contains(formatters, "biome"))
            end,
          },
          eslint_d = smart_formatter({
            condition = function()
              return false
            end,
          }, {}, {
            require_cwd = true,
          }),
          rustfmt = {
            prepend_args = { "+nightly" },
          },
        },
      }
    end,
  },
  -- 定義のプレビュー表示
  -- {
  --   "rmagatti/goto-preview",
  --   event = { "LspAttach" },
  --   keys = {
  --     { "gp", "<Cmd>lua require('goto-preview').goto_preview_definition()<CR>" },
  --     { "gP", "<Cmd>lua require('goto-preview').close_all_win()<CR>" },
  --   },
  --   opts = {
  --     height = 20,
  --   },
  -- },
  -- コードアクションのプレビューを表示
  {
    "aznhe21/actions-preview.nvim",
    keys = {
      { "ga", "<Cmd>lua require('actions-preview').code_actions()<CR>" },
      { "gA", "<Cmd>lua require('actions-preview').code_actions()<CR>" },
    },
    opts = {},
  },

  -- ホバーを綺麗に
  {
    "Fildo7525/pretty_hover",
    event = { "LspAttach" },
    opts = {},
  },
  {
    "nvimdev/lspsaga.nvim",
    cmd = { "Lspsaga" },
    event = { "LspAttach" },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    keys = {
      { "gh", "<Cmd>Lspsaga finder<CR>", silent = true },
      -- { "K", "<Cmd>Lspsaga hover_doc<CR>", silent = true },
      -- { "gr", "<Cmd>Lspsaga finder ref<CR>", silent = true },
      { "gp", "<Cmd>Lspsaga peek_definition<CR>", silent = true },
      { "gd", "<Cmd>Lspsaga goto_definition<CR>", silent = true },
      -- { "gn", "<Cmd>Lspsaga rename<CR>", silent = true },
      { "gN", "<Cmd>Lspsaga rename ++project<CR>", silent = true },
      -- { "ga", "<Cmd>Lspsaga code_action<CR>", silent = true },
      -- { "g[", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", silent = true },
      -- { "g]", "<Cmd>Lspsaga diagnostic_jump_next<CR>", silent = true },
    },
    opts = {
      symbol_in_winbar = {
        enable = false,
        folder_level = 0,
      },
    },
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        sync_install = false,
        auto_install = true,
        ensure_installed = "all",
        ignore_install = {},
        modules = {},
        highlight = {
          enable = true,
          disable = {},
          additional_vim_regex_highlighting = false,
        },
        matchup = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "VeryLazy" },
    enabled = false,
    config = function()
      require("treesitter-context").setup({
        max_lines = 12,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "InsertEnter" },
    opts = {
      opts = {
        enable_rename = false,
        enable_close = true,
        enable_close_on_slash = true,
        filetypes = { "html", "xml", "javascriptreact", "typescriptreact", "svelte", "vue" },
      },
    },
  },

  -- `%` の拡張
  {
    "andymass/vim-matchup",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- TODO など
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { "<leader>ft" },
    opts = {},
  },
  -- エラー
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleClose" },
    keys = function()
      local prefix = "<leader>x"

      return {
        { prefix .. "x", "<Cmd>Trouble diagnostics toggle filetype.buf=0<CR>" },
        { prefix .. "X", "<Cmd>Trouble diagnostics toggle<CR>" },
        { prefix .. "l", "<Cmd>Trouble loclist toggle<CR>" },
        { prefix .. "q", "<Cmd>Trouble quickfix toggle<CR>" },
      }
    end,
    opts = {
      use_diagnostic_signs = true,
    },
  },
  -- 参照の数などを表示
  {
    "VidocqH/lsp-lens.nvim",
    event = { "VeryLazy" },
    opts = function()
      local SymbolKind = vim.lsp.protocol.SymbolKind
      return {
        enable = false,
        sections = {
          definition = false,
          references = true,
          implements = false,
          git_authors = true,
        },
        target_symbol_kinds = {
          SymbolKind.Function,
          SymbolKind.Method,
          SymbolKind.Interface,
          SymbolKind.Constant,
        },
        wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct, SymbolKind.Module },
      }
    end,
  },
  -- i18n
  {
    "nabekou29/js-i18n.nvim",
    enabled = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
    keys = {
      { "<leader>il", "<Cmd>I18nSetLang<CR>", desc = "Set language" },
      { "<leader>ie", "<Cmd>I18nEditTranslation<CR>", desc = "Edit translation" },
    },
    opts = {
      primary_language = { "ja" },
      respect_gitignore = false,
      virt_text = {
        max_width = 48,
      },
      -- namespace_separator = ":",
    },
  },
  -- Typescript
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact" },
    opts = {},
  },
  {
    "marilari88/twoslash-queries.nvim",
    opts = {},
  },
  -- コメントアウト
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    event = { "VeryLazy" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
}
