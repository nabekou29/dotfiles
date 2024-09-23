local set = vim.keymap.set

-- Key Binding (Pluginは除く)
set("n", "<C-S-h>", "<cmd>wincmd h<CR>")
set("n", "<C-S-l>", "<cmd>wincmd l<CR>")
set("n", "<C-S-j>", "<cmd>wincmd j<CR>")
set("n", "<C-S-k>", "<cmd>wincmd k<CR>")

-- Emacs
set({ "i", "v" }, "<C-a>", "<HOME>")
set({ "i", "v" }, "<C-e>", "<END>")
set("i", "<C-d>", "<Del>")
set("i", "<C-h>", "<BS>")

-- Y を行末までコピーに (C, D などの挙動に揃える)
set("n", "Y", "y$")
-- ペースト時にレジスタを上書きしない
set({ "x" }, "p", '"_dp')

-- 行の移動
set("n", "<M-S-j>", ":move .+1<CR>==", { desc = "Move line Down" })
set("x", "<M-S-j>", ":move '>+1<CR>gv=gv", { desc = "Move line Down" })
set("i", "<M-S-j>", "<Esc><Cmd>move .+1<CR>==gi", { desc = "Move line Down" })
set("n", "<M-S-k>", ":move .-2<CR>==", { desc = "Move line Up" })
set("x", "<M-S-k>", ":move '<-2<CR>gv=gv", { desc = "Move line Up" })
set("i", "<M-S-k>", "<Esc><Cmd>move .-2<CR>==gi", { desc = "Move line Up" })

set({ "x", "o" }, "ii", 'i"')

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
    if event.file ~= "TelescopePrompt" then
      vim.api.nvim_buf_set_keymap(event.buf, "n", "<ESC><ESC>", "<CMD>nohlsearch<CR>", {})
    end
  end,
})

set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
set("n", "gn", "<Cmd>lua vim.lsp.buf.rename()<CR>")
-- set("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>") -- → Telescope
-- set("n", "ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>") -- → actions-preview.nvim
set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
set({ "n", "i" }, "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
set("n", "]g", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
set("n", "[g", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")

-- Clipboard
set("n", "<leader>cp", function()
  local path = vim.fn.expand("%:.")
  vim.api.nvim_out_write("Copied: " .. path .. "\n")
  vim.fn.setreg("+", path)
end, {
  desc = "Copy Relative Path",
})
set("n", "<leader>cP", function()
  local path = vim.fn.expand("%:p")
  vim.api.nvim_out_write("Copied: " .. path .. "\n")
  vim.fn.setreg("+", path)
end, {
  desc = "Copy Full Path",
})
set("n", "<leader>cf", function()
  local path = vim.fn.expand("%:t")
  vim.api.nvim_out_write("Copied: " .. path .. "\n")
  vim.fn.setreg("+", path)
end, {
  desc = "Copy File Name",
})
set("n", "<leader>cgl", function()
  -- 現在の行のリンクをコピー
  local file = vim.fn.expand("%:.")
  local line = vim.fn.line(".")
  local url = vim.fn.system("gh browse -n '" .. file .. ":" .. line .. "'")
  vim.api.nvim_out_write("Copied: " .. url)
  vim.fn.setreg("+", url)
end, {
  desc = "Copy Link to Line (Github)",
})
set("n", "<leader>cgh", function()
  -- 現在のファイルのリンクをコピー
  local file = vim.fn.expand("%:.")
  local url = vim.fn.system("gh browse -n '" .. file .. "'")
  vim.api.nvim_out_write("Copied: " .. url)
  vim.fn.setreg("+", url)
end, {
  desc = "Copy Link to File (Github)",
})
