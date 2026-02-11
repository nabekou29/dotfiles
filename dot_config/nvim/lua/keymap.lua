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
    vim.keymap.set({ "n", "x", "t" }, "<C-S-" .. k .. ">", function()
      move_nvim_win_or_wezterm_pane(k)
    end, { desc = "Move to " .. directions[k] .. " pane (Wezterm)" })
  end
elseif vim.fn.exists("$ZELLIJ") ~= 1 then
  set("n", "<C-S-h>", "<cmd>wincmd h<CR>", { desc = "Move to left window" })
  set("n", "<C-S-l>", "<cmd>wincmd l<CR>", { desc = "Move to right window" })
  set("n", "<C-S-j>", "<cmd>wincmd j<CR>", { desc = "Move to below window" })
  set("n", "<C-S-k>", "<cmd>wincmd k<CR>", { desc = "Move to above window" })
  -- $WEZTERM_PANE が設定されている場合はWeztermのPane移動を試す
end

-- Emacs
set({ "i", "v" }, "<C-a>", "<HOME>", { desc = "Move to beginning of line" })
set({ "i", "v" }, "<C-e>", "<END>", { desc = "Move to end of line" })
set("i", "<C-d>", "<Del>", { desc = "Delete character forward" })
set("i", "<C-h>", "<BS>", { desc = "Delete character backward" })

-- Y を行末までコピーに (C, D などの挙動に揃える)
set("n", "Y", "y$", { desc = "Yank to end of line" })
-- ペースト時にレジスタを上書きしない
set({ "x" }, "p", '"_dp', { desc = "Paste without overwriting register" })

-- 現在のカーソル位置で改行して、挿入モードに移行
set("n", "<C-CR>", "i<CR><Esc>kA", { desc = "Insert newline at cursor" })
set("i", "<C-CR>", "<CR><Esc>kA", { desc = "Insert newline at cursor" })

-- <,> を連続で使えるように
set("x", "<", "<gv", { desc = "Indent left and reselect" })
set("x", ">", ">gv", { desc = "Indent right and reselect" })

-- U で redo
set("n", "U", "<C-r>", { desc = "Redo" })

-- マクロは qq のみを使用
set("n", "q", function()
  return vim.fn.empty(vim.fn.reg_recording()) == 1 and "<Plug>(q)" or "q"
end, { expr = true, desc = "Record macro (q register)" })
set("n", "Q", function()
  return vim.fn.empty(vim.fn.reg_recording()) == 1 and "@q" or "q@q"
end, { expr = true, desc = "Play macro (q register)" })
set("n", "<Plug>(q)q", "qq", { noremap = true, desc = "Start recording macro to q" })

set("n", "<leader>.", "@:", { desc = "Repeat last command" })

-- 保存 (無名のファイルの場合は単にESC)
set({ "n", "i", "v" }, "<C-s>", "<cmd>if expand('%') != '' | write | endif<CR><ESC>", { desc = "Save and ESC" })
set({ "n", "i", "v" }, "<C-S-s>", "<cmd>if expand('%') != '' | write! | endif<CR><ESC>", { desc = "Save and ESC (Force)" })

-- *, # でカーソルの位置を保持
set("n", "*", [[*``]], { desc = "Search word forward (keep cursor)" })
set("n", "#", [[#``]], { desc = "Search word backward (keep cursor)" })

-- ハイライトがある場合は <ESC> でハイライトを消す
set("n", "<ESC>", function()
  if vim.v.hlsearch == 1 and vim.fn.searchcount().total > 0 then
    return "<CMD>nohlsearch<CR>"
  else
    return "<ESC>"
  end
end, { expr = true, desc = "Clear search highlight" })

set("n", "gn", "<Cmd>lua vim.lsp.buf.rename()<CR>", { desc = "LSP rename" })
set("n", "]g", "<Cmd>lua vim.diagnostic.jump({count = 1})<CR>", { desc = "Next diagnostic" })
set("n", "[g", "<Cmd>lua vim.diagnostic.jump({count = -1})<CR>", { desc = "Previous diagnostic" })
set("n", "gK", "<Cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostic float" })
set("i", "<c-l>", "<Cmd>lua vim.lsp.inline_completion.get()<cr>", { desc = "Trigger inline completion" })
set("i", "<M-n>", function()
  vim.lsp.inline_completion.select()
end, { desc = "Accept inline completion" })
set("i", "<M-p>", function()
  vim.lsp.inline_completion.select({ count = -1 * vim.v.count1 })
end, { desc = "Previous inline completion" })

-- quickfix
set("n", "]q", "<Cmd>cnext<CR>", { desc = "Next quickfix item" })
set("n", "[q", "<Cmd>cprev<CR>", { desc = "Previous quickfix item" })

-- markdown のみの設定
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- <Alt-Enter> で <br> を挿入
    vim.keymap.set("i", "<M-CR>", "<br>", { buffer = true, desc = "Insert <br>" })
  end,
})
