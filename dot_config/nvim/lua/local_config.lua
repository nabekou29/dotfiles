local M = {}

local default = {
  lsp = {
    biome = { enabled = nil },
    ["css-lsp"] = { enabled = nil },
    css_variables = { enabled = nil },
    cssmodules_ls = { enabled = nil },
    cspell = { enabled = nil },
    denols = { enabled = false },
    elmls = { enabled = nil },
    eslint = { enabled = nil },
    gopls = { enabled = nil },
    html = { enabled = nil },
    jsonls = { enabled = nil },
    lua_ls = { enabled = nil },
    rust_analyzer = { enabled = nil },
    stylelint_lsp = { enabled = nil },
    svelte = { enabled = nil },
    tailwindcss = { enabled = nil },
    terraformls = { enabled = nil },
    tflint = { enabled = nil },
    ts_ls = { enabled = nil },
    yamlls = { enabled = nil },
  },
  formatter = {
    prettier = { enabled = nil },
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
