return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    opts = {
      filetypes = {
        markdown = true,
        yaml = true,
        json = true,
        jsonc = true,
        gitcommit = true,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true, -- false,
        debounce = 75,
        keymap = {
          accept = "<M-CR>",
          accept_word = "<C-l>",
          accept_line = "<C-;>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      copilot_model = "gpt-4o-copilot",
    },
  },
  {
    "Xuyuanp/nes.nvim",
    event = { "InsertEnter" },
    keys = {
      {
        "<A-i>",
        function()
          require("nes").get_suggestion()
        end,
        mode = "i",
        desc = "[Nes] get suggestion",
      },
      {
        "<A-n>",
        function()
          require("nes").apply_suggestion(0, { jump = true, trigger = true })
        end,
        mode = "i",
        desc = "[Nes] apply suggestion",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  {
    -- "coder/claudecode.nvim",
    "nabekou29/claudecode.nvim",
    event = { "FocusLost" },
    keys = {
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "snacks_picker_list" },
      },
    },
    opts = {
      terminal = {
        enabled = false,
        split_side = "right",
        split_width_percentage = 0.3,
        provider = "auto", -- "auto" (default), "snacks", or "native"
        auto_close = true, -- Auto-close terminal after command completion
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)
      vim.keymap.set({ "n", "t" }, "<M-,>", function()
        vim.cmd("ClaudeCode")
      end, { desc = "Toggle Claude Code" })
    end,
  },

  {
    "ravitemer/mcphub.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "MCPHub",
    build = "bundled_build.lua",
    opts = {
      port = 3888,
      config = vim.fn.expand("~/.config/nvim/data/mcpServers.json"),
      use_bundled_binary = true,
    },
    -- config = function(_, opts)
    --   require("mcphub").setup(opts)
    -- end,
  },
}
