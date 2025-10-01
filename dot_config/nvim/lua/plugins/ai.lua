return {
  -- Copilot
  -- {
  --   "zbirenbaum/copilot.lua",
  --   enabled = false,
  --   cmd = { "Copilot" },
  --   event = { "InsertEnter" },
  --   opts = {
  --     filetypes = {
  --       markdown = true,
  --       yaml = true,
  --       json = true,
  --       jsonc = true,
  --       gitcommit = true,
  --     },
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = true, -- false,
  --       debounce = 75,
  --       keymap = {
  --         accept = "<M-CR>",
  --         accept_word = "<C-l>",
  --         accept_line = "<C-;>",
  --         next = "<M-]>",
  --         prev = "<M-[>",
  --         dismiss = "<C-]>",
  --       },
  --     },
  --     copilot_model = "gpt-4o-copilot",
  --   },
  -- },
  --
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "zellij",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<c-l>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<c-l>"
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
        mode = { "n", "v" },
      },
    },
  },

  {
    "coder/claudecode.nvim",
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
        provider = "external",
        provider_opts = {
          external_terminal_cmd = function(_cmd)
            return false
          end,
        },
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)
      vim.keymap.set({ "n", "t" }, "<M-,>", function()
        vim.cmd("ClaudeCode")
      end, { desc = "Toggle Claude Code" })
    end,
  },
}
