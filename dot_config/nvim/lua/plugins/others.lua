local constants = require("constants")

return {
  -- キーバインドの確認
  {
    "folke/which-key.nvim",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- 日本語のヘルプ
  {
    "vim-jp/vimdoc-ja",
    event = { "VeryLazy" },
    init = function()
      vim.cmd([[ set helplang=ja,en ]])
    end,
  },

  -- IME
  {
    "keaising/im-select.nvim",
    event = { "InsertEnter" },
    opts = {
      set_default_events = { "VimEnter", "FocusGained", "InsertLeave", "CmdlineLeave" },
      set_previous_events = {
        --"InsertEnter"
      },
    },
  },

  -- nvim を http リクエスト経由で開く
  {
    "nabekou29/open-by-http.nvim",
    cmd = { "OpenByHttpServerStart", "OpenByHttpServerStop" },
    event = { "FocusLost" },
    opts = {
      auto_start = false,
    },
  },

  -- キーストロークの表示
  {
    "4513ECHO/nvim-keycastr",
    init = function()
      vim.api.nvim_create_user_command("KeyCastrEnable", function()
        require("keycastr").enable()
      end, {})
      vim.api.nvim_create_user_command("KeyCastrDisable", function()
        require("keycastr").disable()
      end, {})
    end,
    config = function()
      require("keycastr").config.set({
        win_config = {
          border = "rounded",
          width = 50,
          height = 1,
        },
        ignore_mouse = true,
        position = "SE",
      })
    end,
  },

  -- マークダウンプレビュー
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>oo", "<CMD>ObsidianToday<CR>", desc = "Obsidian: Open today's note" },
      { "<leader>on", "<CMD>ObsidianNew<CR>", desc = "Obsidian: New note" },
      { "<leader>oO", "<CMD>ObsidianOpen<CR>", desc = "Obsidian: Open in app" },
      { "<leader>or", "<CMD>ObsidianRename<CR>", desc = "Obsidian: Rename note" },
      {
        "<leader>oe",
        function()
          require("fyler").open({ dir = require("obsidian").get_client():vault_root().filename })
        end,
        desc = "Obsidian: Open vault in file explorer",
      },
      {
        "<leader>of",
        function()
          Snacks.picker.smart({ cwd = require("obsidian").get_client():vault_root().filename })
        end,
        desc = "Obsidian: Find files in vault",
      },
      {
        "<leader>og",
        function()
          Snacks.picker.grep({ cwd = require("obsidian").get_client():vault_root().filename })
        end,
        desc = "Obsidian: Grep in vault",
      },
    },
    cmd = {
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianTags",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTomorrow",
      "ObsidianDailies",
      "ObsidianTemplate",
      "ObsidianSearch",
      "ObsidianLink",
      "ObsidianLinkNew",
      "ObsidianLinks",
      "ObsidianExtractNote",
      "ObsidianWorkspace",
      "ObsidianPasteImg",
      "ObsidianRename",
      "ObsidianToggleCheckbox",
    },
    opts = {
      workspaces = {
        {
          name = "obsidian",
          path = constants.path.obsidian_docs,
        },
      },
      templates = {
        folder = "_template",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },
      daily_notes = {
        folder = "10_daily",
        date_format = "%Y/%m/%Y-%m-%d",
        -- alias_format = "%Y年%m月%d日",
        default_tags = { "daily-notes" },
        template = "daily.md",
      },
      ui = {
        enable = false,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          -- [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          -- ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          -- ["!"] = { char = "", hl_group = "ObsidianImportant" },
        },
      },
    },
    config = function(_, opts)
      local obsidian = require("obsidian")
      obsidian.setup(opts)
    end,
  },

  {
    "seandewar/bad-apple.nvim",
    cmd = { "BadApple" },
  },

  {
    "p5quared/apple-music.nvim",
    keys = {
      -- stylua: ignore start
      { "<leader>amp", function() require("apple-music").toggle_play() end,     desc = "Toggle [P]layback" },
      { "<leader>ams", function() require("apple-music").toggle_shuffle() end,  desc = "Toggle [S]huffle" },
      { "<leader>fap", function() require("apple-music").select_playlist() end, desc = "[F]ind [P]laylists" },
      { "<leader>faa", function() require("apple-music").select_album() end,    desc = "[F]ind [A]lbum" },
      { "<leader>fas", function() require("apple-music").select_track() end,    desc = "[F]ind [S]ong" },
      { "<leader>amx", function() require("apple-music").cleanup_all() end,     desc = "Cleanup Temp Playlists" },
      -- stylua: ignore end
    },
    opts = {},
  },

  { "willothy/wezterm.nvim", opts = {} },
}
