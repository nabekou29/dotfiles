return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
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
        mappings = {
          ["w"] = "custom_open_with_window_picker",
        },
      },
      commands = {
        custom_open_with_window_picker = function(state)
          local chowcho = require("chowcho")

          local tree = state.tree
          local node = tree:get_node()
          local path = node.path

          chowcho.run(function(window)
            -- ファイルを開く
            vim.api.nvim_set_current_win(window)
            vim.api.nvim_command("edit " .. path)
          end)
        end,
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
