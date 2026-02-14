return {
  {
    "A7Lavinraj/fyler.nvim",
    enabled = true,
    event = { "VeryLazy" },
    keys = {
      { "<leader>e", "<Cmd>Fyler<CR>", desc = "Open file explorer" },
    },
    dependencies = { "nvim-mini/mini.icons" },
    opts = {
      integrations = {
        icon = "mini_icons",
        winpick = function(_win_filter, onsubmit, _opts)
          require("chowcho").run(function(window)
            onsubmit(window)
          end)
        end,
      },
      views = {
        finder = {
          close_on_select = true,
          confirm_simple = false,
          default_explorer = false,
          delete_to_trash = false,
          git_status = {
            enabled = true,
            symbols = {
              Untracked = "?",
              Added = "+",
              Modified = "*",
              Deleted = "x",
              Renamed = ">",
              Copied = "~",
              Conflict = "!",
              Ignored = "#",
            },
          },
          mappings_opts = {
            nowait = false,
            noremap = true,
            silent = true,
          },
          follow_current_file = true,
          watcher = {
            enabled = false,
          },
          win = {
            kind = "float",
          },
        },
      },
    },
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-mini/mini.icons" },
    opts = {},
  },

  {
    "rgroli/other.nvim",
    main = "other-nvim",
    cmd = { "Other", "OtherTabNew", "OtherVsplit", "OtherSplit", "OtherClear" },
    keys = {
      { "<leader>ll", "<Cmd>Other<CR>", desc = "Open other file" },
      { "<leader>lL", "<Cmd>OtherClear<CR><Cmd>Other<CR>", desc = "Open other file (clear cache)" },
      { "<leader>li", "<Cmd>Other impl<CR>", desc = "Open implementation file" },
      { "<leader>lt", "<Cmd>Other test<CR>", desc = "Open test file" },
      { "<leader>ls", "<Cmd>Other stories<CR>", desc = "Open stories file" },
      { "<leader>lc", "<Cmd>Other css<CR>", desc = "Open CSS file" },
    },
    opts = {
      showMissingFiles = false,
      mappings = {
        -- go
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).go$",
          target = {
            { target = "/%1/%2/%3_test.go", context = "test" },
          },
        },
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*)._test.go$",
          target = {
            { target = "/%1/%2/%3.go", context = "impl" },
          },
        },
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
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).*.([jt]sx)$",
          target = {
            { target = "/%1/%2/%3.stories.%4", context = "stories" },
            { target = "/%1/%2/%3.module.scss", context = "css" },
          },
        },
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).test.([jt]sx)$",
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
