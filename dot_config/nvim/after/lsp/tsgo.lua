--- @type vim.lsp.Config
return {
  -- lspconfig のデフォルトはグローバルの `tsgo` バイナリを探すが、
  -- stable の typescript 7 は LSP 内蔵の `tsc` しか同梱しないため cmd を差し替える。
  -- ワークスペースに tsgo (@typescript/native-preview) があればそれを優先し、
  -- なければ mise の typescript 7 (tsc --lsp) を使う。
  cmd = function(dispatchers, config)
    local root = (config or {}).root_dir
    if root then
      local ws_tsgo = vim.fs.joinpath(root, "node_modules/.bin/tsgo")
      if vim.fn.executable(ws_tsgo) == 1 then
        return vim.lsp.rpc.start({ ws_tsgo, "--lsp", "--stdio" }, dispatchers)
      end
    end
    return vim.lsp.rpc.start({ "tsc", "--lsp", "--stdio" }, dispatchers)
  end,
}
