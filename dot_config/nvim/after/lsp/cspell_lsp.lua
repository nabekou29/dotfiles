--- @type vim.lsp.Config
return {
  cmd = { "cspell-lsp", "--stdio" },
  root_dir = function(bufnr, on_dir)
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
