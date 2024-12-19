return {
  -- 検索時に右に n/N を表示してくれる
  {
    "kevinhwang91/nvim-hlslens",
    event = { "CmdlineEnter" },
    keys = {
      -- stylua: ignore start
      { "n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>", mode = { "n" } },
      { "N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>", mode = { "n" } },
      { "*", [[*``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, silent = true },
      { "#", [[#``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, silent = true },
      { "g*", [[g*``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, silent = true },
      { "g#", [[g#``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, silent = true },
      -- stylua: ignore end
    },
    opts = {},
  },

  -- ローマ字検索
  {
    "lambdalisue/kensaku.vim",
    event = { "CmdlineEnter" },
    dependencies = { "vim-denops/denops.vim" },
  },
  {
    "lambdalisue/kensaku-search.vim",
    dependencies = { "lambdalisue/kensaku.vim" },
    keys = {
      { "<CR>", "<Plug>(kensaku-search-replace)<CR>", mode = "c" },
    },
  },

  -- \v \V 切り替え
  {
    "kawarimidoll/magic.vim",
    event = { "CmdlineEnter" },
    init = function()
      vim.cmd([[
        cnoremap <expr> <C-x> magic#expr()
      ]])
    end,
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    event = { "VeryLazy" },
    cmd = { "Telescope" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
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
        },
        -- シンボル
        { "<leader>fs", "<CMD>Telescope lsp_dynamic_workspace_symbols<CR>" },
        -- 参照元
        { "gr", "<CMD>Telescope lsp_references<CR>" },
        -- 全文検索
        {
          "<leader>fg",
          function()
            load_extension("egrepify")
            require("telescope").extensions.egrepify.egrepify({})
          end,
          desc = ":Telescope egrepify",
        },
        -- バッファから検索
        {
          "<leader>fb",
          function()
            require("telescope.builtin").buffers()
          end,
          desc = ":Telescope buffers",
        },
        -- コマンドの履歴
        {
          "<leader>:",
          function()
            require("telescope.builtin").command_history()
          end,
          desc = ":Telescope command_history",
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
        },
        -- help
        {
          "<leader>fh",
          function()
            require("telescope.builtin").help_tags()
          end,
          desc = ":Telescope help_tags",
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
            -- ["<M-d>"] = function(prompt_bufnr)
            --   require("telescope.actions").delete_buffer(prompt_bufnr)
            -- end,
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
            ["#"] = {
              flag = "glob",
              cb = function(input)
                return string.format([[*.{%s}]], input)
              end,
            },
            ["!#"] = {
              flag = "glob",
              cb = function(input)
                return string.format([[!*.{%s}]], input)
              end,
            },
            [">"] = {
              flag = "glob",
              cb = function(input)
                return string.format([[**/{%s}*/**]], input)
              end,
            },
            ["!>"] = {
              flag = "glob",
              cb = function(input)
                return string.format([[!**/{%s}*/**]], input)
              end,
            },
            ["&"] = {
              flag = "glob",
              cb = function(input)
                return string.format([[*{%s}*]], input)
              end,
            },
            ["!&"] = {
              flag = "glob",
              cb = function(input)
                return string.format([[!*{%s}*]], input)
              end,
            },
            ["-H"] = { flag = "hidden" },
            ["-U"] = { flag = "U" },
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
      -- 非同期でプラグインを読み込む
      vim.schedule(function()
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("smart_open")
        require("telescope").load_extension("egrepify")
        require("telescope").load_extension("media")
      end)
    end,
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
