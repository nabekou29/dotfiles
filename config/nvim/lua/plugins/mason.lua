return { {
  "williamboman/mason.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("mason").setup {}
  end
}, --
  -- https://github.com/williamboman/mason-lspconfig.nvim
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { { "williamboman/mason.nvim" }, { "neovim/nvim-lspconfig" }, { "nvimdev/lspsaga.nvim" } },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { 'elmls', 'html', 'jsonls', 'rust_analyzer', 'tsserver', 'tailwindcss', 'svelte',
          'lua_ls', 'remark_ls' }
      }

      local on_attach = function(client, bufnr)
        local keymap = vim.keymap.set

        keymap('n', 'gf', '<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR><cmd>write<CR>')
        keymap('n', 'gF', '<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR><cmd>write<CR>')
      end
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      require('mason-lspconfig').setup_handlers { function(server_name)
        if server_name == 'stylelint_lsp' then
          require('lspconfig')[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
              "css", "less", "scss", "sugarss", "vue",
              "wxss" --  "javascript", "javascriptreact", "typescript","typescriptreact"
            }
          })
          return
        end

        if server_name == 'eslint' or server_name == 'eslint_d' then
          require('lspconfig')[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
              "javascript", "javascriptreact", "typescript", "typescriptreact", "json"
            }
          })
          return
        end


        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach
        }
      end }
    end
  }, --
  -- https://github.com/jay-babu/mason-null-ls.nvim
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { { "williamboman/mason.nvim" }, { "nvimtools/none-ls.nvim" }, { "nvim-lua/plenary.nvim" } },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        diagnostics_format = "#{m} (#{s}: #{c})",
        sources = {                                       --
          -- format
          null_ls.builtins.formatting.eslint_d.with({}),  --
          null_ls.builtins.formatting.stylelint.with({}), --
          null_ls.builtins.formatting.prettierd.with({})  --
        }
      })
      require('mason-null-ls').setup {
        ensure_installed = { "eslint_d", "stylelint", "prettierd" }
      }
    end
  } }
