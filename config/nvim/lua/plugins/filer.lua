return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim",
      "tkmpypy/chowcho.nvim",
      "adelarsq/image_preview.nvim",
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
          ["<leader>p"] = "image_wezterm",
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
        image_wezterm = function(state)
          local node = state.tree:get_node()
          if node.type == "file" then
            require("image_preview").PreviewImage(node.path)
          end
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
  {
    "rgroli/other.nvim",
    main = "other-nvim",
    cmd = { "Other", "OtherTabNew", "OtherVsplit", "OtherSplit", "OtherClear" },
    keys = {
      { "<leader>ll", ":Other<CR>", silent = true },
      { "<leader>lL", ":OtherClear<CR>:Other<CR>", silent = true },
      { "<leader>li", ":Other impl<CR>", silent = true },
      { "<leader>lt", ":Other test<CR>", silent = true },
      { "<leader>ls", ":Other stories<CR>", silent = true },
      { "<leader>lc", ":Other css<CR>", silent = true },
    },
    opts = {
      showMissingFiles = false,
      mappings = {
        -- js, ts
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).*.([jt]sx?)$",
          target = {
            { target = "/%1/%2/%3.test.%4", context = "test" },
          },
        },
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).test.([jt]sx?)$",
          target = {
            { target = "/%1/%2/%3.%4", context = "impl" },
          },
        },
        -- ts, tsx
        {
          pattern = "/(.*)/(.*)/([A-Z][a-zA-Z-_]*).*.([jt]sx)$",
          target = {
            { target = "/%1/%2/%3.stories.%4", context = "stories" },
            { target = "/%1/%2/%3.module.scss", context = "css" },
          },
        },
        {
          pattern = "/(.*)/(.*)/([A-Z][a-zA-Z-_]*).test.([jt]sx)$",
          target = {
            { target = "/%1/%2/%3.%4", context = "impl" },
          },
        },
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).stories.*$",
          target = {
            { target = "/%1/%2/%3.tsx", context = "impl" },
            { target = "/%1/%2/%3.test.tsx", context = "test" },
            { target = "/%1/%2/%3.module.scss", context = "css" },
          },
        },
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).module.scss$",
          target = {
            { target = "/%1/%2/%3.tsx", context = "impl" },
            { target = "/%1/%2/%3.test.tsx", context = "test" },
            { target = "/%1/%2/%3.stories.tsx", context = "stories" },
          },
        },
      },
    },
  },
}
