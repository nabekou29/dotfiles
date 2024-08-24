最初に実行した方が良いコマンド

- `TSInstall all`

# ローカルの設定方法

.nvim.lua に以下のように記述

```lua
_G.local_config = {
  lsp = {
    eslint = {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    },
  },
  plugins = {},
}
```
