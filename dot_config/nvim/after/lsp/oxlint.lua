--- @type vim.lsp.Config
return {
  cmd = { "oxlint", "--lsp" },
  filetypes = {
    "astro",
    "javascript",
    "javascriptreact",
    "svelte",
    "typescript",
    "typescriptreact",
    "vue",
  },
}
