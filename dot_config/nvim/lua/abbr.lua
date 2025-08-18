local abbr = {
  { "const", "cosnt", mode = "i" },
  { "console", "conosle", mode = "i" },
}

for _, v in ipairs(abbr) do
  local abbr_target = v[1]
  local abbr_values = {}
  table.move(v, 2, #v, 1, abbr_values)

  local mode = v.mode or "i"
  local command = "iabbrev"
  if mode == "c" then
    command = "cabbrev"
  end

  for _, value in ipairs(abbr_values) do
    vim.cmd(string.format("%s %s %s", command, value, abbr_target))
  end
end
