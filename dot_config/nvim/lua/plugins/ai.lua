return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
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
          accept_word = "<M-l>",
          accept_line = "<M-;>",
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
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      -- { "<M-,>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      -- { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      -- { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
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
        split_side = "right",
        split_width_percentage = 0.3,
        -- provider = "auto", -- "auto" (default), "snacks", or "native"
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
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
    cmd = function()
      local cmd = {
        "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatClose",
        "CopilotChatToggle",
        "CopilotChatStop",
        "CopilotChatReset",
        "CopilotChatSave",
        "CopilotChatLoad",
        "CopilotChatDebugInfo",
        "CopilotChatModels",
        "CopilotChatModel",
      }
      for k, _ in pairs(require("copilot_prompts")) do
        table.insert(cmd, "CopilotChat" .. k)
      end
      return cmd
    end,
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      show_help = "yes",
      prompts = require("copilot_prompts"),
    },
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

  {
    "olimorris/codecompanion.nvim",
    enabled = false,
    event = { "VeryLazy" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion Chat" },
    },
    opts = {
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
      },
      display = {
        chat = {
          window = {
            position = "right",
            width = 0.35,
          },
        },
      },
    },
  },

  {
    "yetone/avante.nvim",
    enabled = false,
    event = { "VeryLazy" },
    version = false,
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua",
    },
    opts = {
      provider = "claude",
    },
  },
}
