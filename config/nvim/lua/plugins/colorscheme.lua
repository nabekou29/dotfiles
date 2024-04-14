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
    init = function()
      function StartTint()
        require("tint")
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
