vim.api.nvim_create_user_command("Copy", function(opts)
  local target = opts.fargs[1]

  local str = nil

  if target == "relative-path" then
    str = vim.fn.expand("%:.")
  elseif target == "full-path" then
    str = vim.fn.expand("%:p")
  elseif target == "file-name" then
    str = vim.fn.expand("%:t")
  elseif target == "github-link" then
    -- 現在の行のリンクをコピー
    local file = vim.fn.expand("%:.")
    local line = vim.fn.line(".")
    str = vim.fn.system("gh browse -n '" .. file .. ":" .. line .. "'")
  elseif target == "github-file-link" then
    -- 現在のファイルのリンクをコピー
    local file = vim.fn.expand("%:.")
    str = vim.fn.system("gh browse -n '" .. file .. "'")
  else
    vim.notify("Unknown target: " .. target, vim.log.levels.ERROR)
  end

  if str then
    vim.notify("Copied: " .. str, vim.log.levels.INFO)
    vim.fn.setreg("+", str)
  end
end, {
  nargs = 1,
  complete = function(arg_lead)
    return vim
      .iter({
        "relative-path",
        "full-path",
        "file-name",
        "github-link",
        "github-file-link",
      })
      :filter(function(target)
        return target:match(arg_lead)
      end)
      :totable()
  end,
})
