-- https://github.com/nvim-telescope/telescope.nvim
return {
  {
    "lambdalisue/kensaku.vim",
    dependencies = {
      "vim-denops/denops.vim",
    },
  },
  {
    "lambdalisue/kensaku-search.vim",
    lazy = false,
    dependencies = {
      "lambdalisue/kensaku.vim",
    },
    init = function()
      vim.keymap.set("c", "<CR>", "<Plug>(kensaku-search-replace)<CR>")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "kkharji/sqlite.lua" },
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- build = "make",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      {
        "fdschmidt93/telescope-egrepify.nvim",
      },
      {
        "Allianaab2m/telescope-kensaku.nvim",
        dependencies = {
          "lambdalisue/kensaku.vim",
        },
      },
      { "dharmx/telescope-media.nvim" },
      { "nvim-telescope/telescope-media-files.nvim" },
    },
    init = function()
      -- 通常の検索
      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
      -- 隠しファイル込み
      vim.keymap.set("n", "<leader>fF", ":Telescope find_files hidden=true<CR>")
      -- シンボル
      vim.keymap.set("n", "<leader>fs", ":Telescope lsp_dynamic_workspace_symbols<CR>")
      -- 最近開いたファイル
      vim.keymap.set("n", "<leader>fr", ":Telescope frecency workspace=CWD<CR>")
      -- 全文検索
      vim.keymap.set("n", "<leader>fg", function()
        require("telescope").extensions.egrepify.egrepify({})
      end, {
        desc = ":Telescope egrepify",
      })
      -- バッファから検索
      vim.keymap.set("n", "<leader>fb", function()
        require("telescope.builtin").buffers()
      end, {
        desc = ":Telescope buffers",
      })
      -- コマンドの履歴
      vim.keymap.set("n", "<leader>:", function()
        require("telescope.builtin").command_history()
      end, {
        desc = ":Telescope command_history",
      })
      -- メディア
      vim.keymap.set("n", "<leader>fm", function()
        -- require("telescope").extensions.media.media()
        require("telescope").extensions.media.media({
          find_command = {
            "rg",
            "--files",
            "--glob",
            "*.{png,jpg,jpeg,svg,gif,mp4,pdf,webp,webm}",
            ".",
          },
        })
      end, {
        desc = ":Telescope media",
      })
      -- help
      vim.keymap.set("n", "<leader>fh", function()
        require("telescope.builtin").help_tags()
      end, {
        desc = ":Telescope help_tags",
      })
    end,
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup({
        defaults = {
          prompt_prefix = " ",
          mappings = {
            i = {
              ["<C-S-j>"] = require("telescope.actions").cycle_history_next,
              ["<C-S-K>"] = require("telescope.actions").cycle_history_prev,
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
          media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = { "png", "webp", "jpg", "jpeg", "svg", "webp", "gif" },
            -- find command (defaults to `fd`)
            find_cmd = "rg",
          },
        },
      })

      pcall(require("telescope").load_extension, "frecency")
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "kenasku")
      pcall(require("telescope").load_extension, "egrepify")
      -- pcall(require("telescope").load_extension, "media")
      pcall(require("telescope").load_extension, "media_files")
    end,
  },
}
