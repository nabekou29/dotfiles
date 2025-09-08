-- Key Binding (Pluginは除く)
local set = vim.keymap.set

if vim.g.vscode then
  return
end

if vim.fn.exists("$WEZTERM_PANE") == 1 then
  local directions = { h = "Left", j = "Down", k = "Up", l = "Right" }

  local move_nvim_win_or_wezterm_pane = function(hjkl)
    -- 現在のウィンドウIDを取得
    local oldwin = vim.api.nvim_get_current_win()

    -- ウィンドウ移動を試す
    vim.cmd.wincmd(hjkl)
    -- 現在ウィンドウに変化がなければWeztermのPane移動を試す
    if oldwin == vim.api.nvim_get_current_win() then
      require("wezterm").switch_pane.direction(directions[hjkl])
    end
  end

  for k, _ in pairs(directions) do
    vim.keymap.set("n", "<C-S-" .. k .. ">", function()
      move_nvim_win_or_wezterm_pane(k)
    end)
  end
elseif vim.fn.exists("$ZELLIJ") ~= 1 then
  set("n", "<C-S-h>", "<cmd>wincmd h<CR>")
  set("n", "<C-S-l>", "<cmd>wincmd l<CR>")
  set("n", "<C-S-j>", "<cmd>wincmd j<CR>")
  set("n", "<C-S-k>", "<cmd>wincmd k<CR>")
  -- $WEZTERM_PANE が設定されている場合はWeztermのPane移動を試す
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
-- set("n", "ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>") -- → actions-preview.nvim
set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
-- set({ "n", "i" }, "<C-S-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
set("n", "]g", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
set("n", "[g", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")
set("i", "<c-l>", "<Cmd>lua vim.lsp.inline_completion.get()<cr>")
set("i", "<M-n>", function()
  vim.lsp.inline_completion.select()
end)
set("i", "<M-p>", function()
  vim.lsp.inline_completion.select({ count = -1 * vim.v.count1 })
end)

-- quickfix
set("n", "]q", "<Cmd>cnext<CR>")
set("n", "[q", "<Cmd>cprev<CR>")

-- markdown のみの設定
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- <Alt-Enter> で <br> を挿入
    vim.keymap.set("i", "<M-CR>", "<br>", { buffer = true, desc = "Insert <br>" })
  end,
})
