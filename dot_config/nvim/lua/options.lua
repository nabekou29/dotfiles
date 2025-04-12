-- Option
vim.opt.clipboard = "unnamedplus"

vim.opt.number = true -- 行数表示
vim.opt.signcolumn = "yes" -- サインカラムを常に表示（ガタつき防止）
vim.opt.expandtab = true -- タブでスペースを入力
vim.opt.tabstop = 2 -- インデントのサイズ
vim.opt.shiftwidth = 2 -- インデントのサイズ

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.ignorecase = true -- 検索時に大文字小文字を区別しない
vim.opt.smartcase = true -- 大文字が含まれる場合は区別する

vim.opt.list = true
vim.opt.listchars:append("eol:↴") -- 改行文字
vim.opt.listchars:append("space:⋅") -- 空白文字

vim.opt.wildmode = "full" -- タブ補完の挙動

vim.opt.swapfile = false -- Swapファイルを生成するか
vim.opt.hidden = true -- バッファを保存しないでも切り替えれるように

vim.opt.termguicolors = true
vim.opt.pumblend = 15 -- ポップアップメニューの透過度
vim.opt.winblend = 15 -- ウィンドウの透過度
vim.opt.winborder = "rounded"

vim.opt.timeout = true -- キーのマッピングに対するタイムアウト
vim.opt.timeoutlen = 1000 -- マッピングのタイムアウトの時間 (規定値: 1000)

vim.opt.updatetime = 300 -- インサートモードでの変更を検知する時間

vim.opt.autoread = true -- ファイルが変更されたら自動で読み込む
vim.cmd([[ au CursorHold * checktime ]])

vim.g.mapleader = " " -- リーダーをスペースに変更

vim.opt.laststatus = 3 -- ステータスバーをウィンドウごとではなく、一番下に常に表示
vim.opt.cmdheight = 0 -- コマンド入力中以外はコマンドラインを非表示
vim.api.nvim_create_autocmd({ "CmdlineEnter", "RecordingEnter" }, { pattern = "*", command = "set cmdheight=1" })
-- vim.api.nvim_create_autocmd({ "CmdlineLeave", "RecordingLeave" }, { pattern = "*", command = "set cmdheight=0" })
vim.api.nvim_create_autocmd({ "ModeChanged" }, { pattern = "*:[ivV\x16]", command = "set cmdheight=0" })

vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup//" -- // をつけるとパス構造が保持される

vim.g.editorconfig = true

-- undo 永続化
if vim.fn.has("persistent_undo") == 1 then
  vim.opt.undofile = true
  vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
end

-- grep
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

vim.fn.sign_define("DiagnosticSignWarn", {
  text = "",
  texthl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DiagnosticSignError", {
  text = "",
  texthl = "DiagnosticSignError",
})
vim.fn.sign_define("DiagnosticSignInfo", {
  text = "󰋽",
  texthl = "DiagnosticSignInfo",
})
vim.fn.sign_define("DiagnosticSignHint", {
  text = "🔧",
  texthl = "DiagnosticSignHint",
})

vim.diagnostic.config({
  float = { border = "rounded" },
  virtual_text = true,
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  update_in_insert = false,
  virtual_text = {
    prefix = "", -- ドキュメント上は関数も可能となっていたがエラーになってしまったので format で対応
    suffix = "",
    format = function(diagnostic)
      local prefix = "?"
      if diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
        prefix = ""
      elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Warning then
        prefix = ""
      elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Information then
        prefix = "󰋽"
      elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Hint then
        prefix = "🔧"
      end
      return string.format("%s %s [%s: %s]", prefix, diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
})

-- Open Cheetsheet

vim.cmd([[
  command! Cheatsheet edit ~/.config/nvim/cheetsheet.md
]])
