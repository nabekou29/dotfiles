local set = vim.keymap.set
-- Key Binding (Pluginは除く)
set({ "i", "v" }, "<C-a>", "<HOME>", {})
set({ "i", "v" }, "<C-e>", "<END>", {})
set("n", "<C-S-h>", "<cmd>wincmd h<CR>", {})
set("n", "<C-S-l>", "<cmd>wincmd l<CR>", {})
set("n", "<C-S-j>", "<cmd>wincmd j<CR>", {})
set("n", "<C-S-k>", "<cmd>wincmd k<CR>", {})
set("n", "<C-h>", "<cmd>wincmd h<CR>", {})
set("n", "<C-l>", "<cmd>wincmd l<CR>", {})
set("n", "<C-j>", "<cmd>wincmd j<CR>", {})
set("n", "<C-k>", "<cmd>wincmd k<CR>", {})

set("n", "<C-S-M-h>", "<cmd>tabp<CR>", {})
set("n", "<C-S-M-l>", "<cmd>tabn<CR>", {})

-- set({ "n", "x" }, "d", '"_d', { desc = "Delete without yank", silent = true, noremap = true })
set({ "x" }, "p", '"_dP', { desc = "Paste without yank", silent = true, noremap = true })

-- 行の移動
set("n", "<M-S-j>", "<Cmd>move .+1<CR>==", { desc = "Move line Down" })
set("x", "<M-S-j>", ":move '>+1<CR>gv=gv", { desc = "Move line Down" })
set("i", "<M-S-j>", "<Esc><Cmd>move .+1<CR>==gi", { desc = "Move line Down" })
set("n", "<M-S-k>", "<Cmd>move .-2<CR>==", { desc = "Move line Up" })
set("x", "<M-S-k>", ":move '<-2<CR>gv=gv", { desc = "Move line Up" })
set("i", "<M-S-k>", "<Esc><Cmd>move .-2<CR>==gi", { desc = "Move line Up" })

-- Emacs
set("i", "<C-d>", "<Del>", { desc = "Delete" })
set("i", "<C-h>", "<BS>", { desc = "Backspace" })

-- 保存 (無名のファイルの場合は単にESC)
set({ "n", "i", "v" }, "<C-s>", "<cmd>if expand('%') != '' | write | endif<CR><ESC>", { desc = "Save and ESC" })

-- set("i", "jj", "<ESC>", { desc = "jj to ESC", silent = true, noremap = true })
-- set("i", "jk", "<ESC>", { desc = "jk to ESC", silent = true, noremap = true })

set("n", "*", [[*``]], { noremap = true, silent = true })
set("n", "#", [[#``]], { noremap = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(event)
    if event.file ~= "TelescopePrompt" then
      vim.api.nvim_buf_set_keymap(event.buf, "n", "<ESC><ESC>", ":nohlsearch<CR>", { silent = true, noremap = true })
    end
  end,
})

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
