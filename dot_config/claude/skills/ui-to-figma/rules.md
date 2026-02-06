# Figma フレーム作成ルール

## フレーム命名規則

### ページ構造（ルートレベル）

```
Header, Sidebar, Main, Aside, Footer
```

### セクション構造（機能名 + 構造名）

```
PostHeader, PostBody, PostFooter, PostActions
CardHeader, CardBody, CardFooter
```

- ルートレベル以外は親要素名をプレフィックスに付ける
- `Body` に統一（`Content` は使わない）

### リスト構造（HogeList パターン）

```
MemberList > MemberListItem
PostList > PostListItem
```

### テーブル構造

```
Table > TableHeader / TableBody > TableRow > TableCell
MemberTable > MemberTableHeader / MemberTableBody > ...
```

### グループ（複数形）

単純なグループのみ複数形を使用:

```
Buttons, Icons, Avatars, Tags
```

### Margin Container

margin の再現には `MC_` プレフィックスを使用:

```
MC_Title, MC_BodyText, MC_Footer
```

### 避けるべきパターン

| NG | 理由 | 代替案 |
|----|------|--------|
| `Container` (単独) | 何を含むか不明 | `MemberContainer` や具体的な名前 |
| `Right`, `Left`, `Top`, `Bottom` | 位置依存でレイアウト変更に弱い | `Aside`, `SubColumn`, `InfoPanel` |
| `Content` / `Body` 混在 | 一貫性がない | `Body` に統一 |
| `Wrapper`, `Box`, `Item` (単独) | 曖昧 | 具体的な名前を付ける |
| `Btn`, `Hdr`, `Txt` など略語 | 可読性が低い | `Button`, `Header`, `Text` |
| `Header1`, `Button2` など連番 | 意味が不明 | 役割名を付ける |
| `BlueButton`, `LargeText` | スタイル依存 | `PrimaryButton`, `Title` など役割名 |
| `Header > Header` (同名ネスト) | 混乱する | 親名をプレフィックスに |

**例外**: `Container` や位置名はどうしても必要な場合は使用可

---

## 重要: スクリプト出力値をそのまま使う

`extract-ui.js` の出力は **Figma 形式に変換済み**。取得した値をそのまま使用する:

```javascript
// スクリプトの出力例
{
  styles: {
    backgroundColor: { r: 0.122, g: 0.145, b: 0.149 },  // そのまま fillColor に使用
    color: { r: 0.122, g: 0.145, b: 0.149, a: 0.65 },   // そのまま fontColor に使用
    fontSize: 15,           // そのまま fontSize に使用
    fontWeight: 600,        // そのまま fontWeight に使用
    layoutMode: "VERTICAL", // そのまま layoutMode に使用
    paddingTop: 20,         // そのまま paddingTop に使用
    gap: 8,                 // そのまま itemSpacing に使用
    // ...
  }
}

// Figma API への適用
create_frame({
  fillColor: styles.backgroundColor,  // 変換不要
  layoutMode: styles.layoutMode,      // 変換不要
  paddingTop: styles.paddingTop,      // 変換不要
  itemSpacing: styles.gap,            // gap → itemSpacing
})

create_text({
  fontSize: styles.fontSize,          // 変換不要
  fontWeight: styles.fontWeight,      // 変換不要
  fontColor: styles.color,            // 変換不要
})
```

## Auto Layout 設定

| CSS                    | Figma layoutMode |
| ---------------------- | ---------------- |
| flex-direction: column | VERTICAL         |
| flex-direction: row    | HORIZONTAL       |

### 重要: フレーム作成時の初期化（リセット徹底）

**フレーム作成時は必ず以下をリセットすること:**
- すべての padding と itemSpacing を 0 に（Figma はデフォルトで padding: 10 などが入るため）
- **背景色**: `noFill: true` を指定して透明にする（fillColor を省略すると白になる）

