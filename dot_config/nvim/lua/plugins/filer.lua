return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "tkmpypy/chowcho.nvim",
      "adelarsq/image_preview.nvim",
    },
    keys = {
      { "<leader>e", "<Cmd>Neotree position=float focus<CR>" },
      { "<leader>E", "<Cmd>Neotree position=left focus<CR>" },
      { "<C-1>", "<Cmd>Neotree source=filesystem reveal=true <CR>" },
      { "<C-2>", "<Cmd>Neotree source=buffers focus<CR>" },
      { "<C-3>", "<Cmd>Neotree source=git_status focus<CR>" },
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
      { "<leader>ll", "<Cmd>Other<CR>" },
      { "<leader>lL", "<Cmd>OtherClear<CR><Cmd>Other<CR>" },
      { "<leader>li", "<Cmd>Other impl<CR>" },
      { "<leader>lt", "<Cmd>Other test<CR>" },
      { "<leader>ls", "<Cmd>Other stories<CR>" },
      { "<leader>lc", "<Cmd>Other css<CR>" },
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
            { target = "/%1/%2/%3.module.scss", context = "css" },
            { target = "/%1/%2/%3.stories.tsx", context = "stories" },
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
      style = {
        border = "rounded",
      },
    },
  },
}
