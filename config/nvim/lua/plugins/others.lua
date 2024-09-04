local constants = require("constants")

return {
  -- キーバインドの確認
  {
    "folke/which-key.nvim",
    cmd = { "WhichKey" },
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
      "hrsh7th/nvim-cmp",
    },
    keys = {
      { "<leader>on", ":ObsidianNew<CR>" },
      { "<leader>oO", ":ObsidianOpen<CR>" },
      { "<leader>oo", ":ObsidianQuickSwitch<CR>" },
      { "<leader>or", ":ObsidianRename<CR>" },
      { "<leader>os", ":ObsidianSearch<CR>" },
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
          name = "Notes",
          path = constants.path.obsidian_docs .. "/Notes",
        },
      },
      templates = {
        folder = "_template",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },
      ui = {
        enable = false,
      },
    },
    config = function(_, opts)
      local obsidian = require("obsidian")
      obsidian.setup(opts)
    end,
  },
  {
    "subnut/nvim-ghost.nvim",
    event = { "FocusLost" },
    init = function() end,
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
    -- telescope が読み込まれて起動が遅くなるので無効化
    enabled = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = { "VeryLazy" },
    config = {},
    keys = {
      {
        "<leader>amp",
        function()
          require("apple-music").toggle_play()
        end,
        desc = "Toggle [P]layback",
      },
      {
        "<leader>ams",
        function()
          require("apple-music").toggle_shuffle()
        end,
        desc = "Toggle [S]huffle",
      },
      {
        "<leader>fap",
        function()
          require("apple-music").select_playlist_telescope()
        end,
        desc = "[F]ind [P]laylists",
      },
      {
        "<leader>faa",
        function()
          require("apple-music").select_album_telescope()
        end,
        desc = "[F]ind [A]lbum",
      },
      {
        "<leader>fas",
        function()
          require("apple-music").select_track_telescope()
        end,
        desc = "[F]ind [S]ong",
      },
      {
        "<leader>amx",
        function()
          require("apple-music").cleanup_all()
        end,
        desc = "Cleanup Temp Playlists",
      },
    },
  },
}
