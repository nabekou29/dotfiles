return {
  {
    "zbirenbaum/copilot.lua",
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    config = function()
      require("copilot").setup({
        filetypes = {
          markdown = true,
          yaml = true,
          json = true,
          jsonc = true,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true, -- false,
          debounce = 75,
          keymap = {
            accept = "<M-;>",
            accept_word = "<M-l>",
            accept_line = "<M-j>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = { "VeryLazy" },
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      -- debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
