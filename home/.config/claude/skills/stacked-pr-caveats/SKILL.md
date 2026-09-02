---
name: stacked-pr-caveats
description: gh stack でスタックした PR を扱うときに使う。公式の gh-stack skill が扱わない GitHub 側の制約（署名コミット必須リポジトリ・マージキュー・スタック途中の PR のクローズ・fork 跨ぎ・マージの前提条件）と、submit 後の PR タイトル/本文の扱いを補う。スタックの submit・rebase・マージで詰まったとき、スタックの構成を変えたいときにも参照する。
---

# スタック PR の落とし穴と規約

`gh stack` の使い方そのものは **`gh-stack` skill（GitHub 公式、`gh skill` で導入）が正**。
ここには公式 skill に載っていない GitHub 側の制約と、自分の PR 規約との接続だけを書く。

## GitHub 側の制約

出典は GitHub Docs の stacked pull requests（Reference / Troubleshooting / Managing）。

| 状況 | 制約 | 対処 |
| ---- | ---- | ---- |
| 署名コミットが必須のリポジトリ | PR 画面の "Rebase stack" などサーバー側で走る rebase が作るコミットは**署名されない** | サーバー側で rebase せず、ローカルで `gh stack rebase` → `gh stack push`。ローカルの署名設定が効く |
| ベースブランチがマージキューを使う | キューから外された PR があると、**その上の PR も全て外される** | 原因を直してからスタックごと入れ直す。キューはスタックをまとめるためグループ上限を最大 50% 超過するが、大きいスタックは連続する複数のマージグループに分かれることがある |
| スタック途中の PR をクローズした | その**上の PR が全てマージ不能になる** | unstack して組み直す。unstack が外すのは open / draft / closed の PR だけで、マージ済み・キュー投入済みの PR は残る |
| fork からスタックしたい | **未対応**。全ブランチが同一リポジトリにある必要がある | fork ではなくリポジトリ内のブランチで進める |
| マージ条件を満たさない | スタックが linear history でないとマージできない。下位ブランチへの push や trunk の前進で崩れる | `gh stack rebase` → `gh stack push` |

- ブランチ保護・必須レビュー・必須ステータスチェック・CODEOWNERS は**スタックのベース**に対して評価される。
- スタック PR は public preview。挙動は変わりうるので、フラグと引数は `gh stack <command> --help` を正とする。GitHub Desktop は非対応。

## 自分の規約との接続

- `gh stack submit --auto` が付ける PR タイトル・本文は自動生成（単一コミットならその subject と body、複数コミットなら branch 名を humanize しただけ）。**そのままにしない** — `gh pr edit` で `default-pr` skill と同じ方針（PR テンプレートがあれば従い、無ければ Summary / Test plan）に直す。
- 各層のコミットメッセージは `default-commit` skill の判断に従う（リポジトリ既存の形式・言語に合わせる）。
