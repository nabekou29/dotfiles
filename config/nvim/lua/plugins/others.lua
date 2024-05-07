return {
  -- キーバインドの確認
  {
    "folke/which-key.nvim",
    cmd = { "WhichKey" },
  },
  -- URL をブラウザで開く
  { "tyru/open-browser.vim", cmd = { "OpenBrowser" } },
  -- 日本語のヘルプ
  {
    "vim-jp/vimdoc-ja",
    event = { "VeryLazy" },
    init = function()
      vim.cmd([[ set helplang=ja,en ]])
    end,
  },
  -- マークダウンプレビュー
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    opt = {},
  },
}
