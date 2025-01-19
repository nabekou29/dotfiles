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

-- vim.api.nvim_create_user_command("Backup", function(opts)
--   local subCommand = opts.fargs[1]
--
--   --- @type string
--   local backupDir = vim.opt.backupdir:get()[1]
--
--   local backupFilePath = nil
--
--   if vim.endswith(backupDir, "//") then
--     local fullPath = vim.fn.expand("%:p")
--     backupDir = backupDir:sub(1, -2)
--     backupFilePath = backupDir .. fullPath:gsub("/", "%%") .. "~"
--   end
--
--   vim.print({ fullPath = fullPath, backupDir = backupDir, backupFilePath = backupFilePath })
-- end, {
--   nargs = 1,
--   complete = function(arg_lead)
--     return vim
--       .iter({
--         "show",
--         "restore",
--       })
--       :filter(function(target)
--         return target:match(arg_lead)
--       end)
--       :totable()
--   end,
-- })
