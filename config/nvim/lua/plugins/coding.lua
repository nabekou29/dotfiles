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
        sources = {
          { name = "snippy" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "nvim_lua" },
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
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = true,
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
      { "nvimdev/lspsaga.nvim" },
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
          "eslint",
          "stylelint_lsp",
          "yamlls",
        },
      })

      local on_attach = function(client, bufnr) end
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
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

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          if server_name == "stylelint_lsp" then
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
              filetypes = {
                "css",
                "less",
                "scss",
                "sugarss",
                "vue",
                "wxss",
                --  "javascript", "javascriptreact", "typescript","typescriptreact"
              },
            })
            return
          elseif server_name == "eslint" or server_name == "eslint_d" then
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
              filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                "json",
              },
            })
          elseif server_name == "tsserver" then
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
              commands = {
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
            })
          else
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = settings,
            })
          end
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
          -- cspell.code_actions.with({
          --   env = {
          --     FORCE_COLOR = "0",
          --   },
          --   condition = function(utils)
          --     return not (utils.root_has_file({ ".disabled-cspell" }))
          --   end,
          -- }),
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
    init = function()
      local keymap = vim.keymap.set
      keymap("n", "gh", "<cmd>Lspsaga finder<CR>")

      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

      keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
      keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>")
      keymap("n", "gn", "<cmd>Lspsaga rename<CR>")
      keymap("n", "gN", "<cmd>Lspsaga rename ++project<CR>")

      keymap("n", "ga", "<cmd>Lspsaga code_action<CR>")
      keymap("v", "ga", "<cmd>Lspsaga code_action<CR>")

      keymap("n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
      keymap("n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>")
    end,
    opts = {
      symbol_in_winbar = {
        folder_level = 3,
      },
    },
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy" },
    dependencies = { {
      "windwp/nvim-ts-autotag",
      event = { "VeryLazy" },
      opts = {},
    } },
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
  -- 関数やオブジェクトのまとまりをわかりやすいように
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    opts = {
      indent = { use_treesitter = true },
      chunk = { style = { { fg = "#208aca" }, { fg = "#9f1b2e" } } },
      line_num = { enable = false, use_treesitter = true, style = "#208aca" },
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
        target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface, SymbolKind.Constant },
        wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct, SymbolKind.Module },
      }
    end,
  },
  -- TS のエラーをわかりやすく
  {
    "dmmulroy/ts-error-translator.nvim",
    event = { "VeryLazy" },
    opts = {},
  },
}
