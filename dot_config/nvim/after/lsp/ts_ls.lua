--- @type vim.lsp.Config
return {
  init_options = {
    tsserver = {
      -- mise の shim (exepath が返すパス) は typescript パッケージ外の実行ファイルで、
      -- そこからは typescript ライブラリを解決できないため、mise のインストール実体から
      -- tsserver.js のあるディレクトリを引く (レイアウトは mise のバージョンで2種類ある)。
      -- global が typescript 7 (tsserver 非同梱) の場合は nil のままにして、
      -- ワークスペースの node_modules/typescript を LSP 自身に解決させる
      path = (function()
        local mise_ts = vim.fn.systemlist({ "mise", "where", "npm:typescript" })[1]
        if vim.v.shell_error == 0 and mise_ts and mise_ts ~= "" then
          for _, rel in ipairs({
            "/node_modules/typescript/lib",
            "/lib/node_modules/typescript/lib",
          }) do
            if vim.uv.fs_stat(mise_ts .. rel .. "/tsserver.js") then
              return mise_ts .. rel
            end
          end
        end
        local bin = vim.fn.exepath("tsserver")
        return bin ~= "" and bin or nil
      end)(),
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

    vim.api.nvim_create_user_command("OrganizeImports", function()
      local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
      }
      vim.lsp.buf.execute_command(params)
    end, {})
  end,
}
