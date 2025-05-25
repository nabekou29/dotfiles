--- @type vim.lsp.Config
return {
  init_options = {
    tsserver = {
      path = vim.fn.exepath("tsserver"),
    },
  },
  root_dir = function(bufnr, on_dir)
    -- deno 関連のファイルがある場合は、ts_ls を起動しない
    local deno_files = {
      "deno.json",
      "deno.jsonc",
    }
    local deno_root = vim.fs.root(bufnr, deno_files)
    if deno_root ~= nil then
      return
    end

    local root = vim.fs.root(bufnr, {
      "tsconfig.json",
      "jsconfig.json",
      "package.json",
      ".git",
    })
    if root then
      on_dir(root)
    end
  end,
  on_attach = function(client, bufnr)
    require("twoslash-queries").attach(client, bufnr)
  end,
}
