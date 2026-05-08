return {
  {
    "yutkat/history-ignore.nvim",
    event = { "CmdlineEnter" },
    opts = {},
  },
  {
    "rachartier/tiny-cmdline.nvim",
    lazy = false,
    config = function()
      require("tiny-cmdline").setup({
        on_reposition = require("tiny-cmdline").adapters.blink,
      })
    end,
  },
}
