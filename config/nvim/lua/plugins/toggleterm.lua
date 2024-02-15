return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec", "TermCloseAll", "TermOpenAll" },
    event = { "VeryLazy" },
    config = function()
      require("toggleterm").setup({})

      local base_config_path = "$HOME/Library/Application Support/lazygit/config.yml"
      local custom_config_path = "$HOME/.config/nvim/lazygit_for_nvim.yml"
      local paths = '"' .. base_config_path .. "," .. custom_config_path .. '"'

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit --ucf " .. paths,
        hidden = true,
        direction = "float",
        float_opts = {
          border = "double",
          winblend = 20,
        },
        -- 閉じたらすべてのバッファを再読み込みする
        -- on_close = function(term)
        --   vim.cmd("bufdo edit!")
        -- end,
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
    end,
  },
}
