-- https://github.com/EdenEast/nightfox.nvim
return {
  {
    "EdenEast/nightfox.nvim",
    -- enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
        },
      })
      vim.opt.pumblend = 20
      vim.cmd("colorscheme nightfox")
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
      })
      vim.cmd("colorscheme tokyonight")
    end,
  },
  {
    "levouh/tint.nvim",
    -- 結構後になってから読み込まないと動かない
    commands = { "TintStart" },
    -- event = { "VeryLazy" },
    init = function()
      function StartTint()
        local tint = require("tint")
        local windows = vim.api.nvim_list_wins()
        for _, win in ipairs(windows) do
          tint.tint(win)
        end
        tint.untint(vim.api.nvim_get_current_win())
      end
      vim.cmd("command! TintStart lua StartTint()")
    end,
    config = function()
      local tint = require("tint")
      tint.setup({
        tint_background_colors = true,
        highlight_ignore_patterns = {
          "SignColumn",
          "LineNr",
          "CursorLine",
          "WinSeparator",
          "VertSplit",
          "StatusLineNC",
        },
      })
    end,
  },
}
