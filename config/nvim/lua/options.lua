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

vim.opt.wildmode = "full" -- タブ補完の挙動

vim.opt.swapfile = false -- Swapファイルを生成するか
vim.opt.hidden = true -- バッファを保存しないでも切り替えれるように

vim.opt.termguicolors = true
vim.opt.pumblend = 30 -- ポップアップメニューの透過度
vim.opt.winblend = 30 -- ウィンドウの透過度

vim.opt.timeout = true -- キーのマッピングに対するタイムアウト
vim.opt.timeoutlen = 1000 -- マッピングのタイムアウトの時間 (規定値: 1000)

vim.opt.updatetime = 300 -- インサートモードでの変更を検知する時間

vim.opt.autoread = true -- ファイルが変更されたら自動で読み込む
vim.cmd([[ au CursorHold * checktime ]])

vim.g.mapleader = " " -- リーダーをスペースに変更

-- undo 永続化
if vim.fn.has("persistent_undo") == 1 then
  vim.opt.undofile = true
  vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
end
