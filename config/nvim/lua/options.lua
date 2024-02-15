-- Option
vim.opt.clipboard = "unnamedplus"

vim.opt.number = true -- 行数表示
vim.opt.signcolumn = "yes" -- サインカラムを常に表示（ガタつき防止）
vim.opt.expandtab = true -- タブでスペースを入力
vim.opt.tabstop = 2 -- インデントのサイズ
vim.opt.shiftwidth = 2 -- インデントのサイズ

vim.opt.list = true
vim.opt.listchars:append("eol:↴") -- 改行文字
vim.opt.listchars:append("space:⋅") -- 空白文字

vim.opt.swapfile = false -- Swapファイルを生成するか
vim.opt.hidden = true -- バッファを保存しないでも切り替えれるように

-- vim.opt.pumblend = 10

vim.o.timeout = true -- キーのマッピングに対するタイムアウト
vim.o.timeoutlen = 1000 -- マッピングのタイムアウトの時間 (規定値: 1000)

vim.g.mapleader = " " -- リーダーをスペースに変更

-- Copilot
-- vim.g.copilot_filetypes = { markdown = true }
