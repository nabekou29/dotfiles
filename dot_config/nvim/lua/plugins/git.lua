return {
  -- 変更箇所の表示・blame の表示
  {
    "lewis6991/gitsigns.nvim",
    event = { "FocusLost" },
    keys = {
      {
        "<leader>gb",
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        desc = "Toggle Blame",
      },
    },
    opts = {
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 800,
        ignore_whitespace = false,
      },
    },
  },
  {
    "dlvhdr/gh-blame.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>gp", "<cmd>GhBlameCurrentLine<cr>", desc = "GitHub Blame Current Line" },
    },
  },
  -- diff の表示
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    opts = {},
  },
  -- conflict
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
