local constants = require("constants")

return {
  -- キーバインドの確認
  { "folke/which-key.nvim", cmd = { "WhichKey" } },

  -- どのキーバインドが空いてるかの確認
  { "meznaric/key-analyzer.nvim", cmd = { "KeyAnalyzer" }, opts = {} },

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
      enabled = function()
        return #vim.fs.find("package.json", {}) > 0
      end,
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

  -- WakaTime
  { "wakatime/vim-wakatime", lazy = false, enabled = false },

  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    keys = {
      { "<leader>oo", "<CMD>ObsidianToday<CR>" },
      { "<leader>on", "<CMD>ObsidianNew<CR>" },
      { "<leader>oO", "<CMD>ObsidianOpen<CR>" },
      { "<leader>of", "<CMD>ObsidianQuickSwitch<CR>" },
      { "<leader>or", "<CMD>ObsidianRename<CR>" },
      { "<leader>os", "<CMD>ObsidianSearch<CR>" },
      { "<leader>og", "<CMD>ObsidianSearch<CR>" },
      {
        "<leader>oe",
        function()
          local obsidian = require("obsidian")
          local client = obsidian.get_client()
          local current_path = vim.fn.expand("%:p")
          -- 現在のバッファが Obsidian のファイルであれば、そのファイルの親ディレクトリを開く
          if current_path:match(vim.fs.normalize(constants.path.obsidian_docs)) then
            local parent_path = vim.fs.dirname(current_path)
            vim.cmd("e " .. parent_path)
          else
            vim.cmd("e " .. client:vault_root().filename)
          end
        end,
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
        folder = "daily",
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
    "subnut/nvim-ghost.nvim",
    lazy = false,
    config = function()
      vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = { "*github.com" },
        group = "nvim_ghost_user_autocommands",
        callback = function()
          vim.opt.filetype = "markdown"
        end,
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
      { "<leader>amp", function() require("apple-music").toggle_play() end,               desc = "Toggle [P]layback" },
      { "<leader>ams", function() require("apple-music").toggle_shuffle() end,            desc = "Toggle [S]huffle" },
      { "<leader>fap", function() require("apple-music").select_playlist_telescope() end, desc = "[F]ind [P]laylists" },
      { "<leader>faa", function() require("apple-music").select_album_telescope() end,    desc = "[F]ind [A]lbum" },
      { "<leader>fas", function() require("apple-music").select_track_telescope() end,    desc = "[F]ind [S]ong" },
      { "<leader>amx", function() require("apple-music").cleanup_all() end,               desc = "Cleanup Temp Playlists" },
      -- stylua: ignore end
    },
    opts = {},
  },

  { "willothy/wezterm.nvim", opts = {} },

  {
    "alexghergh/nvim-tmux-navigation",
    enabled = function()
      return vim.fn.exists("$TMUX") == 1
    end,
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    opts = {
      disable_when_zoomed = true,
      keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
      },
    },
  },
  {
    "https://github.com/swaits/zellij-nav.nvim",
    enabled = function()
      return vim.fn.exists("$ZELLIJ") == 1
    end,
    event = "VeryLazy",
    keys = {
      { "<c-h>", "<cmd>ZellijNavigateLeft<cr>", { esc = "navigate left or tab" } },
      { "<c-j>", "<cmd>ZellijNavigateDown<cr>", { esc = "navigate down" } },
      { "<c-k>", "<cmd>ZellijNavigateUp<cr>", { esc = "navigate up" } },
      { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { esc = "navigate right or tab" } },
    },
    opts = {},
    init = function()
      vim.api.nvim_create_autocmd("FocusLost", {
        pattern = "*",
        command = "silent !zellij action switch-mode normal",
      })
      vim.api.nvim_create_autocmd("FocusGained", {
        pattern = "*",
        command = "silent !zellij action switch-mode locked",
      })
      vim.cmd("silent !zellij action switch-mode locked")
    end,
  },
}
