local vim = vim

-- Option
vim.opt.clipboard = "unnamedplus"

vim.opt.number = true -- 行数表示
vim.opt.expandtab = true -- タブでスペースを入力
vim.opt.tabstop = 2 -- インデントのサイズ
vim.opt.shiftwidth = 2 -- インデントのサイズ

vim.opt.list = true
vim.opt.listchars:append "eol:↴" -- 改行文字
vim.opt.listchars:append "space:⋅" -- 空白文字

vim.opt.swapfile = false -- Swapファイルを生成するか
vim.opt.hidden = true -- バッファを保存しないでも切り替えれるように

-- vim.opt.pumblend = 10

vim.o.timeout = true -- キーのマッピングに対するタイムアウト
vim.o.timeoutlen = 300 -- マッピングのタイムアウトの時間 (規定値: 1000)

-- Key Binding (Pluginは除く)
vim.keymap.set('i', '<C-a>', '<C-o>^', {})
vim.keymap.set({'n', 'v'}, '<C-a>', '^', {})
vim.keymap.set('i', '<C-e>', '<C-o>$', {})
vim.keymap.set({'n', 'v'}, '<C-e>', '$', {})
-- vim.keymap.set({ 'i', 'n' }, '<ESC>', '<ESC>:w<CR>', {})
vim.keymap.set('n', '<C-S-h>', '<cmd>wincmd h<CR>', {})
vim.keymap.set('n', '<C-S-l>', '<cmd>wincmd l<CR>', {})
