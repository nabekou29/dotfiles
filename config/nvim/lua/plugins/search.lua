return {
  -- 検索時に右に n/N を表示してくれる
  {
    "kevinhwang91/nvim-hlslens",
    event = { "CmdlineEnter" },
    keys = {
      -- stylua: ignore start
      { "n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>", mode = { "n" }, noremap = true, silent = true },
      { "N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>", mode = { "n" }, noremap = true, silent = true },
      { "*", [[*``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, noremap = true, silent = true },
      { "#", [[#``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, noremap = true, silent = true },
      { "g*", [[g*``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, noremap = true, silent = true },
      { "g#", [[g#``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, noremap = true, silent = true },
      -- stylua: ignore end
    },
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
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "fdschmidt93/telescope-egrepify.nvim" },
      { "dharmx/telescope-media.nvim" },
      { "danielfalk/smart-open.nvim", dependencies = { "kkharji/sqlite.lua" } },
    },
    keys = function()
      local loaded = {}
      local function load_extension(name)
        if not loaded[name] then
          pcall(require("telescope").load_extension, name)
          loaded[name] = true
        end
      end

      return {
        -- 通常の検索
        {
          "<leader>ff",
          function()
            load_extension("fzf")
            load_extension("smart_open")
            require("telescope").extensions.smart_open.smart_open({ cwd_only = true })
          end,
          silent = true,
        },
        -- シンボル
        { "<leader>fs", ":Telescope lsp_dynamic_workspace_symbols<CR>", silent = true },
        -- 参照元
        { "<leader>fr", ":Telescope lsp_references<CR>", silent = true },
        -- 全文検索
        {
          "<leader>fg",
          function()
            load_extension("egrepify")
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
            load_extension("media")
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
      }
    end,
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
        smart_open = {
          show_scores = true,
          match_algorithm = "fzf",
          disable_devicons = false,
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
  },
  -- カーソルが当たった単語をハイライト
  {
    "RRethy/vim-illuminate",
    event = { "FocusLost" },
    config = function()
      require("illuminate").configure({})
    end,
  },
}
