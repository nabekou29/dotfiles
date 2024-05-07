return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim", -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    cmd = { "Neotree" },
    init = function()
      vim.keymap.set("n", "<leader>e", ":Neotree position=left focus<CR>", {
        desc = ":Neotree position=left focus",
      })
      vim.keymap.set("n", "<leader>E", ":Neotree position=float focus<CR>", {
        desc = ":Neotree position=float focus",
      })
      vim.keymap.set("n", "<C-1>", ":Neotree source=filesystem reveal=true <CR>", {
        desc = ":Neotree source=filesystem reveal=true",
      })
      vim.keymap.set("n", "<C-2>", ":Neotree source=buffers focus<CR>", {
        desc = ":Neotree source=buffers",
      })
      vim.keymap.set("n", "<C-3>", ":Neotree source=git_status focus<CR>", {
        desc = ":Neotree source=git_status",
      })
    end,
    config = function()
      require("neo-tree").setup({
        source_selector = {
          winbar = true,
          statusline = true,
        },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    event = { "BufReadPre" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
