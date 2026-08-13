return {
  {
    "folke/sidekick.nvim",
    event = { "VeryLazy" },
    opts = {
      enabled = function(buf)
        if buf.path:lower():match("obsidian") then
          return false
        end
        return true
      end,
      cli = {
        mux = {
          backend = "zellij",
          enabled = false,
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
