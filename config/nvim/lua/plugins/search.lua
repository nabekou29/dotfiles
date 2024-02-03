-- https://github.com/nvim-telescope/telescope.nvim
return {
  {
    'lambdalisue/kensaku.vim',
    dependencies = {
      'vim-denops/denops.vim',
    }
  },
  {
    'lambdalisue/kensaku-search.vim',
    lazy = false,
    dependencies = {
      'lambdalisue/kensaku.vim',
    },
    init = function()
      vim.keymap.set('c', '<CR>', '<Plug>(kensaku-search-replace)<CR>')
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    cmd = { "Telescope" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
          require "telescope".load_extension("frecency")
        end,
        dependencies = { "kkharji/sqlite.lua" }
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
        cond = function()
          return vim.fn.executable 'make' == 1
        end
      },
      {
        "fdschmidt93/telescope-egrepify.nvim",
        config = function()
          require("telescope").load_extension("egrepify")
        end
      },
      {
        "Allianaab2m/telescope-kensaku.nvim",
        dependencies = {
          "lambdalisue/kensaku.vim",
        },
        config = function()
          require("telescope").load_extension("kensaku") -- :Telescope kensaku
        end
      }
    },
    init = function()
      -- 通常の検索
      vim.keymap.set('n', '<leader>ff', function()
        require('telescope.builtin').find_files()
      end, {
        desc = ':Telescope find_files'
      })
      -- 隠しファイル込み
      vim.keymap.set('n', '<leader>fF', function()
        require('telescope.builtin').find_files({
          hidden = true
        })
      end, {
        desc = ':Telescope find_files find_command=rg,--hidden,--files'
      })
      -- 最近開いたファイル
      vim.keymap.set('n', '<leader>fr', ':Telescope frecency workspace=CWD<CR>')
      -- 全文検索
      vim.keymap.set('n', '<leader>fg', function()
        require('telescope').extensions.egrepify.egrepify({})
      end, {
        desc = ':Telescope egrepify'
      })
      -- バッファから検索
      vim.keymap.set('n', '<leader>fb', function()
        require('telescope.builtin').buffers()
      end, {
        desc = ':Telescope buffers'
      })
      vim.keymap.set('n', '<leader>fh', function()
        require('telescope.builtin').help_tags()
      end, {
        desc = ':Telescope help_tags'
      })
    end,
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = false,
            override_file_sorter = true,
            case_mode = "smart_case"
          }
        }
      }

      pcall(require('telescope').load_extension, 'fzf')
    end
  }
}
