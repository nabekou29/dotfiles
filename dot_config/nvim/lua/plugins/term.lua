return {
  -- ターミナルをフローティングで呼び出すやつ
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec", "TermCloseAll", "TermOpenAll" },
    keys = {
      "<M-t>",
      "<M-T>",
      "<leader>gg",
      "<C-g>",
      "<leader>gd",
    },
    config = function()
      require("toggleterm").setup({
        size = 80,
      })
      local Terminal = require("toggleterm.terminal").Terminal

      local main = Terminal:new({
        hidden = true,
        direction = "float",
        float_opts = {
          border = "double",
          -- winblend = 20,
        },
      })
      local function _main_toggle()
        main:toggle()
      end
      vim.keymap.set({ "n", "t" }, "<M-t>", function()
        _main_toggle()
      end)

      local sub = Terminal:new({
        hidden = true,
        direction = "vertical",
      })
      local function _sub_toggle()
        sub:toggle()
      end
      vim.keymap.set({ "n", "t" }, "<M-T>", function()
        _sub_toggle()
      end)

      -- Lazygit
      local base_config_path = "$HOME/.config/lazygit/config.yml"
      local custom_config_path = "$HOME/.config/nvim/lazygit_for_nvim.yml"
      local paths = '"' .. base_config_path .. "," .. custom_config_path .. '"'

      local lazygit = Terminal:new({
        cmd = "lazygit --ucf " .. paths,
        hidden = true,
        direction = "float",
        float_opts = {
          border = "double",
          -- winblend = 20,
        },
      })
      local function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set("n", "<leader>gg", function()
        _lazygit_toggle()
      end)
      vim.keymap.set({ "n", "t" }, "<C-g>", function()
        _lazygit_toggle()
      end)

      -- GitHub Dashboard
      local dashboard = Terminal:new({
        cmd = "gh dash",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "double",
          -- winblend = 20,i
        },
      })
      local function _dashboard_toggle()
        dashboard:toggle()
      end

      vim.keymap.set("n", "<leader>gd", function()
        _dashboard_toggle()
      end)
    end,
  },
}
