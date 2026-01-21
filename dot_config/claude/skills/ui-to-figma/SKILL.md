---
name: ui-to-figma
description: |
  Web UI を Figma デザインデータに変換する。

  使用タイミング:
  - 「UIをFigmaに変換」「FigmaでUIを再現」「WebページをFigmaデータ化」
  - URL とセレクタを指定して Figma コンポーネントを作成
  - 既存 UI を Figma デザインシステムに取り込む

  必要な MCP: chrome-devtools, TalkToFigma
---

# UI to Figma Converter

Web UI を Figma デザインデータに変換する。

## 前提条件

- chrome-devtools MCP サーバーが接続済み
- TalkToFigma MCP サーバーが接続済み
- Figma デスクトップアプリで TalkToFigma プラグインが起動済み

## 重要: 変換範囲

**選択/指定された要素の内側のみを Figma に作成する。外側のデザインは絶対に作成しない。**

### セレクタで指定された場合

- セレクタが指す要素自体をルートフレームとして作成
- セレクタの親要素は含めない

### DevTools で要素を選択した場合

- 選択された要素自体をルートフレームとして作成
- 選択された要素の親や兄弟要素は含めない

例:
- ✅ 選択したコンテンツ部分とその子要素を変換
- ❌ モーダルの外枠、オーバーレイ、ページ全体のナビゲーションは変換しない

## ワークフロー概要

1. **準備**: TalkToFigma チャンネル接続 → Chrome でページナビゲート → ログイン
2. **要素特定**: セレクタ指定 or DevTools で選択
3. **UI 情報取得**: evaluate_script でスタイル取得
4. **Figma 作成**: フレーム階層を作成

詳細は以下を参照:
- [ワークフロー詳細](workflow.md)
- [Figma フレーム作成ルール](rules.md)
- [リファレンス（色変換・マッピング表）](reference.md)
- [スクリプト](scripts/)

## クイックスタート

### 1. 準備

```
join_channel({ channel: "チャンネル名" })
navigate_page({ url: "対象URL" })
fill_form / click でログイン（必要な場合）
```

### 2. UI 情報取得

[scripts/extract-ui.js](scripts/extract-ui.js) を evaluate_script で実行。

### 3. Figma フレーム作成

```javascript
// コンテナ作成
create_frame({
  name: "ComponentName",
  layoutMode: "VERTICAL",
  fillColor: { r: 1, g: 1, b: 1 },
  // ...
})

// 子要素を追加
set_layout_sizing({ layoutSizingHorizontal: "FILL" })
```

## チェックリスト

- [ ] TalkToFigma チャンネル接続確認
- [ ] 対象ページへのアクセス
- [ ] **選択範囲の確認（外側は作らない）**
- [ ] コンテナから子要素まで階層的にフレーム作成
- [ ] 全フレームに適切な layoutSizing 設定
- [ ] 完成後 set_focus で確認
