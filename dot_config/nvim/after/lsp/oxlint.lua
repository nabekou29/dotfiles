--- @type vim.lsp.Config
return {
  cmd = { "pnpm", "oxlint", "--lsp" },
  filetypes = {
    "astro",
    "javascript",
    "javascriptreact",
    "svelte",
    "typescript",
    "typescriptreact",
    "vue",
  },
  settings = {
    options = {
      typeAware = true,
    },
  },
  root_markers = { ".git" },
}
