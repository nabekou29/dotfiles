--- @type vim.lsp.Config
return {
  cmd = { "version-lsp" },
  filetypes = { "json", "jsonc", "toml", "gomod", "yaml" },
  root_markers = { ".git" },
  settings = {
    ["version-lsp"] = {
      -- See 'Configuration Options' section below for details
    },
  },
}
