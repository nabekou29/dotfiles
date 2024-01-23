return { {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter" },
  dependencies = { { "hrsh7th/cmp-buffer" }, { "hrsh7th/cmp-path" }, { "hrsh7th/cmp-nvim-lua" }, { "hrsh7th/cmp-nvim-lsp" },
    { 'saadparwaiz1/cmp_luasnip' }, { 'L3MON4D3/LuaSnip' }, { 'onsails/lspkind.nvim' } },
  config = function()
    local cmp = require("cmp")
    local lspkind = require('lspkind')

    cmp.setup {
      sources = {
        {
          name = "nvim_lsp"
        },
        {
          name = "buffer"
        },
        {
          name = 'luasnip'
        }
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm {
          select = true
        }
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol',       -- show only symbol annotations
          maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          before = function(entry, vim_item)
            return vim_item
          end
        })
      },
      experimental = {
        ghost_text = true
      }
    }
  end

} }
