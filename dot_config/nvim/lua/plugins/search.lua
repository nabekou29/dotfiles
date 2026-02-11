return {
  -- 検索時に右に n/N を表示してくれる
  {
    "kevinhwang91/nvim-hlslens",
    event = { "CmdlineEnter" },
    keys = {
      -- stylua: ignore start
      { "n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>", mode = { "n" }, desc = "Search next with hlslens" },
      { "N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>", mode = { "n" }, desc = "Search previous with hlslens" },
      { "*", [[*``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, silent = true, desc = "Search word forward with hlslens" },
      { "#", [[#``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, silent = true, desc = "Search word backward with hlslens" },
      { "g*", [[g*``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, silent = true, desc = "Search word forward (partial) with hlslens" },
      { "g#", [[g#``<Cmd>lua require('hlslens').start()<CR>]], mode = { "n" }, silent = true, desc = "Search word backward (partial) with hlslens" },
      -- stylua: ignore end
    },
    opts = {},
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

  -- カーソルが当たった単語をハイライト
  {
    "RRethy/vim-illuminate",
    event = { "FocusLost" },
    config = function()
      require("illuminate").configure({})
    end,
  },
}
