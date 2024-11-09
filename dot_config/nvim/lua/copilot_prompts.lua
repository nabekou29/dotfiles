return {
  Explain = {
    prompt = "/COPILOT_EXPLAIN アクティブな選択範囲の説明を段落形式で書いてください。日本語で返答ください。",
  },
  Review = {
    prompt = "/COPILOT_REVIEW 選択されたコードをレビューしてください。日本語で返答ください。",
  },
  FixCode = {
    prompt = "/COPILOT_GENERATE このコードには問題があります。バグを修正したコードに書き直してください。日本語で返答ください。",
  },
  Refactor = {
    prompt = "/COPILOT_GENERATE 明瞭性と可読性を向上させるために、次のコードをリファクタリングしてください。日本語で返答ください。",
  },
  BetterNamings = {
    prompt = "/COPILOT_GENERATE 選択されたコードの変数名や関数名を改善してください。日本語で返答ください。",
  },
  Documentation = {
    prompt = "/COPILOT_GENERATE 選択範囲にドキュメントコメントを追加してください。日本語で返答ください。",
  },
  Tests = {
    prompt = "/COPILOT_GENERATE コードのテストを生成してください。日本語で返答ください。",
  },
  Wording = {
    prompt = "/COPILOT_GENERATE 次のテキストの文法と表現を改善してください。日本語で返答ください。",
  },
  Summarize = {
    prompt = "/COPILOT_GENERATE 選択範囲の要約を書いてください。日本語で返答ください。",
  },
  Spelling = {
    prompt = "/COPILOT_GENERATE 次のテキストのスペルミスを修正してください。日本語で返答ください。",
  },
  FixDiagnostic = {
    prompt = "ファイル内の次の問題を支援してください:",
    selection = function(source)
      local select = require("CopilotChat.select")
      select.diagnostics(source)
    end,
  },
  Commit = {
    prompt = "変更のコミットメッセージをcommitizenの規約に従って日本語で書いてください。タイトルは最大50文字、メッセージは72文字で折り返してください。メッセージ全体をgitcommit言語のコードブロックで囲んでください。",
    selection = function(source)
      local select = require("CopilotChat.select")
      select.gitdiff(source)
    end,
  },
  CommitStaged = {
    prompt = "変更のコミットメッセージをcommitizenの規約に従って日本語で書いてください。タイトルは最大50文字、メッセージは72文字で折り返してください。メッセージ全体をgitcommit言語のコードブロックで囲んでください。",
    selection = function(source)
      local select = require("CopilotChat.select")
      return select.gitdiff(source, true)
    end,
  },
  PullRequestSummary = {
    prompt = (function()
      local txt = "変更の Pull Request の詳細を日本語で書いてください。"
      return txt
    end)(),
    selection = function(source)
      local select = require("CopilotChat.select")
      local select_buffer = select.buffer(source)
      if not select_buffer then
        return nil
      end

      local bufname = vim.api.nvim_buf_get_name(source.bufnr)
      local file_path = bufname:gsub("^%w+://", "")
      local dir = vim.fn.fnamemodify(file_path, ":h")
      if not dir or dir == "" then
        return nil
      end
      dir = dir:gsub(".git$", "")

      local cmd = "git -C " .. dir .. " diff --no-color --no-ext-diff main...HEAD"
      local handle = io.popen(cmd)
      if not handle then
        return nil
      end

      local result = handle:read("*a")
      handle:close()
      if not result or result == "" then
        return nil
      end

      select_buffer.filetype = "diff"
      select_buffer.lines = result
      return select_buffer
    end,
  },
}
