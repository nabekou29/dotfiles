vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  update_in_insert = true,
  virtual_text = {
    prefix = "", -- ドキュメント上は関数も可能となっていたがエラーになってしまったので format で対応
    suffix = "",
    format = function(diagnostic)
      local prefix = "?"
      if diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
        prefix = ""
      elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Warning then
        prefix = ""
      elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Information then
        prefix = ""
      elseif diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Hint then
        prefix = "🔧"
      end
      return string.format("%s %s [%s: %s]", prefix, diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
})
vim.fn.sign_define("DiagnosticSignWarn", {
  text = "",
  texthl = "DiagnosticSignWarn",
})
vim.fn.sign_define("DiagnosticSignError", {
  text = "",
  texthl = "DiagnosticSignError",
})
vim.fn.sign_define("DiagnosticSignInfo", {
  text = "",
  texthl = "DiagnosticSignInfo",
})
vim.fn.sign_define("DiagnosticSignHint", {
  text = "🔧",
  texthl = "DiagnosticSignHint",
})
