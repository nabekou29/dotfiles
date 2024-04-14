-- https://github.com/akinsho/bufferline.nvim
return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "famiu/bufdelete.nvim",
    },
    event = { "BufReadPre", "BufNewFile", "VeryLazy" },
    init = function()
      vim.keymap.set("n", "<C-h>", "<Cmd>BufferLineCyclePrev<CR>", {})
      vim.keymap.set("n", "<C-l>", "<Cmd>BufferLineCycleNext<CR>", {})

      vim.keymap.set("n", "<leader>bt", function()
        require("telescope.bufferline").buffer_line_group_picker()
      end, {
        desc = "Toggle Buffer Group",
      })
      vim.keymap.set("n", "<leader>bs", "<Cmd>BufferLineSortByDirectory<CR>", {
        desc = "Sort Buffer By Directory",
      })
    end,
    config = function()
      local bufferline = require("bufferline")
      local groups = require("bufferline.groups")
      bufferline.setup({
        highlights = {
          separator = {
            fg = "#1D2A31",
          },
          separator_selected = {
            fg = "#2B383E",
          },
          separator_visible = {
            fg = "#2B383E",
          },
          tab_separator = {
            fg = "#1D2A31",
          },
          tab_separator_selected = {
            fg = "#1D2A31",
          },
        },
        options = {
          separator_style = "slant", -- "thin",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local icon = ""
            if level:match("error") then
              icon = ""
            elseif level:match("warning") then
              icon = ""
            end
            return " " .. icon .. " " .. count
          end,
          tab_size = 10,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          close_command = "Bdelete! %d",
          middle_mouse_command = "Bdelete! %d",
          groups = {
            items = {
              groups.builtin.pinned:with({ icon = "" }),
              groups.builtin.ungrouped,
              {
                name = " Test",
                highlight = { sp = "#1994E3" },
                matcher = function(buf)
                  return buf.name:match("%.test") or buf.name:match("%.spec")
                end,
              },
              {
                name = "Story",
                highlight = { sp = "#FC2A72" },
                matcher = function(buf)
                  return buf.name:match("%.stories")
                end,
              },
              {
                name = " Style",
                highlight = { sp = "#998626" },
                matcher = function(buf)
                  return buf.name:match("%.css") or buf.name:match("%.scss")
                end,
              },
              {
                name = "󰗊 Locals",
                highlight = { sp = "#2F3C5C" },
                matcher = function(buf)
                  return buf.path:match("translation.json")
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
                end,
              },
            },
          },
        },
      })
    end,
  },
  {
    -- バッファを閉じた時にウィンドウを閉じないようにしてくれる
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete" },
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.keymap.set("n", "<leader>w", function()
        require("bufdelete").bufdelete(0, true)
      end, { desc = ":Bdelete" })
    end,
  },
}
