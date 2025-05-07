local enabled = function(name)
  local enabled_colorscheme = "kanagawa.nvim"
  return name == enabled_colorscheme
end

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    enabled = enabled("kanagawa.nvim"),
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
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    enabled = enabled("kanagawa-paper.nvim"),
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        comment = { italic = true },
        functions = { italic = true },
        keyword = { italic = true, bold = true },
        statement = { italic = false, bold = false },
        type = { italic = true },
      },
      color_balance = {
        ink = { brightness = 0.2, saturation = 0.6 },
        canvas = { brightness = 0, saturation = 0 },
      },
    },
    config = function(_, opts)
      require("kanagawa-paper").setup(opts)
      vim.cmd("colorscheme kanagawa-paper")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    enabled = enabled("nightfox.nvim"),
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
    enabled = enabled("tokyonight.nvim"),
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
    "neanias/everforest-nvim",
    name = "everforest",
    lazy = false,
    enabled = enabled("everforest"),
    priority = 1000,
    opts = {
      background = "hard",
      transparent_background_level = 2,
      italics = true,
    },
    config = function(_, opts)
      require("everforest").setup(opts)
      vim.cmd("colorscheme everforest")
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    enabled = enabled("catppuccin"),
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
