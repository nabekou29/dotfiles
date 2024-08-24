local M = {}

function M.get(...)
  ---@diagnostic disable-next-line: undefined-field
  if not _G.local_config then
    return nil
  end

  local keys = {}
  for _, key in ipairs({ ... }) do
    -- "." で分割
    for _, k in ipairs(vim.split(key, ".", { plain = true })) do
      table.insert(keys, k)
    end
  end

  return vim.tbl_get(_G.local_config, unpack(keys))
end

return M
