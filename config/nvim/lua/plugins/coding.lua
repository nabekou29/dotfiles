local lc = require("local_config")

return {
  -- CMP
  {
    "hrsh7th/nvim-cmp",
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
        completion = {
          autocomplete = false,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = {
          { name = "snippy", priority = 50 },
          { name = "nvim_lua", priority = 50 },
          { name = "path", priority = 50 },
          { name = "buffer", priority = 10 },
          { name = "rg", priority = 0 },
          { name = "nvim_lsp", priority = 100 },
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
    cmd = {
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
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatFixDiagnostic",
      "CopilotChatCommit",
      "CopilotChatCommitStaged",
    },
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {},
  },
  -- LSP
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason").setup({})
    end,
  }, --
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "neovim/nvim-lspconfig" },
      { "marilari88/twoslash-queries.nvim" },
      { "sontungexpt/better-diagnostic-virtual-text" },
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "elmls",
          "html",
          "jsonls",
          "rust_analyzer",
          "tsserver",
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

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local on_attach = {
        tsserver = function(client, bufnr)
          require("twoslash-queries").attach(client, bufnr)
        end,
      }

      local commands = {
        tsserver = {
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
      }
      local settings = {
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
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            settings = settings,
            on_attach = on_attach[server_name],
            filetypes = lc.get("lsp", server_name, "filetypes"),
            commands = commands[server_name],
            init_options = init_options[server_name],
          })
        end,
      })

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
        virtual_text = {
          prefix = "", -- ドキュメント上は関数も可能となっていたがエラーになってしまったので format で対応
          suffix = "",
          format = function(diagnostic)
            local prefix = "?"
            if diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
              prefix = ""
            elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Warning then
              prefix = ""
            elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Information then
              prefix = ""
            elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Hint then
              prefix = "🔧"
            end
            return string.format("%s %s [%s: %s]", prefix, diagnostic.message, diagnostic.source, diagnostic.code)
          end,
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

      null_ls.setup({
        sources = {
          cspell.diagnostics.with({
            env = {
              FORCE_COLOR = "0",
            },
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity["INFO"]
            end,
            condition = function(utils)
              return not (utils.root_has_file({ ".disabled-cspell" }))
            end,
          }),
          cspell.code_actions.with({
            env = {
              FORCE_COLOR = "0",
            },
            condition = function(utils)
              return not (utils.root_has_file({ ".disabled-cspell" }))
            end,
          }),
          null_ls.builtins.diagnostics.actionlint,
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
          }),
          -- format
          null_ls.builtins.formatting.prettierd.with({
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
              return not utils.root_has_file({ "biome.json" })
            end,
          }),
          null_ls.builtins.formatting.biome.with({
            condition = function(utils)
              return utils.root_has_file({ "biome.json" })
            end,
          }),
          null_ls.builtins.formatting.stylelint.with({
            timeout = 10000,
          }),
          null_ls.builtins.formatting.stylua.with({}),
          null_ls.builtins.formatting.gofumpt.with({}),
          null_ls.builtins.formatting.terraform_fmt.with({}),
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
          "prettierd",
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
  {
    "ray-x/lsp_signature.nvim",
    event = { "InsertEnter" },
    opts = {
      max_width = 100,
      hint_enable = false,
    },
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
      { "gh", ":Lspsaga finder<CR>", silent = true },
      { "K", ":Lspsaga hover_doc<CR>", silent = true },
      { "gr", ":Lspsaga finder ref<CR>", silent = true },
      { "gd", ":Lspsaga peek_definition<CR>", silent = true },
      { "gD", ":Lspsaga goto_definition<CR>", silent = true },
      { "gn", ":Lspsaga rename<CR>", silent = true },
      { "gN", ":Lspsaga rename ++project<CR>", silent = true },
      { "ga", ":Lspsaga code_action<CR>", silent = true },
      { "g[", ":Lspsaga diagnostic_jump_prev<CR>", silent = true },
      { "g]", ":Lspsaga diagnostic_jump_next<CR>", silent = true },
    },
    opts = {
      symbol_in_winbar = {
        folder_level = 0,
      },
    },
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy" },
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
    keys = { "<leader>ft", ":TodoTelescope<CR>" },
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
        { prefix .. "x", ":Trouble diagnostics toggle filetype.buf=0<CR>" },
        { prefix .. "X", ":Trouble diagnostics toggle<CR>" },
        { prefix .. "l", ":Trouble loclist toggle<CR>" },
        { prefix .. "q", ":Trouble quickfix toggle<CR>" },
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
        max_width = 64,
      },
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
      { "<leader>rS", ":IronRepl<CR>" },
      { "<leader>rR", ":IronRestart<CR>" },
      { "<leader>rF", ":IronFocus<CR>" },
      { "<leader>rH", ":IronHide<CR>" },
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
