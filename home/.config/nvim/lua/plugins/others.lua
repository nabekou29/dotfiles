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
}
