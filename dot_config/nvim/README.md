## ローカルの設定方法

`.nvim.lua` に以下のように記述。[klen/nvim-config-local](https://github.com/klen/nvim-config-local) によって読み込まれる。

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
