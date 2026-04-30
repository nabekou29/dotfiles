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

現在時刻は `date "+%Y-%m-%dT%H:%M:%S%z" | sed 's/\(..\)$/:\1/'` で取得できる。
