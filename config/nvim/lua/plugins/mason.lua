return {
  {
    "williamboman/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("mason").setup({})
    end,
  }, --
  -- https://github.com/williamboman/mason-lspconfig.nvim
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
          "eslint",
          "eslint_d",
          "stylelint_lsp",
          "yamlls",
        },
      })

      local on_attach = function(client, bufnr) end
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          -- 通知
          vim.notify("LSP setup" .. server_name)

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
          end

          if server_name == "eslint" or server_name == "eslint_d" then
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
            })
          end
        end,
      })
    end,
  }, --
  -- https://github.com/jay-babu/mason-null-ls.nvim
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "nvimtools/none-ls.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup({
        sources = {
          -- null_ls.builtins.diagnostics.cspell.with({
          --   diagnostics_postprocess = function(diagnostic)
          --     -- レベルをWARNに変更（デフォルトはERROR）
          --     diagnostic.severity = vim.diagnostic.severity["WARN"]
          --   end,
          --   condition = function()
          --     -- cspellが実行できるときのみ有効
          --     return vim.fn.executable("cspell") > 0
          --   end,
          -- }),
          -- format
          null_ls.builtins.formatting.stylelint.with({}),
          -- null_ls.builtins.formatting.eslint_d.with({}),
          null_ls.builtins.formatting.prettierd.with({ prefer_local = "node_modules/.bin" }),
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
      require("mason-null-ls").setup({ ensure_installed = { "prettierd", "stylua" } })
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Highlight を定義
      vim.cmd([[ hi FidgetNormal guifg=#ccc guibg=#1994E3 ]])

      require("fidget").setup({
        notification = {
          window = { normal_hl = "FidgetNormal", winblend = 80 },
        },
      })
    end,
  },
}
