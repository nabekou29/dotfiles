-- https://github.com/akinsho/bufferline.nvim
return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    -- スコープ付きバッファ
    -- {
    --   "tiagovla/scope.nvim",
    --   config = function()
    --     require("scope").setup {
    --     }
    --   end
    -- }
  },
  event = { "BufReadPre", "BufNewFile", "VeryLazy" },
  init = function()
    vim.keymap.set('n', '<C-h>', '<Cmd>BufferLineCyclePrev<CR>', {})
    vim.keymap.set('n', '<C-l>', '<Cmd>BufferLineCycleNext<CR>', {})
  end,
  config = function()
    local bufferline = require('bufferline')
    local groups = require('bufferline.groups')
    bufferline.setup {
      options = {
        groups = {
          items = {
            groups.builtin.pinned:with({ icon = "" }),
            groups.builtin.ungrouped,
            {
              name = " Test",
              highlight = { sp = "#1994E3" },
              matcher = function(buf)
                return buf.name:match("%.test") or buf.name:match("%.spec")
              end
            },
            {
              name = " Style",
              highlight = { sp = "#998626" },
              matcher = function(buf)
                return buf.name:match("%.css") or buf.name:match("%.scss")
              end,
            },
            {
              name = "󰈙 Docs",
              highlight = { sp = "#2C682A" },
              matcher = function(buf)
                return buf.name:match("%.md")
              end,
            },
            {
              name = " Config",
              highlight = { sp = "#4c4c4c" },
              matcher = function(buf)
                return buf.name:match("%.config") or buf.name:match("^%..*rc$")
              end
            }

          }
        }
      }
    }
  end
}
