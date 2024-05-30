return {
  -- ターミナルをフローティングで呼び出すやつ（lazygit のためにしか使っていない)
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec", "TermCloseAll", "TermOpenAll" },
    event = { "VeryLazy" },
    keys = {
      { "<leader>t", "<cmd>ToggleTerm direction=tab<CR>", { noremap = true, silent = true } },
    },
    config = function()
      require("toggleterm").setup({})

      local base_config_path = "$HOME/Library/Application Support/lazygit/config.yml"
      local custom_config_path = "$HOME/.config/nvim/lazygit_for_nvim.yml"
      local paths = '"' .. base_config_path .. "," .. custom_config_path .. '"'

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit --ucf " .. paths,
        hidden = true,
        direction = "float",
        float_opts = {
          border = "double",
          winblend = 20,
        },
      })

      local function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set("n", "<leader>gg", function()
        _lazygit_toggle()
      end)
    end,
  },
  -- 変更箇所の表示・blame の表示
  {
    "lewis6991/gitsigns.nvim",
    event = { "FocusLost", "CursorHold" },
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
        ignore_whitespace = false,
      },
    },
  },
  {
    "dlvhdr/gh-blame.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>gb", "<cmd>GhBlameCurrentLine<cr>", desc = "GitHub Blame Current Line" },
    },
  },
  -- diff の表示
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- conflict
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
