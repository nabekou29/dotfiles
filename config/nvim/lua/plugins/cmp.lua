return {
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
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "snippy" },
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
}
