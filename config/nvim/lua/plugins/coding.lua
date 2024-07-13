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
        sources = {
          { name = "snippy" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "path" },
          { name = "buffer" },
          { name = "rg" },
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
    event = { "VeryLazy" },
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
      local on_attach = {
        tsserver = function(client, bufnr)
          require("twoslash-queries").attach(client, bufnr)
        end,
      }
      local filetypes = {
        stylelint_lsp = {
          "css",
          "less",
          "scss",
          "sugarss",
          "vue",
          "wxss",
        },
        eslint = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "json",
        },
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
            filetypes = filetypes[server_name],
            commands = commands[server_name],
            init_options = init_options[server_name],
          })
        end,
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
              "css",
              "scss",
              "less",
              "html",
              "vue",
              "svelte",
              "yaml",
              "markdown",
            },
          }),
          null_ls.builtins.formatting.stylelint.with({
            timeout = 10000,
          }),
          null_ls.builtins.formatting.stylua.with({}),
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
        ensure_installed = {
          "prettierd",
          "stylua",
          "cspell",
          "actionlint",
          "textlint",
          "stylelint",
        },
      })
    end,
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
        folder_level = 6,
      },
    },
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy" },
    dependencies = {
      {
        "windwp/nvim-ts-autotag",
        event = { "VeryLazy" },
        opts = {},
      },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_install = "all",
        auto_install = true,
        highlight = {
          enable = true,
          disable = {},
          additional_vim_regex_highlighting = false,
        },
        autotag = {
          enable = true,
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = true,
          filetypes = { "html", "xml", "javascriptreact", "typescriptreact", "svelte", "vue" },
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
    event = { "VeryLazy" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.keymap.set("n", "<leader>xx", function()
        require("trouble").toggle()
      end, {
        desc = ":TroubleToggle",
      })
      vim.keymap.set("n", "<leader>xX", function()
        require("trouble").toggle("workspace_diagnostics")
      end, {
        desc = ":TroubleToggle workspace_diagnostics",
      })
      vim.keymap.set("n", "<leader>xd", function()
        require("trouble").toggle("document_diagnostics")
      end, {
        desc = ":TroubleToggle document_diagnostics",
      })
      vim.keymap.set("n", "<leader>xl", function()
        require("trouble").toggle("loclist")
      end, {
        desc = ":TroubleToggle loclist",
      })
      vim.keymap.set("n", "<leader>xq", function()
        require("trouble").toggle("quickfix")
      end, {
        desc = ":TroubleToggle quickfix",
      })
      vim.keymap.set("n", "gR", function()
        require("trouble").toggle("lsp_references")
      end, {
        desc = ":TroubleToggle lsp_references",
      })
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
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      primary_language = { "ja" },
      virt_text = {
        max_length = 32,
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
}
