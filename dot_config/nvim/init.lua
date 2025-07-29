if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  ---@diagnostic disable-next-line: missing-fields
  require("snacks.profiler").startup({
    startup = {
      -- event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      event = "VeryLazy",
    },
  })
end

-- https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md
vim.loader.enable()

require("options")
require("filetype")
require("lazyvim")
require("local_config")
require("keymap")
require("abbr")
require("command")

vim.env.CURRENT_PROGPATH = vim.v.progpath
vim.env.CURRENT_SERVERNAME = vim.v.servername
vim.env.REACT_EDITOR = vim.env.HOME .. "/.config/nvim/scripts/react_editor_launch.sh"
