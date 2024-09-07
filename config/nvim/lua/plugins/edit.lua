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
      { "<leader>jt", ":TSJToggle<CR>" },
      { "<leader>js", ":TSJSplit<CR>" },
      { "<leader>jj", ":TSJJoin<CR>" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { use_default_keymaps = false, max_join_length = 256 },
  },
  -- カラーピッカー
  {
    "uga-rosa/ccc.nvim",
    event = { "VeryLazy" },
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
        filetypes = { "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "html" },
      },
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
    "phaazon/hop.nvim",
    keys = function()
      local hop_prefix = "<leader><leader>"
      return {
        { "f", ":HopChar1CurrentLineAC<CR>", silent = true },
        { "F", ":HopChar1CurrentLineBC<CR>", silent = true },
        -- { "f", ":HopChar2CurrentLineAC<CR>", silent = true },
        -- { "F", ":HopChar2CurrentLineBC<CR>", silent = true },
        -- { "t", ":HopChar1AC<CR>", silent = true },
        -- { "T", ":HopChar1BC<CR>", silent = true },
        { "t", ":HopChar2AC<CR>", silent = true },
        { "T", ":HopChar2BC<CR>", silent = true },
        { hop_prefix .. "f", ":HopChar2<CR>" },
        { hop_prefix .. "l", ":HopLineStart<CR>" },
        { hop_prefix .. "/", ":HopPattern<CR>" },
      }
    end,
    opts = {},
  },
  -- w,b,e でキャメルケースを考慮した移動
  {
    "chaoren/vim-wordmotion",
    event = { "VeryLazy" },
    keys = { "w", "b", "e", "W", "B", "E" },
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
