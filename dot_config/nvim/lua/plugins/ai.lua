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
    "greggh/claude-code.nvim",
    cmd = {
      "ClaudeCode",
      "ClaudeCodeContinue",
      "ClaudeCodeResume",
      "ClaudeCodeVerbose",
    },
    keys = {
      "<C-,>",
    },
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    opts = {
      window = {
        split_ratio = 0.4,
        position = "vertical botright", -- Position of the window: "botright", "topleft", "vertical", "rightbelow vsplit", etc.
      },
      git = {
        use_git_root = false, -- Set CWD to git root when opening Claude Code (if in git project)
      },
    },
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