```javascript
// フレーム作成時にすべてリセット（必須）
create_frame({
  name: "フレーム名",
  x: 0, y: 0,
  width: 312, height: 100,
  layoutMode: "VERTICAL",
  noFill: true,  // 背景を透明に（set_fill_color 不要）
  // 必ず 0 を指定してリセット
  itemSpacing: 0,
  paddingTop: 0,
  paddingRight: 0,
  paddingBottom: 0,
  paddingLeft: 0
})

// 作成直後に sizing を設定（必須）
set_layout_sizing({ nodeId: "ID", layoutSizingHorizontal: "FILL", layoutSizingVertical: "HUG" })

// 必要なスタイルがあれば追加で設定
set_item_spacing({ nodeId: "ID", itemSpacing: 8 })  // 実際の gap がある場合のみ
set_padding({ nodeId: "ID", paddingTop: 16, ... })  // 実際の padding がある場合のみ
```

**背景色が必要な場合は `fillColor` を指定**（`noFill` は省略）:

```javascript
create_frame({
  name: "Card",
  layoutMode: "VERTICAL",
  fillColor: { r: 1, g: 1, b: 1 },  // 白背景
  // ...
})
```

**NG パターン（デフォルト値が残る）:**

```javascript
// ❌ padding を省略すると意図しない値が入る可能性
create_frame({
  name: "フレーム名",
  layoutMode: "VERTICAL"
})
```

## Sizing ルール（FILL/HUG がデフォルト）

**基本方針: 横幅は FILL、縦幅は HUG をデフォルトとする。**

これにより：
- 横幅が親に追従し、レスポンシブになる
- 縦幅がコンテンツに応じて自動調整され、テキストがはみ出さない

| 要素タイプ | layoutSizingHorizontal | layoutSizingVertical |
| ---------- | ---------------------- | -------------------- |
| 通常のフレーム | FILL | HUG |
| 画像（create_image_rectangle） | FILL | FIXED |
| 固定幅が必要な場合 | FIXED | HUG |
| **折り返しテキスト（複数行）** | **FILL** | HUG |
| 単一行テキスト（タイトル等） | HUG | HUG |

**必須**: `create_frame` / `create_text` 直後に `set_layout_sizing` を呼ぶこと。

```javascript
// フレーム作成直後に必ず sizing を設定
create_frame({ ... })
set_layout_sizing({
  nodeId: "ID",
  layoutSizingHorizontal: "FILL",  // 横幅は FILL（デフォルト）
  layoutSizingVertical: "HUG"      // 縦幅は HUG（デフォルト）
})

// テキスト作成直後も sizing を設定（折り返しが必要な場合）
create_text({ name: "Description", ... })
set_layout_sizing({
  nodeId: "DescriptionのID",
  layoutSizingHorizontal: "FILL",  // 親幅に合わせて折り返し
  layoutSizingVertical: "HUG"
})

## Margin の再現

CSS の margin は `MC_<要素名>` という命名規則のフレームで再現する。
MC (Margin Container) は **margin をつける要素の親フレーム** として作成し、margin の値を padding として設定する。

**命名規則:**
- 囲う要素が `Title` → `MC_Title`
- 囲う要素が `BodyText` → `MC_BodyText`
- 囲う要素が `Footer` → `MC_Footer`

**構造:**

```
MC_Title (auto layout, HUG)
  └── Title
```

**設定:**

- layoutMode: 親の方向に合わせる（VERTICAL or HORIZONTAL）
- layoutSizingHorizontal: FILL
- layoutSizingVertical: HUG
- padding: margin の値を設定

```javascript
// Title に marginTop: 24px を再現する場合
create_frame({
  name: "MC_Title",
  parentId: "親フレームID",
  layoutMode: "VERTICAL",
  paddingTop: 24  // marginTop の値を paddingTop として設定
})
set_layout_sizing({ layoutSizingHorizontal: "FILL", layoutSizingVertical: "HUG" })

