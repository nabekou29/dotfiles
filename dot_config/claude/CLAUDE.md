# CORE PRINCIPLES

- Follow Kent Beck's Test-Driven Development methodology (`tdd` skill) as the preferred approach for all development work.
- Document at the right layer: Code → How, Tests → What, Commits → Why, Comments → Why not

## プロジェクト横断のメモ・WIP

後で参照する価値がある作業計画・調査メモ・仕様草案は、思考のパートナー
リポジトリ `~/ghq/github.com/nabekou29/assistant/` に集約する。
詳細な置き場所の判断は `assistant-bridge` skill を参照。

- プロジェクトに紐づく → `assistant/1-projects/<project>/`
- プロジェクトに紐づかない → `assistant/items/YYYY/MM/YYYY-MM-DD/{plan|scratch|research}-HH-mm-ss-<desc>.md`
- 本当に使い捨ての一時ファイル(デバッグ中のスクリプト等)のみ、
  リポジトリの `.claude/tmp/`(gitignore)に置いてよい

### ローカル資料の内部参照を共有成果物に漏らさない

`assistant` リポジトリや手元の markdown など、**共有されないローカル資料に
しか存在しない参照**（セクションID・採番・メモのファイル名やパスなど）を、
**共有される成果物に絶対に含めない**。

- 対象成果物: コードコメント、テストケース名・テスト本文、PR の説明文、
  コミットメッセージ、Issue やドキュメントなど他者の目に触れるもの全て。
- 理由: これらの参照は他者から辿れず、ローカル資料の存在や構造を
  漏らすだけで読み手には無意味。
- 代わりに: 参照IDをそのまま貼らず、**意図や根拠を自分の言葉で
  自己完結するように書く**。背景を残したい場合も内容そのものを記述する。

## 現在時刻の取得方法

現在時刻は `date "+%Y-%m-%dT%H:%M:%S%z" | sed 's/\(..\)$/:\1/'` で取得できる。
