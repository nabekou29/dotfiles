local lc = require("local_config")

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
          markdown = {
            name = "RenderMarkdown",
            module = "render-markdown.integ.blink",
            fallbacks = { "lsp" },
          },
          obsidian = {
            name = "obsidian",
            module = "blink.compat.source",
          },
          obsidian_new = {
            name = "obsidian_new",
            module = "blink.compat.source",
          },
          obsidian_tags = {
            name = "obsidian_tags",
            module = "blink.compat.source",
          },
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
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    tag = "v1.32.0",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "neovim/nvim-lspconfig" },
      { "marilari88/twoslash-queries.nvim" },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local on_attach = {
        ts_ls = function(client, bufnr)
          require("twoslash-queries").attach(client, bufnr)
        end,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client == nil then
            return
          end

          if client.name == "ts_ls" then
            vim.api.nvim_create_user_command("OrganizeImports", function()
              local params = {
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
                title = "",
              }
              vim.lsp.buf.execute_command(params)
            end, { desc = "Organize Imports" })
          elseif client.name == "stylelint_lsp" then
            vim.api.nvim_create_user_command("StylelintFixAll", function()
              vim.fn.system({ "npx", "stylelint", "--fix", vim.api.nvim_buf_get_name(0) })
            end, { desc = "Stylelint Fix All" })
          end
        end,
      })

      local settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        eslint = {
          experimental = {
            useFlatConfig = true,
          },
        },
        tailwindCSS = {
          experimental = {
            classRegex = {
              { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
              { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
            },
          },
        },
      }
      local init_options = {
        cssmodules_ls = {
          camelCase = false,
        },
      }
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          if lc.get("lsp", server_name, "enabled") == false then
            return
          end

          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            settings = vim.tbl_deep_extend("force", settings, lc.get("lsp", server_name, "settings") or {}),
            on_attach = function(client, bufnr)
              -- フォーマットを無効化
              if client.server_capabilities.documentFormattingProvider then
                client.server_capabilities.documentFormattingProvider = false
              end
              if client.server_capabilities.documentRangeFormattingProvider then
                client.server_capabilities.documentRangeFormattingProvider = false
              end
              if on_attach[server_name] then
                on_attach[server_name](client, bufnr)
              end
            end,
            filetypes = lc.get("lsp", server_name, "filetypes"),
            init_options = init_options[server_name],
          })
        end,
      })

      require("mason-lspconfig").setup({
        automatic_enable = {
          exclude = {
            "denols",
            -- "biome"
          },
        },
        automatic_installation = true,
        ensure_installed = {
          "elmls",
          "biome",
          "html",
          "jsonls",
          "rust_analyzer",
          "ts_ls",
          "denols",
          "tailwindcss",
          "svelte",
          "lua_ls",
          "cssls",
          "cssmodules_ls",
          "eslint",
          "stylelint_lsp",
          "yamlls",
          "gopls",
        },
      })

      local lspconfig = require("lspconfig")
      local lsp_configs = require("lspconfig.configs")
      if not lsp_configs.js_in_ls then
        lsp_configs.js_in_ls = {
          default_config = {
            name = "js-i18n-ls",
            cmd = {
              "/Users/kohei_watanabe/ghq/github.com/nabekou29/js-i18n-language-server/dist/main.js",
              "--stdio",
            },
            filetypes = {
              "javascript",
              "typescript",
              "javascriptreact",
              "typescriptreact",
              "json",
            },
            root_dir = function(fname)
              return lspconfig.util.find_git_ancestor(fname) or vim.loop.cwd()
            end,
          },
        }
      end
      -- for _, server in pairs(require("mason-lspconfig").get_installed_servers()) do
      --   if lc.get("lsp", server, "enabled") == false then
      --     return
      --   end
      --   -- vim.lsp.enable(server)
      --   vim.lsp.config(server, {
      --     capabilities = capabilities,
      --     settings = vim.tbl_deep_extend("force", settings, lc.get("lsp", server, "settings") or {}),
      --     on_attach = function(client, bufnr)
      --       -- フォーマットを無効化
      --       if client.server_capabilities.documentFormattingProvider then
      --         client.server_capabilities.documentFormattingProvider = false
      --       end
      --       if client.server_capabilities.documentRangeFormattingProvider then
      --         client.server_capabilities.documentRangeFormattingProvider = false
      --       end
      --       if on_attach[server] then
      --         on_attach[server](client, bufnr)
      --       end
      --     end,
      --     filetypes = lc.get("lsp", server, "filetypes"),
      --     init_options = init_options[server],
      --   })
      -- end

      vim.lsp.set_log_level("info")
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "nvimtools/none-ls.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "davidmh/cspell.nvim" },
    },
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local cspell = require("cspell")

      local cspell_config = {
        cspell_config_dirs = { "~/.config/" },
      }

      local root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git", "package.json")

      null_ls.setup({
        root_dir = root_dir,
        sources = {
          cspell.diagnostics.with({
            env = {
              FORCE_COLOR = "0",
            },
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity["INFO"]
            end,
            condition = function(utils)
              if lc.get("lsp", "cspell", "enabled") ~= nil then
                return lc.get("lsp", "cspell", "enabled")
              end
              return true
            end,
            config = cspell_config,
          }),
          cspell.code_actions.with({
            env = {
              FORCE_COLOR = "0",
            },
            condition = function(utils)
              if lc.get("lsp", "cspell", "enabled") ~= nil then
                return lc.get("lsp", "cspell", "enabled")
              end
              return true
            end,
            config = cspell_config,
          }),
          null_ls.builtins.diagnostics.actionlint,
          null_ls.builtins.diagnostics.markdownlint.with({
            root_dir = require("null-ls.utils").root_pattern(".markdownlint.json"),
            runtime_condition = function(params)
              local cwd = vim.fn.getcwd()
              local bufname = params.bufname
              return bufname:find(cwd, 1, true) == 1
            end,
          }),
          null_ls.builtins.diagnostics.textlint.with({
            filetypes = { "markdown" },
            condition = function(utils)
              return utils.root_has_file({
                ".textlintrc",
                ".textlintrc.js",
                ".textlintrc.json",
                ".textlintrc.yaml",
                ".textlintrc.yml",
              })
            end,
            runtime_condition = function(params)
              local cwd = vim.fn.getcwd()
              local bufname = params.bufname
              return bufname:find(cwd, 1, true) == 1
            end,
          }),
          -- format
          null_ls.builtins.formatting.prettier.with({
            prefer_local = "node_modules/.bin",
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "json",
              "jsonc",
              "json5",
              "css",
              "scss",
              "less",
              "html",
              "vue",
              "svelte",
              "yaml",
              "markdown",
            },
            condition = function(utils)
              if lc.get("formatter", "prettier", "enabled") ~= nil then
                return lc.get("formatter", "prettier", "enabled")
              end
              return utils.root_has_file({ ".prettierrc", ".prettierrc.js", ".prettierrc.json" })
            end,
          }),
          null_ls.builtins.formatting.biome.with({
            command = "biome",
            args = {
              "check",
              "--fix",
              "--stdin-file-path",
              "$FILENAME",
            },
            condition = function(utils)
              if lc.get("formatter", "biome", "enabled") ~= nil then
                return lc.get("formatter", "biome", "enabled")
              end
              return utils.root_has_file({ "biome.json", "biome.jsonc" })
            end,
          }),
          -- null_ls.builtins.formatting.stylelint.with({
          --   timeout = 10000,
          -- }),
          null_ls.builtins.formatting.stylua.with({}),
          null_ls.builtins.formatting.gofumpt.with({}),
          -- null_ls.builtins.formatting.markdownlint.with({
          --   root_dir = require("null-ls.utils").root_pattern(".markdownlint.json"),
          --   runtime_condition = function(params)
          --     local cwd = vim.fn.getcwd()
          --     local bufname = params.bufname
          --     return bufname:find(cwd, 1, true) == 1
          --   end,
          -- }),
          null_ls.builtins.formatting.terraform_fmt.with({}),
          null_ls.builtins.formatting.shfmt.with({
            filetypes = { "sh", "zsh" },
          }),
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
              group = augroup,
              buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                -- EslintFixAll が存在する場合は実行
                if vim.fn.exists(":EslintFixAll") > 0 then
                  vim.cmd([[EslintFixAll]])
                end
                vim.lsp.buf.format({
                  async = false,
                  bufnr = bufnr,
                  filter = function(cl)
                    return cl.name == "null-ls"
                  end,
                })
              end,
            })
          end
        end,
      })
      require("mason-null-ls").setup({
        automatic_installation = true,
        ensure_installed = {
          "prettier",
          "stylua",
          "cspell",
          "actionlint",
          "textlint",
          "stylelint",
          "gofumpt",
        },
      })
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
  {
    "andymass/vim-matchup",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    -- init = function()
    --   vim.g.matchup_matchparen_offscreen = { method = "popup" }
    -- end,
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
    -- enabled = false,
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
