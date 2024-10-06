local cond = function(plugin)
  local enabled_colorscheme = "kanagawa.nvim"
  return plugin.name == enabled_colorscheme
end

return {
  {
    "rebelot/kanagawa.nvim",
    cond = cond,
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    cond = cond,
    priority = 1000,
    opts = {
      options = {
        transparent = true,
      },
    },
    config = function(_, opts)
      require("nightfox").setup(opts)
      vim.opt.pumblend = 20
      vim.cmd("colorscheme nightfox")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    cond = cond,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    cond = cond,
    priority = 1000,
    opts = {
      transparent_background = true,
      term_colors = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
