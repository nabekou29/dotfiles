# Figma フレーム作成ルール

## Auto Layout 設定

| CSS                    | Figma layoutMode |
| ---------------------- | ---------------- |
| flex-direction: column | VERTICAL         |
| flex-direction: row    | HORIZONTAL       |

### 重要: Auto Layout フレーム作成時の初期化

スタイルを設定する前に、必ず以下の値をリセットしてから設定すること:

```javascript
// フレーム作成時にデフォルト値をリセット
create_frame({
  name: "フレーム名",
  layoutMode: "VERTICAL",
  itemSpacing: 0,      // gap をリセット
  paddingTop: 0,       // padding をリセット
  paddingRight: 0,
  paddingBottom: 0,
  paddingLeft: 0
  // fillColor, strokeColor は指定しなければデフォルトで透明
})

// その後、必要なスタイルを設定
set_item_spacing({ nodeId: "ID", itemSpacing: 8 })  // 実際の gap
set_padding({ nodeId: "ID", paddingTop: 16, ... })  // 実際の padding
set_fill_color({ nodeId: "ID", r: 1, g: 1, b: 1 })  // 実際の fill
```

## Sizing ルール（fill 優先）

- 親が auto layout の子要素: `layoutSizingHorizontal: FILL`
- 高さは内容に応じる: `layoutSizingVertical: HUG`
- 固定サイズが必要な場合のみ: `FIXED`

**注意**: `create_frame` 時に FILL は設定できない。作成後に `set_layout_sizing` で設定。

## Margin の再現

CSS の margin は `margin-container` という名前のフレームで再現する。
margin-container は **margin をつける要素の親フレーム** として作成し、margin の値を padding として設定する。

**構造:**

```
margin-container (auto layout, HUG)
  └── 対象要素
```

**設定:**

- layoutMode: 親の方向に合わせる（VERTICAL or HORIZONTAL）
- layoutSizingHorizontal: FILL
- layoutSizingVertical: HUG
- padding: margin の値を設定

```javascript
// marginTop: 24px を再現する場合
create_frame({
  name: "margin-container",
  parentId: "親フレームID",
  layoutMode: "VERTICAL",
  paddingTop: 24  // marginTop の値を paddingTop として設定
})
set_layout_sizing({ layoutSizingHorizontal: "FILL", layoutSizingVertical: "HUG" })

// 対象要素を margin-container の子として作成
create_text({
  parentId: "margin-containerのID",
  text: "テキスト"
})
```

## テキスト要素

```javascript
create_text({
  text: "テキスト内容",
  fontSize: 15,
  fontWeight: 600,  // Semi Bold
  fontColor: { r: 0.122, g: 0.145, b: 0.149, a: 1 }
})
```

### テキスト折り返し

テキストの幅を制限して折り返しを有効化:

```javascript
resize_node({
  nodeId: "テキストノードID",
  width: 260,  // 親フレームの幅に合わせる
  height: 40   // 行数 × lineHeight
})
```

## 実装例

```javascript
// 1. コンテナ作成
create_frame({
  x: 0, y: 0, width: 312, height: 326,
  name: "Card",
  layoutMode: "VERTICAL",
  fillColor: { r: 1, g: 1, b: 1 },
  strokeColor: { r: 0.122, g: 0.145, b: 0.149, a: 0.1 },
  strokeWeight: 1
})
set_corner_radius({ nodeId: "ID", radius: 4 })

// 2. 画像プレースホルダー
create_frame({
  name: "ImagePlaceholder",
  parentId: "コンテナID",
  width: 312, height: 160,
  layoutMode: "HORIZONTAL",
  fillColor: { r: 0.91, g: 0.918, b: 0.918 }
})
set_layout_sizing({ nodeId: "ID", layoutSizingHorizontal: "FILL", layoutSizingVertical: "FIXED" })

// 3. Body フレーム（padding付き）
create_frame({
  name: "Body",
  parentId: "コンテナID",
  layoutMode: "VERTICAL",
  paddingTop: 16, paddingRight: 16, paddingBottom: 16, paddingLeft: 16
})
set_layout_sizing({ nodeId: "ID", layoutSizingHorizontal: "FILL", layoutSizingVertical: "HUG" })
```
