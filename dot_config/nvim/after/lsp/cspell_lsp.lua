--- @type vim.lsp.Config
local disabled_filetypes = { "toggleterm" }

return {
  cmd = { "cspell-lsp", "--stdio" },
  root_dir = function(bufnr, on_dir)
    -- 特定のfiletypeでは無効化
    local filetype = vim.bo[bufnr].filetype
    if vim.tbl_contains(disabled_filetypes, filetype) then
      return
    end
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    -- .disabled-cspell が存在する場合は LSP を無効化
    if vim.fs.find(".disabled-cspell", { path = bufname, upward = true })[1] then
      return
    end
    local root = vim.fs.root(bufnr, { "cspell.json", "cspell.yaml", ".git" })
    if root then
      on_dir(root)
    end
  end,
}
