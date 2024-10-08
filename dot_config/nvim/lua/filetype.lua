vim.filetype.add({
  -- フルパスを使って判定するので、`pattern`キー内に記述
  pattern = {
    -- フルパスはlua-patternという正規表現っぽいものでマッチでき、環境変数も使える
    ["${HOME}/.local/share/chezmoi/.*"] = {
      -- テーブルの第一要素はフルパスなどを受け取ってファイルタイプを返す関数
      function(
        path, -- フルパス
        buf -- buffer number
      )
        -- パスに`/dot_`を含む場合、パスを改変して再判定させる
        if path:match("/dot_") then
          return vim.filetype.match({
            filename = path:gsub("/dot_", "/."),
            buf = buf,
          })
        end
      end,
      -- テーブルの第二要素でpriorityを最低にしておくと、フォールバック相当になる
      { priority = -math.huge },
    },
  },
})