// Title を MC_Title の子として作成
create_text({
  name: "Title",
  parentId: "MC_TitleのID",
  text: "テキスト"
})
```

## 画像要素

### img タグの変換

Web の `<img>` タグは `create_image_rectangle` で再現する:

- `src` 属性 → `imageUrl` パラメータ
- 要素の幅・高さ → `width`, `height`
- `object-fit` → `scaleMode`（マッピング表参照）

```javascript
// extract-ui.js の出力を使用
create_image_rectangle({
  name: "ProductImage",
  parentId: "親ID",
  x: 0, y: 0,
  width: info.actualWidth,
  height: info.actualHeight,
  imageUrl: info.imgSrc,
  scaleMode: "FILL"  // object-fit に応じて変更
})
set_layout_sizing({ nodeId: "ID", layoutSizingHorizontal: "FILL", layoutSizingVertical: "FIXED" })
```

### 既存ノードへの画像設定

フレームや矩形に後から画像を設定する場合は `set_image_fill` を使用:

```javascript
set_image_fill({
  nodeId: "フレームID",
  imageUrl: "https://example.com/image.png",
  scaleMode: "FILL"
})
```

### object-fit → scaleMode マッピング

| CSS object-fit | Figma scaleMode |
|----------------|-----------------|
| cover          | FILL            |
| contain        | FIT             |
| fill           | FILL            |
| none           | CROP            |

## テキスト要素

### 重要: テキスト作成時は必ず resize_node で幅を設定

**テキストノードは `set_layout_sizing` に対応していない。**

折り返しを有効にするには `create_text` 直後に `resize_node` で幅を設定する。

```javascript
// ✅ 必須: create_text 直後に resize_node で幅を設定
create_text({
  name: "Title",
  parentId: "親ID",
  text: "複数行になる可能性のあるテキスト...",
  fontSize: 24,
  fontWeight: 600
})
resize_node({
  nodeId: "作成されたID",
  width: 632,   // 親の内側幅（親幅 - padding左右）
  height: 70    // 推定行数 × lineHeight
})
```

### 幅の計算

```
テキスト幅 = 親フレーム幅 - paddingLeft - paddingRight
```

### 高さの目安

| タイプ | fontSize | height 目安 |
|--------|----------|-------------|
| 見出し（2行） | 24 | 70 |
| 見出し（1行） | 20 | 30 |
| 本文（3行） | 15 | 80 |
| 本文（2行） | 15 | 52 |
| ラベル | 13-14 | 25 |

### NG パターン

```javascript
// ❌ resize_node なし → 折り返されず途切れる
create_text({ text: "長いテキスト..." })

// ❌ set_layout_sizing はテキストに使えない
set_layout_sizing({ nodeId: "TextID", layoutSizingHorizontal: "FILL" })
// → Error: "Node type TEXT does not support layout sizing"
```

## 実装例

```javascript
// 1. コンテナ作成（すべての padding/itemSpacing を 0 でリセット）
create_frame({
  x: 0, y: 0, width: 312, height: 326,
  name: "Card",
  layoutMode: "VERTICAL",
  itemSpacing: 0,
  paddingTop: 0,
  paddingRight: 0,
  paddingBottom: 0,
  paddingLeft: 0,
  fillColor: { r: 1, g: 1, b: 1 },
  strokeColor: { r: 0.122, g: 0.145, b: 0.149, a: 0.1 },
  strokeWeight: 1
})
set_corner_radius({ nodeId: "ID", radius: 4 })

// 2. 画像（FILL/FIXED）
create_image_rectangle({
  name: "CardImage",
  parentId: "コンテナID",
  x: 0, y: 0, width: 312, height: 160,
  imageUrl: imgSrc,  // extract-ui.js から取得した src
  scaleMode: "FILL"
})
set_layout_sizing({ nodeId: "ID", layoutSizingHorizontal: "FILL", layoutSizingVertical: "FIXED" })

// 3. Body フレーム（FILL/HUG、必要な padding のみ設定）
create_frame({
  name: "Body",
  parentId: "コンテナID",
  x: 0, y: 0, width: 312, height: 100,
  layoutMode: "VERTICAL",
  noFill: true,
  itemSpacing: 0,
  paddingTop: 16,
  paddingRight: 16,
  paddingBottom: 16,
  paddingLeft: 16
})
set_layout_sizing({ nodeId: "ID", layoutSizingHorizontal: "FILL", layoutSizingVertical: "HUG" })

// 4. テキストコンテナ（FILL/HUG）
create_frame({
  name: "TextContainer",
  parentId: "BodyのID",
  x: 0, y: 0, width: 280, height: 50,
  layoutMode: "VERTICAL",
  noFill: true,
  itemSpacing: 8,  // 実際の gap
  paddingTop: 0,
  paddingRight: 0,
  paddingBottom: 0,
  paddingLeft: 0
})
set_layout_sizing({ nodeId: "ID", layoutSizingHorizontal: "FILL", layoutSizingVertical: "HUG" })
```
