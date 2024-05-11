local hop_prefix = "<leader><leader>"

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
  -- 括弧や引用符を自動で閉じる
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  -- コメントアウト
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    event = { "VeryLazy" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
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
    event = { "VeryLazy" },
  },
  -- 配列などを一行にまとめたり複数行に展開したり
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>jt", ":TSJToggle<CR>" },
      { "<leader>js", ":TSJUSplit<CR>" },
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
      highlighter = { auto_enable = true, lsp = true },
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
      })
    end,
  },
  -- 移動
  {
    "phaazon/hop.nvim",
    dependencies = { { "unblevable/quick-scope" } },
    keys = {
      { "f", ":HopChar1CurrentLineAC<CR>", silent = true },
      { "F", ":HopChar1CurrentLineBC<CR>", silent = true },
      { "t", ":HopChar1AC<CR>", silent = true },
      { "T", ":HopChar1BC<CR>", silent = true },
      { hop_prefix .. "f", ":HopChar2<CR>" },
      { hop_prefix .. "l", ":HopLineStart<CR>" },
      { hop_prefix .. "/", ":HopPattern<CR>" },
    },
    opts = {},
  },
}
