return {
  {
    "nabekou29/trev.nvim",
    keys = {
      { "<leader>e", "<cmd>Trev float reveal<cr>", desc = "Toggle trev float" },
      { "<leader>E", "<cmd>Trev reveal<cr>", desc = "Toggle trev panel" },
    },
    cmd = { "Trev" },
    opts = function()
      local trev = require("trev")

      return {
        adapter = "auto",
        width = 60,
        auto_reveal = true,
        neovim_preview = {
          enabled = true,
        },
        keybindings = {
          ["e"] = trev.actions.open(),
          ["<S-CR>"] = {
            action = function(e)
              trev.close()
              require("chowcho").run(function(window)
                vim.api.nvim_set_current_win(window)
                if e.current_file then
                  vim.cmd("edit " .. vim.fn.fnameescape(e.current_file))
                end
              end)
            end,
          },
        },
      }
    end,
  },

  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
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
