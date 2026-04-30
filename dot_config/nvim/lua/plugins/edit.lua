return {
  -- 文字列を括弧で囲ったりする
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    keys = {
      { "ys", mode = "n" },
      { "ds", mode = "n" },
      { "cs", mode = "n" },
      { "S", mode = "x" },
    },
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },

  -- , や : などでいい感じに配置するやつ
  {
    "junegunn/vim-easy-align",
    keys = {
      { "<A-a>", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Easy Align" },
    },
  },

  -- 行の移動
  {
    "echasnovski/mini.move",
    keys = {
      { "H", mode = "x", desc = "Move selection left" },
      { "L", mode = "x", desc = "Move selection right" },
      { "J", mode = "x", desc = "Move selection down" },
      { "K", mode = "x", desc = "Move selection up" },
    },
    opts = {
      mappings = {
        left = "H",
        right = "L",
        down = "J",
        up = "K",
        line_left = "",
        line_right = "",
        line_down = "",
        line_up = "",
      },
    },
  },

  -- 括弧や引用符を自動で閉じる
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- マルチカーソル
  {
    "mg979/vim-visual-multi",
    dependencies = { "kevinhwang91/nvim-hlslens" },
    keys = {
      { "<C-n>", mode = { "n", "x" }, desc = "Visual Multi: Find Under" },
      { "<C-Up>", mode = { "n" }, desc = "Visual Multi: Add Cursor Up" },
      { "<C-Down>", mode = { "n" }, desc = "Visual Multi: Add Cursor Down" },
    },
  },

  -- 配列などを一行にまとめたり複数行に展開したり
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>jt", "<Cmd>TSJToggle<CR>", desc = "Toggle split/join" },
      { "<leader>js", "<Cmd>TSJSplit<CR>", desc = "Split to multiple lines" },
      { "<leader>jj", "<Cmd>TSJJoin<CR>", desc = "Join to single line" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { use_default_keymaps = false, max_join_length = 256 },
  },

  -- レジスタの編集
  {
    "tversteeg/registers.nvim",
    cmd = "Registers",
    keys = {
      { '"', mode = { "n", "v" }, desc = "Show registers" },
      { "<C-r>", mode = "i", desc = "Insert from register" },
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

  -- <C-a>, <C-x> の拡張
  {
    "monaqa/dial.nvim",
    vscode = true,
    keys = {
      -- stylua: ignore start
      { "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  mode = "n", desc = "Increment" },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  mode = "n", desc = "Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, mode = "n", desc = "Increment (sequential)" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, mode = "n", desc = "Decrement (sequential)" },
      { "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  mode = "v", desc = "Increment" },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  mode = "v", desc = "Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v", desc = "Increment (sequential)" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v", desc = "Decrement (sequential)" },
      -- stylua: ignore end
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
          -- Markdown のチェックボックス
          augend.constant.new({
            elements = { "[ ]", "[x]" },
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
    cmd = { "S", "Subvert", "Abolish" },
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
      local hop_prefix = "<C-f>"
      return {
        -- stylua: ignore start
        { hop_prefix .. "f",     "<Cmd>HopChar2<CR>",     desc = "Hop to 2-char match" },
        { hop_prefix .. "<C-f>", "<Cmd>HopChar2<CR>",     desc = "Hop to 2-char match" },
        { hop_prefix .. "w",     "<Cmd>HopWord<CR>",      desc = "Hop to word" },
        { hop_prefix .. "l",     "<Cmd>HopLineStart<CR>", desc = "Hop to line start" },
        { hop_prefix .. "/",     "<Cmd>HopPattern<CR>",   desc = "Hop to pattern" },
        { "<C-/>",               "<Cmd>HopPattern<CR>",   desc = "Hop to pattern" },
        -- stylua: ignore end
      }
    end,
    opts = {},
  },

  -- `]g` や `]c` などを繰り返し可能にする
  {
    "mawkler/demicolon.nvim",
    keys = {
      { ";", mode = { "n", "x", "o" } },
      { ",", mode = { "n", "x", "o" } },
      { "f", mode = { "n", "x", "o" } },
      { "F", mode = { "n", "x", "o" } },
      { "t", mode = { "n", "x", "o" } },
      { "T", mode = { "n", "x", "o" } },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      horizontal_motions = true,
      repeat_motions = "stateless",
    },
  },

  -- w,b,e でキャメルケースを考慮した移動
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "E", "<Cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Spider: Move to end of word" },
      { "B", "<Cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Spider: Move to previous word" },
      { "W", "<Cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Spider: Move to next word" },
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
    "XXiaoA/atone.nvim",
    cmd = "Atone",
    opts = {},
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
