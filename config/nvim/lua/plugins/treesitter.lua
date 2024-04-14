return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy" },
    dependencies = { {
      "windwp/nvim-ts-autotag",
      event = { "VeryLazy" },
      opts = {},
    } },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_install = "all",
        auto_install = true,
        highlight = {
          enable = true,
          disable = {},
          additional_vim_regex_highlighting = false,
        },
        autotag = {
          enable = true,
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = true,
          filetypes = { "html", "xml", "javascriptreact", "typescriptreact", "svelte", "vue" },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "VeryLazy" },
    config = function()
      require("treesitter-context").setup({
        max_lines = 12,
      })
    end,
  },
}
