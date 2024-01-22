vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = false,
    virtual_text = {
        format = function(diagnostic)
            return string.format("%s [%s: %s]", diagnostic.message, diagnostic.source, diagnostic.code)
        end
    }
})
vim.fn.sign_define("DiagnosticSignWarn", {
    text = "",
    texthl = "DiagnosticSignWarn"
})
vim.fn.sign_define("DiagnosticSignError", {
    text = "",
    texthl = "DiagnosticSignError"
})
vim.fn.sign_define("DiagnosticSignInfo", {
    text = "",
    texthl = "DiagnosticSignInfo"
})
vim.fn.sign_define("DiagnosticSignHint", {
    text = "🔧",
    texthl = "DiagnosticSignHint"
})
