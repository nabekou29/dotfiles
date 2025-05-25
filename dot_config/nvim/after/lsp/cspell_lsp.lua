--- @type vim.lsp.Config
return {
  cmd = { "cspell-lsp", "--stdio" },
  root_markers = { "cspell.json", ".git" },
}
