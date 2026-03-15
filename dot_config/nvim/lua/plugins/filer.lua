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
      local actions = trev.actions

      return {
        adapter = "tmux",
        width = 60,
        float = { width = 0.9, height = 0.9 },
        auto_reveal = true,
        keybindings = {
          ["<CR>"] = { actions.open(), actions.toggle_expand() },
          ["<S-CR>"] = {
            action = function(e)
              require("trev").close()
              require("chowcho").run(function(window)
                vim.api.nvim_set_current_win(window)
                if e.current_file then
                  vim.cmd("edit " .. vim.fn.fnameescape(e.current_file))
                end
              end)
            end,
          },
          q = actions.quit(),
          s = {
            description = "Open in split",
            action = function(e)
              vim.cmd("split " .. vim.fn.fnameescape(e.current_file))
            end,
          },
          v = {
            description = "Open in vsplit",
            action = function(e)
              vim.cmd("vsplit " .. vim.fn.fnameescape(e.current_file))
            end,
          },
          Y = {
            description = "Yank path",
            context = { "universal" },
            action = function(e)
              vim.fn.setreg("+", e.current_file)
              vim.notify("Copied: " .. e.current_file)
            end,
          },
        },
      }
    end,
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
