return {
  -- 文字列を括弧で囲ったりする
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },

  -- , や : などでいい感じに配置するやつ
  {
    "junegunn/vim-easy-align",
    event = { "VeryLazy" },
  },

  -- 括弧や引用符を自動で閉じる
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- 範囲選択
  {
    "terryma/vim-expand-region",
    keys = {
      { "<A-Up>", "<Plug>(expand_region_expand)", mode = { "n", "v" }, desc = "Expand region" },
      { "<A-k>", "<Plug>(expand_region_expand)", mode = { "n", "v" }, desc = "Expand region" },
      { "<A-Down>", "<Plug>(expand_region_shrint)", mode = { "n", "v" }, desc = "Shrint region" },
      { "<A-j>", "<Plug>(expand_region_shrint)", mode = { "n", "v" }, desc = "Shrint region" },
    },
  },

  -- マルチカーソル
  {
    "mg979/vim-visual-multi",
    dependencies = { "kevinhwang91/nvim-hlslens" },
    event = { "VeryLazy" },
  },

  -- 配列などを一行にまとめたり複数行に展開したり
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>jt", "<Cmd>TSJToggle<CR>" },
      { "<leader>js", "<Cmd>TSJSplit<CR>" },
      { "<leader>jj", "<Cmd>TSJJoin<CR>" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { use_default_keymaps = false, max_join_length = 256 },
  },

  -- ダイナミックマクロ
  {
    "tani/dmacro.vim",
    event = { "VeryLazy" },
    keys = {
      { "<C-q>", "<Plug>(dmacro-play-macro)", mode = { "i", "n" }, noremap = true },
    },
  },

  -- レジスタの編集
  {
    "tversteeg/registers.nvim",
    cmd = "Registers",
    keys = {
      { '"', mode = { "n", "v" } },
      { "<C-r>", mode = "i" },
    },
    opts = function()
      local registers = require("registers")

      return {
        show = '*+"-/_=#%.q0123456789:',
        window = {
          border = "rounded",
        },
        bind_keys = {
          -- レジスタの編集
          ["<C-e>"] = function(reg)
            reg = registers._register_symbol(reg)
            local reg_content = vim.fn.getreg(reg)
            vim.ui.input({
              prompt = "Edit register " .. reg .. ": ",
              default = reg_content,
            }, function(input)
              if input == nil or input == "" then
                vim.notify("Edit a register canceled")
                return
              end
              vim.fn.setreg(reg, input)
              registers._close_window()
            end)
          end,
        },
      }
    end,
  },

  -- カラーピッカー
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccConvert", "CccPick" },
    opts = {
      highlighter = {
        auto_enable = false,
      },
    },
  },

  -- カラーハイライト
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "VeryLazy" },
    opts = {
      render = "virtual",
      exclude_filetypes = { "lazy" },
    },
  },

  -- <C-a>, <C-x> の拡張
  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Decrement",
      },
    },
    config = function()
      local augend = require("dial.augend")
      local augend_common = require("dial.augend.common")

      -- ドット記法とブラケット記法を相互変換
      local dotKey = [==[\(\w\+\)\.\([a-zA-Z0-9\-_]\+\)]==]
      local bracketKey = [==[\(\w\+\)\[['"]\([a-zA-Z0-9\-_]\+\)['"]\]]==]
      local propertyAccessor = augend.user.new({
        find = augend_common.find_pattern_regex(dotKey .. "\\|" .. bracketKey),
        add = function(text, _, cursor)
          if text:match("(%w+)%.(.*)") then
            local obj, key = text:match("(%w+)%.(.*)")
            text = obj .. "['" .. key .. "']"
          else
            local obj, key = text:match("(%w+)%[['\"](.*)['\"]%]")
            text = obj .. "." .. key
          end
          cursor = #text
          return { text = text, cursor = cursor }
        end,
      })

      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({
            elements = { "and", "or" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "let", "const" },
            word = false,
            cyclic = true,
          }),
        },
        typescript = {
          propertyAccessor,
        },
      })
    end,
  },

  -- substitution の強化など
  {
    "tpope/vim-abolish",
    event = { "VeryLazy" },
  },

  -- quickfix での置換
  {
    "gabrielpoca/replacer.nvim",
    opts = { rename_files = false },
    keys = {
      {
        "<leader>h",
        function()
          require("replacer").run()
        end,
        desc = "run replacer.nvim",
      },
    },
  },

  -- 移動
  {
    "smoka7/hop.nvim",
    keys = function()
      local hop_prefix = "<leader><leader>"

      local function AC()
        return require("hop.hint").HintDirection.AFTER_CURSOR
      end
      local function BC()
        return require("hop.hint").HintDirection.BEFORE_CURSOR
      end

      return {
        -- stylua: ignore start
        { "f", function() require("hop").hint_char1({ direction = AC(), current_line_only = true }) end },
        { "F", function() require("hop").hint_char1({ direction = BC(), current_line_only = true }) end },
        { "t", function() require("hop").hint_char1({ direction = AC(), current_line_only = true, hint_offset = -1 }) end },
        { "T", function() require("hop").hint_char1({ direction = BC(), current_line_only = true, hint_offset = 1 }) end },
        { hop_prefix .. "f", "<Cmd>HopChar2<CR>" },
        { hop_prefix .. "w", "<Cmd>HopWord<CR>" },
        { hop_prefix .. "l", "<Cmd>HopLineStart<CR>" },
        { hop_prefix .. "/", "<Cmd>HopPattern<CR>" },
        -- stylua: ignore end
      }
    end,
    opts = {},
  },

  -- w,b,e でキャメルケースを考慮した移動
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "e", "<Cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
      { "b", "<Cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
      { "w", "<Cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
    },
    opts = {
      skipInsignificantPunctuation = true,
      consistentOperatorPending = false,
      subwordMovement = true,
      customPatterns = {
        patterns = {},
        overrideDefault = false,
      },
    },
  },

  -- Undo の履歴をツリー表示
  {
    "mbbill/undotree",
    event = { "VeryLazy" },
  },

  -- `jj` でノーマルモードに戻る（入力の遅延回避）
  {
    "max397574/better-escape.nvim",
    lazy = false,
    opts = {
      default_mappings = false,
      mappings = {
        i = {
          j = {
            j = "<Esc>",
          },
        },
        c = {
          j = {
            j = "<Esc>",
          },
        },
      },
    },
  },
}
