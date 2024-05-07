return {
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
          augend.constant.new({ elements = { "let", "const" } }),
        },
      })
    end,
  },
  {
    "uga-rosa/ccc.nvim",
    event = { "VeryLazy" },
    config = function()
      require("ccc").setup({
        highlighter = { auto_enable = true, lsp = true },
      })
    end,
  },
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
}
