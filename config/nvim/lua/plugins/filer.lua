return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", ":Neotree position=float focus<CR>" },
      { "<leader>E", ":Neotree position=left focus<CR>" },
      { "<C-1>", ":Neotree source=filesystem reveal=true <CR>" },
      { "<C-2>", ":Neotree source=buffers focus<CR>" },
      { "<C-3>", ":Neotree source=git_status focus<CR>" },
    },
    opts = {
      source_selector = {
        winbar = true,
        statusline = true,
      },
      window = {
        position = "float",
      },
    },
  },
  {
    "stevearc/oil.nvim",
    event = { "BufReadPre" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
}
