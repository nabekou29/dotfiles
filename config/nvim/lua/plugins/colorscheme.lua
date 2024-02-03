-- https://github.com/EdenEast/nightfox.nvim
return {
  {
    "EdenEast/nightfox.nvim",
    -- enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('nightfox').setup({
        options = {
          transparent = true,
        }
      })
      vim.opt.pumblend = 20
      vim.cmd("colorscheme nightfox")
    end
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
    end
  }
}
