# ワークフロー詳細

## 1. 準備

```
1. TalkToFigma チャンネルに参加: join_channel
2. Chrome で対象ページにナビゲート: navigate_page
3. 必要に応じてログイン: fill_form, click
```

## 2. 対象要素の特定

### A) セレクタが指定されている場合

指定されたセレクタを使用して要素を特定する。

### B) セレクタが指定されていない場合

1. ユーザーに DevTools で要素を選択するよう促す:
   ```
   Chrome DevTools の Elements パネルで、Figma に変換したい要素を選択してください。
   選択が完了したら「選択しました」とお知らせください。
   ```

2. ユーザーからの応答を待つ（AskUserQuestion ツールを使用）

3. `take_snapshot` で選択された要素を確認:
   - スナップショット結果に `[selected]` マークがある要素が選択中の要素
   - 選択された要素の uid を取得

4. `evaluate_script` で選択要素の情報を取得:
   ```javascript
   (el) => {
     return {
       tagName: el.tagName,
       className: el.className,
       id: el.id
     };
   }
   ```
   - args に `{ uid: "選択されたuid" }` を渡す

## 3. UI 情報の取得

[scripts/extract-ui.js](scripts/extract-ui.js) を `evaluate_script` で実行。

**重要**:
- セレクタで指定された要素のみから構造とスタイル情報を取得（親要素は取得しない）
- スクリプトは **Figma 形式に変換済みの値** を返す:
  - 色: `{ r: 0.122, g: 0.145, b: 0.149, a: 0.65 }` (0-1 範囲)
  - サイズ/パディング/マージン: 数値 (`20` など、px なし)
  - layoutMode: `"VERTICAL"` / `"HORIZONTAL"` / `"NONE"`
  - alignment: `"MIN"` / `"MAX"` / `"CENTER"` / `"SPACE_BETWEEN"`
- **取得した値をそのまま Figma API に渡せる**（変換不要）

## 4. Figma フレーム作成順序

1. 最外側のコンテナフレームを作成
2. `set_fill_color` で背景を透明にリセット（`a: 0`）
3. `set_corner_radius` で角丸設定
4. 子フレームを上から順に作成（`parentId` を指定）
5. 各フレームに `set_layout_sizing` を適用
6. テキスト要素を追加
7. **テキストノードは必ず `resize_node` で幅を設定**（折り返し有効化）
8. `set_focus` でフォーカス

## 5. スクリーンショット確認（必須・スキップ禁止）

**Figma 作成完了後、ユーザーへの報告前に必ずスクリーンショットを撮影して確認する。**

```javascript
// 必須: ルートフレームのスクリーンショットを撮影
export_node_as_image({
  nodeId: "ルートフレームID",
  format: "PNG",
  scale: 1
})
```

### チェック項目

| 項目 | 確認内容 |
|------|----------|
| テキスト | 途切れ・はみ出しがないか |
| レイアウト | 要素の並びが正しいか |
| 余白 | 意図しない padding/margin がないか |
| 背景色 | 透明であるべき箇所が白くないか |

### 問題があった場合

1. 問題箇所を特定
2. 修正（`resize_node`, `set_padding` など）
3. **再度スクリーンショットを撮影して確認**
4. 問題なければユーザーに報告
