--- @type vim.lsp.Config
return {
  settings = {
    tailwindCSS = {
      classFunctions = {
        "cva",
        "cn",
      },
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { ".*[cC]lassName:\\s*[\"'`]([^\"'`]*)[\"'`]" },
        },
      },
    },
  },
}
