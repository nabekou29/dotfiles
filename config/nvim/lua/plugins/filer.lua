return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
      "tkmpypy/chowcho.nvim",
    },
    keys = {
      { "<leader>e", ":Neotree position=float focus<CR>", silent = true },
      { "<leader>E", ":Neotree position=left focus<CR>", silent = true },
      { "<C-1>", ":Neotree source=filesystem reveal=true <CR>", silent = true },
      { "<C-2>", ":Neotree source=buffers focus<CR>", silent = true },
      { "<C-3>", ":Neotree source=git_status focus<CR>", silent = true },
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
          ["<right>"] = "toggle_node",
          ["<space>"] = {
            "toggle_node",
            nowait = true, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
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
      nesting_rules = {
        ["package.json"] = {
          pattern = "^package%.json$", -- <-- Lua pattern
          files = { "package-lock.json", "pnpm*" }, -- <-- glob pattern
        },
        ["tsx"] = {
          "spec.tsx",
          "test.tsx",
          "stories.tsx",
          "spec.ts",
          "test.ts",
          "stories.ts",
        },
        ["ts"] = {
          "spec.tsx",
          "test.tsx",
          "stories.tsx",
          "spec.ts",
          "test.ts",
          "stories.ts",
        },
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
