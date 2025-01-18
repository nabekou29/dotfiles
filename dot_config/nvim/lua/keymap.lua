-- Key Binding (Pluginは除く)
local set = vim.keymap.set

if vim.fn.exists("$ZELLIJ") ~= 1 then
  set("n", "<C-h>", "<cmd>wincmd h<CR>")
  set("n", "<C-l>", "<cmd>wincmd l<CR>")
  set("n", "<C-j>", "<cmd>wincmd j<CR>")
  set("n", "<C-k>", "<cmd>wincmd k<CR>")
end

-- Emacs
set({ "i", "v" }, "<C-a>", "<HOME>")
set({ "i", "v" }, "<C-e>", "<END>")
set("i", "<C-d>", "<Del>")
set("i", "<C-h>", "<BS>")

-- Y を行末までコピーに (C, D などの挙動に揃える)
set("n", "Y", "y$")
-- ペースト時にレジスタを上書きしない
set({ "x" }, "p", '"_dp')

-- 現在のカーソル位置で改行して、挿入モードに移行
set("n", "<C-CR>", "i<CR><Esc>kA")
set("i", "<C-CR>", "<CR><Esc>kA")

-- 行の移動
set("n", "<M-n>", ":move .+1<CR>==", { desc = "Move line Down" })
set("x", "<M-n>", ":move '>+1<CR>gv=gv", { desc = "Move line Down" })
set("i", "<M-n>", "<Esc><Cmd>move .+1<CR>==gi", { desc = "Move line Down" })
set("n", "<M-p>", ":move .-2<CR>==", { desc = "Move line Up" })
set("x", "<M-p>", ":move '<-2<CR>gv=gv", { desc = "Move line Up" })
set("i", "<M-p>", "<Esc><Cmd>move .-2<CR>==gi", { desc = "Move line Up" })

-- <,> を連続で使えるように
set("x", "<", "<gv")
set("x", ">", ">gv")

-- U で redo
set("n", "U", "<C-r>")

-- マクロは qq のみを使用
set("n", "q", function()
  return vim.fn.empty(vim.fn.reg_recording()) == 1 and "<Plug>(q)" or "q"
end, { expr = true })
set("n", "Q", function()
  return vim.fn.empty(vim.fn.reg_recording()) == 1 and "@q" or "q@q"
end, { expr = true })
set("n", "<Plug>(q)q", "qq", { noremap = true })

set("n", "<leader>.", "@:")

-- 保存 (無名のファイルの場合は単にESC)
set({ "n", "i", "v" }, "<C-s>", "<cmd>if expand('%') != '' | write | endif<CR><ESC>", { desc = "Save and ESC" })

-- *, # でカーソルの位置を保持
set("n", "*", [[*``]])
set("n", "#", [[#``]])

-- <ESC><ESC> でハイライトを消す
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(event)
    if event.file ~= "TelescopePrompt" and event.file ~= "DressingInput" then
      vim.api.nvim_buf_set_keymap(event.buf, "n", "<ESC><ESC>", "<CMD>nohlsearch<CR>", {})
    end
  end,
})

set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
set("n", "gn", "<Cmd>lua vim.lsp.buf.rename()<CR>")
-- set("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>") -- → Telescope
set("n", "ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>") -- → actions-preview.nvim
set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
set({ "n", "i" }, "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
set("n", "]g", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
set("n", "[g", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")

-- quickfix
set("n", "]c", "<Cmd>cnext<CR>")
set("n", "[c", "<Cmd>cprev<CR>")
