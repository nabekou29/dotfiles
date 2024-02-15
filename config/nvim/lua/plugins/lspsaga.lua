return {
  "nvimdev/lspsaga.nvim",
  cmd = { "Lspsaga" },
  event = { "LspAttach" },
  dependencies = {
    { "nvim-tree/nvim-web-devicons" }, -- Please make sure you install markdown and markdown_inline parser
    { "nvim-treesitter/nvim-treesitter" },
  },
  init = function()
    local keymap = vim.keymap.set
    keymap("n", "gh", "<cmd>Lspsaga finder<CR>")

    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

    keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
    keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>")
    keymap("n", "gn", "<cmd>Lspsaga rename<CR>")
    keymap("n", "gN", "<cmd>Lspsaga rename ++project<CR>")

    keymap("n", "ga", "<cmd>Lspsaga code_action<CR>")

    keymap("n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
    keymap("n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>")
  end,
  config = function()
    require("lspsaga").setup({
      -- https://github.com/nvimdev/lspsaga.nvim/blob/main/lua/lspsaga/init.lua#L5
      symbol_in_winbar = {
        folder_level = 3,
      },
    })
  end,
}
