local M = {}

local default = {
  lsp = {
    denols = {
      enabled = false,
    },
  },
}

function M.get(...)
  local config = default

  ---@diagnostic disable-next-line: undefined-field
  local local_config = _G.local_config
  if local_config then
    config = vim.tbl_deep_extend("force", config, local_config)
  end

  local keys = {}
  for _, key in ipairs({ ... }) do
    -- "." で分割
    for _, k in ipairs(vim.split(key, ".", { plain = true })) do
      table.insert(keys, k)
    end
  end

  return vim.tbl_get(config, unpack(keys))
end

return M
