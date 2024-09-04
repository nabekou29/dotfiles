return {
  -- 検索時に右に n/N を表示してくれる
  {
    "kevinhwang91/nvim-hlslens",
    event = { "VeryLazy" },
    opts = {},
  },
  -- ローマ字検索
  {
    "lambdalisue/kensaku.vim",
    dependencies = { "vim-denops/denops.vim" },
  },
  {
    "lambdalisue/kensaku-search.vim",
    dependencies = { "lambdalisue/kensaku.vim" },
    keys = {
      { "<CR>", "<Plug>(kensaku-search-replace)<CR>", mode = "c" },
    },
  },
  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "prochri/telescope-all-recent.nvim",
        dependencies = { "kkharji/sqlite.lua" },
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "fdschmidt93/telescope-egrepify.nvim" },
      {
        "Allianaab2m/telescope-kensaku.nvim",
        dependencies = {
          "lambdalisue/kensaku.vim",
        },
      },
      { "dharmx/telescope-media.nvim" },
      { "nvim-telescope/telescope-frecency.nvim" },
    },
    keys = {
      -- 通常の検索
      { "<leader>ff", ":Telescope frecency workspace=CWD<CR>", silent = true },
      -- シンボル
      { "<leader>fs", ":Telescope lsp_dynamic_workspace_symbols<CR>", silent = true },
      -- 参照元
      { "<leader>fr", ":Telescope lsp_references<CR>", silent = true },
      -- 全文検索
      {
        "<leader>fg",
        function()
          require("telescope").extensions.egrepify.egrepify({})
        end,
        desc = ":Telescope egrepify",
        silent = true,
      },
      -- バッファから検索
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = ":Telescope buffers",
        silent = true,
      },
      -- コマンドの履歴
      {
        "<leader>:",
        function()
          require("telescope.builtin").command_history()
        end,
        desc = ":Telescope command_history",
        silent = true,
      },
      -- メディア
      {
        "<leader>fm",
        function()
          require("telescope").extensions.media.media({
            find_command = {
              "rg",
              "--files",
              "--glob",
              "*.{png,jpg,jpeg,svg,gif,mp4,pdf,webp,webm}",
              ".",
            },
          })
        end,
        desc = ":Telescope media",
        silent = true,
      },
      -- help
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = ":Telescope help_tags",
        silent = true,
      },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        mappings = {
          i = {
            ["<C-S-j>"] = function(prompt_bufnr)
              require("telescope.actions").cycle_history_next(prompt_bufnr)
            end,
            ["<C-S-K>"] = function(prompt_bufnr)
              require("telescope.actions").cycle_history_prev(prompt_bufnr)
            end,
          },
        },
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "-uu",
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = false,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        egrepify = {
          prefixes = {
            ["-H"] = {
              flag = "hidden",
            },
          },
        },
        media = {
          backend = "chafa", -- image/gif backend
          backend_options = {
            chafa = {
              -- move = true, -- GIF preview
              extra_args = {
                ["-f"] = "symbols",
                ["--scale"] = "max",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)

      pcall(require("telescope-all-recent").setup, {})
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "kenasku")
      pcall(require("telescope").load_extension, "egrepify")
      pcall(require("telescope").load_extension, "media")
      pcall(require("telescope").load_extension, "frecency")
    end,
  },
  -- カーソルが当たった単語をハイライト
  {
    "RRethy/vim-illuminate",
    event = { "FocusLost", "CursorHold" },
    config = function()
      require("illuminate").configure({})
    end,
  },
}
