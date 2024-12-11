local lc = require("local_config")

return {
  -- CMP
  {
    -- "iguanacucumber/magazine.nvim",
    "hrsh7th/nvim-cmp",
    name = "nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "onsails/lspkind.nvim" },
      { "dcampos/nvim-snippy" },
      { "dcampos/cmp-snippy" },
      { "lukas-reineke/cmp-rg" },
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      require("snippy").setup({
        scopes = {
          typescript = function(scopes)
            table.insert(scopes, "javascript")
            return scopes
          end,
          javascriptreact = function(scopes)
            table.insert(scopes, "javascript")
            return scopes
          end,
          typescriptreact = function(scopes)
            table.insert(scopes, "javascript")
            table.insert(scopes, "javascriptreact")
            return scopes
          end,
        },
      })

      cmp.setup({
        performance = {
          max_view_entries = 32,
          debounce = 0,
          throttle = 0,
        },
        completion = {
          autocomplete = false,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = {
          { name = "nvim_lsp", priority = 100 },
          { name = "snippy", priority = 60 },
          { name = "nvim_lua", priority = 50 },
          { name = "path", priority = 50 },
          { name = "buffer", priority = 10, keyword_length = 4, max_item_count = 10 },
          { name = "rg", priority = 0, keyword_length = 4, max_item_count = 10 },
          { name = "nvim_lsp_signature_help", priority = 100 },
        },
        snippet = {
          expand = function(args)
            require("snippy").expand_snippet(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            preset = "codicons",
            ellipsis_char = "...",
            before = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                snippy = "[Snippy]",
                emoji = "[Emoji]",
                path = "[Path]",
                calc = "[Calc]",
                vsnip = "[Snippet]",
                buffer = "[Buffer]",
                nvim_lua = "[Lua]",
                copilot = "[Copilot]",
                treesitter = "[Treesitter]",
                rg = "[Rg]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = false,
        },
      })
    end,
  },
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    opts = {
      filetypes = {
        markdown = true,
        yaml = true,
        json = true,
        jsonc = true,
        gitcommit = true,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true, -- false,
        debounce = 75,
        keymap = {
          accept = "<M-;>",
          accept_word = "<M-l>",
          accept_line = "<M-j>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = function()
      local cmd = {
        "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatClose",
        "CopilotChatToggle",
        "CopilotChatStop",
        "CopilotChatReset",
        "CopilotChatSave",
        "CopilotChatLoad",
        "CopilotChatDebugInfo",
        "CopilotChatModels",
        "CopilotChatModel",
      }
      for k, _ in pairs(require("copilot_prompts")) do
        table.insert(cmd, "CopilotChat" .. k)
      end
      return cmd
    end,
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      show_help = "yes",
      prompts = require("copilot_prompts"),
    },
  },
  -- LSP
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "neovim/nvim-lspconfig" },
      { "marilari88/twoslash-queries.nvim" },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local on_attach = {
        ts_ls = function(client, bufnr)
          require("twoslash-queries").attach(client, bufnr)
        end,
      }

      local commands = {
        ts_ls = {
          OrganizeImports = {
            function()
              local params = {
                command = "_typescript.organizeImports",
                arguments = {
                  vim.api.nvim_buf_get_name(0),
                },
                title = "",
              }
              vim.lsp.buf.execute_command(params)
            end,
          },
        },
        stylelint_lsp = {
          StylelintFixAll = {
            function()
              vim.system({ "npx", "stylelint", "--fix", vim.api.nvim_buf_get_name(0) })
            end,
          },
        },
      }
      local settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
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
            commands = commands[server_name],
            init_options = init_options[server_name],
          })
        end,
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "elmls",
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
              return not (utils.root_has_file({ ".disabled-cspell" }))
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
              return not (utils.root_has_file({ ".disabled-cspell" }))
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
              "--apply",
              "--stdin-file-path",
              "$FILENAME",
            },
            condition = function(utils)
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
      -- { "ga", "<Cmd>lua require('actions-preview').code_actions()<CR>" },
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
    enabled = false,
    event = { "VeryLazy" },
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
  -- TODO など
  {
    "folke/todo-comments.nvim",
    event = { "VeryLazy" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { "<leader>ft", "<Cmd>TodoTelescope<CR>" },
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
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
    keys = {
      { "<leader>il", ":I18nSetLang<CR>", desc = "Set language" },
      { "<leader>ie", ":I18nEditTranslation<CR>", desc = "Edit translation" },
    },
    opts = {
      primary_language = { "ja" },
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
  -- package.json
  {
    "vuki656/package-info.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
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
  -- Docコメント生成
  {
    "danymat/neogen",
    cmd = { "Neogen" },
    keys = {
      { "<leader>gc", ":Neogen<CR>" },
    },
    opts = {},
  },
  -- repl
  {
    "Vigemus/iron.nvim",
    keys = {
      { "<leader>rS", "<Cmd>IronRepl<CR>" },
      { "<leader>rR", "<Cmd>IronRestart<CR>" },
      { "<leader>rF", "<Cmd>IronFocus<CR>" },
      { "<leader>rH", "<Cmd>IronHide<CR>" },
    },
    main = "iron.core",
    opts = function()
      return {
        config = {
          repl_definition = {
            sh = {
              command = { "zsh" },
            },
            python = {
              command = { "python3" }, -- or { "ipython", "--no-autoindent" }
              format = require("iron.fts.common").bracketed_paste_python,
            },
            javascript = {
              command = { "node" },
            },
            typescript = {
              command = { "deno" },
            },
          },
        },
        keymaps = {
          send_motion = "<leader>rs",
          visual_send = "<leader>rs",
          send_file = "<leader>rf",
          send_line = "<leader>rl",
          cr = "<leader>r<CR>",
          interrupt = "<leader>r<space>",
          exit = "<leader>rq",
          clear = "<leader>rc",
        },
        highlight = {
          italic = true,
        },
      }
    end,
  },
}
