-- https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md
vim.loader.enable()

require("options")
require("lazyvim")
require("keymap")

vim.env.CURRENT_PROGPATH = vim.v.progpath
vim.env.CURRENT_SERVERNAME = vim.v.servername
vim.env.REACT_EDITOR = vim.env.HOME .. "/.config/nvim/scripts/react_editor_launch.sh"
