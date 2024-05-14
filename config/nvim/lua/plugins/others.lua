local constants = require("constants")

return {
  -- キーバインドの確認
  {
    "folke/which-key.nvim",
    cmd = { "WhichKey" },
  },
  -- URL をブラウザで開く
  { "tyru/open-browser.vim", cmd = { "OpenBrowser" }, keys = { { "gx", "<Plug>(openbrowser-smart-search)" } } },
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
  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>on", ":ObsidianNew<CR>" },
      { "<leader>oO", ":ObsidianOpen<CR>" },
      { "<leader>oo", ":ObsidianQuickSwitch<CR>" },
      { "<leader>or", ":ObsidianRename<CR>" },
      { "<leader>os", ":ObsidianSearch<CR>" },
      {
        "<leader>oe",
        function()
          local obsidian = require("obsidian")
          local client = obsidian.get_client()
          local current_path = vim.fn.expand("%:p")
          -- 現在のバッファが Obsidian のファイルであれば、そのファイルの親ディレクトリを開く
          if current_path:match(vim.fs.normalize(constants.path.obsidian_docs)) then
            local parent_path = vim.fs.dirname(current_path)
            vim.cmd("e " .. parent_path)
          else
            vim.cmd("e " .. client:vault_root().filename)
          end
        end,
      },
    },
    cmd = {
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianTags",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTomorrow",
      "ObsidianDailies",
      "ObsidianTemplate",
      "ObsidianSearch",
      "ObsidianLink",
      "ObsidianLinkNew",
      "ObsidianLinks",
      "ObsidianExtractNote",
      "ObsidianWorkspace",
      "ObsidianPasteImg",
      "ObsidianRename",
      "ObsidianToggleCheckbox",
    },
    opts = {
      workspaces = {
        {
          name = "Notes",
          path = constants.path.obsidian_docs .. "/Notes",
        },
      },
    },
    config = function(_, opts)
      local obsidian = require("obsidian")
      obsidian.setup(opts)

      -- Obsidian のファイルのみ conceallevel を設定する
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
          local filepath = vim.fn.expand("%:p")
          if filepath:match(vim.fs.normalize(constants.path.obsidian_docs)) then
            vim.wo.conceallevel = 1
            -- else
            --   vim.wo.conceallevel = nil
          end
        end,
      })
    end,
  },
}
