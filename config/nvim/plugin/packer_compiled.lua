-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/kohei_watanabe/.cache/nvim/packer_hererocks/2.1.1703358377/share/lua/5.1/?.lua;/Users/kohei_watanabe/.cache/nvim/packer_hererocks/2.1.1703358377/share/lua/5.1/?/init.lua;/Users/kohei_watanabe/.cache/nvim/packer_hererocks/2.1.1703358377/lib/luarocks/rocks-5.1/?.lua;/Users/kohei_watanabe/.cache/nvim/packer_hererocks/2.1.1703358377/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/kohei_watanabe/.cache/nvim/packer_hererocks/2.1.1703358377/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["auto-save.nvim"] = {
    config = { "\27LJ\2\ne\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\19trigger_events\1\0\0\1\2\0\0\16InsertLeave\nsetup\14auto-save\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/auto-save.nvim",
    url = "https://github.com/Pocco81/auto-save.nvim"
  },
  ["bufdelete.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/bufdelete.nvim",
    url = "https://github.com/famiu/bufdelete.nvim"
  },
  ["bufferline.nvim"] = {
    config = { "\27LJ\2\n”\1\0\0\6\0\v\0\0236\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0016\0\3\0009\0\4\0009\0\5\0'\2\6\0'\3\a\0'\4\b\0004\5\0\0B\0\5\0016\0\3\0009\0\4\0009\0\5\0'\2\6\0'\3\t\0'\4\n\0004\5\0\0B\0\5\1K\0\1\0!<Cmd>BufferLineCycleNext<CR>\n<C-l>!<Cmd>BufferLineCyclePrev<CR>\n<C-h>\6n\bset\vkeymap\bvim\nsetup\15bufferline\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/bufferline.nvim",
    url = "https://github.com/akinsho/bufferline.nvim"
  },
  ["chowcho.nvim"] = {
    config = { "\27LJ\2\nS\0\2\a\0\6\0\0146\2\0\0009\2\1\0029\2\2\2'\4\3\0\18\5\0\0'\6\4\0&\4\6\4B\2\2\2\6\2\5\0X\3\2Ä+\3\1\0X\4\1Ä+\3\2\0L\3\2\0\5\a:t\6#\vexpand\afn\bvimœ\1\1\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0003\3\4\0=\3\5\2B\0\2\1K\0\1\0\fexclude\0\1\0\a\vzindex\3êN\17border_style\fdefault\17icon_enabled\2\24active_border_color\f#0A8BFF\15text_color\f#FFFFFF\rbg_color\f#555555\24use_exclude_default\1\nsetup\fchowcho\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/chowcho.nvim",
    url = "https://github.com/tkmpypy/chowcho.nvim"
  },
  ["cmp-buffer"] = {
    after_files = { "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-emoji"] = {
    after_files = { "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp-emoji/after/plugin/cmp_emoji.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    after_files = { "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-nvim-ultisnips"] = {
    after_files = { "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp-nvim-ultisnips/after/plugin/cmp_nvim_ultisnips.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp-nvim-ultisnips",
    url = "https://github.com/quangnguyen30192/cmp-nvim-ultisnips"
  },
  ["cmp-path"] = {
    after_files = { "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    after_files = { "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp_luasnip/after/plugin/cmp_luasnip.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["copilot.lua"] = {
    commands = { "Copilot" },
    config = { "\27LJ\2\n€\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\3\0005\4\4\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\15suggestion\1\0\0\vkeymap\1\0\6\tnext\n<M-]>\16accept_word\n<M-l>\fdismiss\n<C-]>\16accept_line\n<M-j>\vaccept\n<M-;>\tprev\n<M-[>\1\0\3\fenabled\2\17auto_trigger\2\rdebounce\3K\nsetup\fcopilot\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/copilot.lua",
    url = "https://github.com/zbirenbaum/copilot.lua"
  },
  ["git-conflict.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17git-conflict\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/git-conflict.nvim",
    url = "https://github.com/akinsho/git-conflict.nvim"
  },
  ["git.nvim"] = {
    config = { "\27LJ\2\n1\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\bgit\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/git.nvim",
    url = "https://github.com/dinhhuy258/git.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n≠\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\28current_line_blame_opts\1\0\4\14virt_text\2\ndelay\3¨\2\18virt_text_pos\beol\22ignore_whitespace\1\1\0\1\23current_line_blame\2\nsetup\rgitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\bhop\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["lazygit.nvim"] = {
    config = { "\27LJ\2\nS\0\0\5\0\6\0\b6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0B\0\4\1K\0\1\0\21<Cmd>LazyGit<CR>\14<leader>G\6n\bset\vkeymap\bvim\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/lazygit.nvim",
    url = "https://github.com/kdheepak/lazygit.nvim"
  },
  ["lspkind.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/lspkind.nvim",
    url = "https://github.com/onsails/lspkind.nvim"
  },
  ["lspsaga.nvim"] = {
    config = { "\27LJ\2\nÏ\b\0\0\4\0\26\0+6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0025\3\n\0=\3\v\0025\3\f\0=\3\r\0024\3\0\0=\3\14\2B\0\2\0016\0\15\0009\0\16\0009\0\17\0'\2\18\0005\3\19\0B\0\3\0016\0\15\0009\0\16\0009\0\17\0'\2\20\0005\3\21\0B\0\3\0016\0\15\0009\0\16\0009\0\17\0'\2\22\0005\3\23\0B\0\3\0016\0\15\0009\0\16\0009\0\17\0'\2\24\0005\3\25\0B\0\3\1K\0\1\0\1\0\2\ttext\tüîß\vtexthl\23DiagnosticSignHint\23DiagnosticSignHint\1\0\2\ttext\bÔëâ\vtexthl\23DiagnosticSignInfo\23DiagnosticSignInfo\1\0\2\ttext\bÔôô\vtexthl\24DiagnosticSignError\24DiagnosticSignError\1\0\2\ttext\bÔî©\vtexthl\23DiagnosticSignWarn\23DiagnosticSignWarn\16sign_define\afn\bvim\24server_filetype_map\25rename_output_qflist\1\0\2\venable\1\21auto_open_qflist\1\23rename_action_keys\1\0\2\texec\t<CR>\tquit\n<C-c>\21code_action_keys\1\0\2\texec\t<CR>\tquit\6q\23finder_action_keys\1\0\6\14scroll_up\n<C-b>\vvsplit\6s\nsplit\6i\topen\6o\16scroll_down\n<C-f>\tquit\6q\23code_action_prompt\1\0\4\tsign\2\18sign_priority\3(\17virtual_text\2\venable\2\1\0\17\ndebug\1\15infor_sign\bÔëâ\17border_style\vsingle\27diagnostic_header_icon\v ÔÜà  \29diagnostic_prefix_format\t%d. \21code_action_icon\tüîß\30diagnostic_message_format\n%m %c\21highlight_prefix\1\27finder_definition_icon\nÔåë  \26finder_reference_icon\nÔåë  \22max_preview_lines\3\n\25rename_prompt_prefix\b‚û§\15error_sign\bÔôô\28definition_preview_icon\nÔî∏  \14warn_sign\bÔî©\29use_saga_diagnostic_sign\2\14hint_sign\bÔ†µ\nsetup\flspsaga\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/lspsaga.nvim",
    url = "https://github.com/glepnir/lspsaga.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    config = { "\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\nmason\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["modes.nvim"] = {
    config = { "\27LJ\2\n∆\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\vcolors\1\0\4\19set_cursorline\2\17line_opacity\4ÊÃô≥\6ÊÃŸ˛\3\15set_cursor\2\15set_number\2\1\0\4\vdelete\f#c75c6a\vinsert\f#78ccc5\vvisual\f#9745be\tcopy\f#f5c359\nsetup\nmodes\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/modes.nvim",
    url = "https://github.com/mvllow/modes.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "\27LJ\2\nl\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\20source_selector\1\0\0\1\0\2\vwinbar\2\15statusline\2\nsetup\rneo-tree\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  neotest = {
    config = { "\27LJ\2\nø\1\0\0\a\0\b\1\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0004\3\3\0006\4\0\0'\6\3\0B\4\2\0025\6\4\0B\4\2\2>\4\1\0036\4\0\0'\6\5\0B\4\2\0024\6\0\0B\4\2\0?\4\0\0=\3\a\2B\0\2\1K\0\1\0\radapters\1\0\0\21neotest-vim-test\1\0\1\18vitestCommand\15npx vitest\19neotest-vitest\nsetup\fneotest\frequire\5ÄÄ¿ô\4\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/neotest",
    url = "https://github.com/nvim-neotest/neotest"
  },
  ["neotest-go"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/neotest-go",
    url = "https://github.com/nvim-neotest/neotest-go"
  },
  ["neotest-vim-test"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/neotest-vim-test",
    url = "https://github.com/nvim-neotest/neotest-vim-test"
  },
  ["neotest-vitest"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/neotest-vitest",
    url = "https://github.com/marilari88/neotest-vitest"
  },
  ["nightfox.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/nightfox.nvim",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["noice.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/noice.nvim",
    url = "https://github.com/folke/noice.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["null-ls.nvim"] = {
    config = { "\27LJ\2\n¥\2\0\0\b\0\17\0(6\0\0\0'\2\1\0B\0\2\0026\1\2\0009\1\3\0019\1\4\0019\1\5\0015\3\6\0B\1\2\0019\1\a\0005\3\15\0004\4\5\0009\5\b\0009\5\t\0059\5\n\0059\5\v\0054\a\0\0B\5\2\2>\5\1\0049\5\b\0009\5\t\0059\5\f\0059\5\v\0054\a\0\0B\5\2\2>\5\2\0049\5\b\0009\5\t\0059\5\r\0059\5\v\0054\a\0\0B\5\2\2>\5\3\0049\5\b\0009\5\t\0059\5\14\5>\5\4\4=\4\16\3B\1\2\1K\0\1\0\fsources\1\0\1\ndebug\1\15lua_format\14prettierd\14stylelint\twith\reslint_d\15formatting\rbuiltins\nsetup\1\0\1\15timeout_ms\3à'\vformat\bbuf\blsp\bvim\fnull-ls\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\nC\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequire\v\0\2\2\0\0\0\1L\1\2\0ß\5\1\0\v\0)\0C6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0005\4\a\0005\5\5\0003\6\4\0=\6\6\5=\5\b\0044\5\b\0005\6\t\0>\6\1\0055\6\n\0>\6\2\0055\6\v\0>\6\3\0055\6\f\0>\6\4\0055\6\r\0>\6\5\0055\6\14\0>\6\6\0055\6\15\0>\6\a\5=\5\16\0049\5\17\0009\5\18\0059\5\19\0055\a\21\0009\b\17\0009\b\20\bB\b\1\2=\b\22\a9\b\17\0009\b\23\bB\b\1\2=\b\24\a9\b\17\0009\b\25\bB\b\1\2=\b\26\a9\b\17\0009\b\27\bB\b\1\2=\b\28\a9\b\17\0009\b\29\b5\n\30\0B\b\2\2=\b\31\aB\5\2\2=\5\17\0045\5$\0009\6 \0015\b!\0003\t\"\0=\t#\bB\6\2\2=\6%\5=\5&\0045\5'\0=\5(\4B\2\2\1K\0\1\0\17experimental\1\0\1\15ghost_text\2\15formatting\vformat\1\0\0\vbefore\0\1\0\3\tmode\vsymbol\rmaxwidth\0032\18ellipsis_char\b...\15cmp_format\t<CR>\1\0\1\vselect\2\fconfirm\n<C-e>\nabort\14<C-Space>\rcomplete\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\vinsert\vpreset\fmapping\fsources\1\0\1\tname\14ultisnips\1\0\1\tname\fluasnip\1\0\1\tname\rnvim_lua\1\0\1\tname\nemoji\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\1\tname\rnvim_lsp\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\flspkind\bcmp\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-hlslens"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fhlslens\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/nvim-hlslens",
    url = "https://github.com/kevinhwang91/nvim-hlslens"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-scrollbar"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14scrollbar\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/nvim-scrollbar",
    url = "https://github.com/petertriho/nvim-scrollbar"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nƒ\3\0\0\6\0\20\0\0296\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\5\0005\4\3\0004\5\0\0=\5\4\4=\4\6\0035\4\a\0004\5\0\0=\5\4\4=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0035\4\r\0=\4\14\3B\1\2\0016\1\0\0'\3\15\0B\1\2\0029\1\16\1B\1\1\0029\2\17\0015\3\19\0=\3\18\2K\0\1\0\1\3\0\0\15javascript\19typescript.tsx\27filetype_to_parsername\btsx\23get_parser_configs\28nvim-treesitter.parsers\fautotag\1\0\1\venable\2\frainbow\1\0\2\venable\2\18extended_mode\2\21ensure_installed\1\f\0\0\btsx\ttoml\tfish\tjson\tyaml\bcss\tscss\thtml\blua\vsvelte\belm\vindent\1\0\1\venable\2\14highlight\1\0\1\17auto_install\2\fdisable\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag",
    url = "https://github.com/windwp/nvim-ts-autotag"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["nvim-window-picker"] = {
    config = { "\27LJ\2\n˛\1\0\0\6\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\t\0005\4\5\0005\5\4\0=\5\6\0045\5\a\0=\5\b\4=\4\n\3=\3\v\2B\0\2\1K\0\1\0\17filter_rules\abo\1\0\0\fbuftype\1\3\0\0\rterminal\rquickfix\rfiletype\1\0\0\1\4\0\0\rneo-tree\19neo-tree-popup\vnotify\1\0\3\23other_win_hl_color\f#e35e4f\19autoselect_one\2\20include_current\1\nsetup\18window-picker\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/nvim-window-picker",
    url = "https://github.com/s1n7ax/nvim-window-picker"
  },
  ["open-browser.vim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/open-browser.vim",
    url = "https://github.com/tyru/open-browser.vim"
  },
  ["package-info.nvim"] = {
    config = { "\27LJ\2\nã\2\0\0\5\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0005\4\a\0=\4\b\3=\3\t\2B\0\2\1K\0\1\0\nicons\nstyle\1\0\2\15up_to_date\v| ÔÖä \routdated\v| ÔÖÜ \1\0\1\venable\2\vcolors\1\0\4\20package_manager\bnpm\20hide_up_to_date\1\27hide_unstable_versions\1\14autostart\2\1\0\2\15up_to_date\f#3C4048\routdated\f#d19a66\nsetup\17package-info\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/package-info.nvim",
    url = "https://github.com/vuki656/package-info.nvim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/quick-scope",
    url = "https://github.com/unblevable/quick-scope"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/kkharji/sqlite.lua"
  },
  ["telescope-frecency.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-github.nvim"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/telescope-github.nvim",
    url = "https://github.com/nvim-telescope/telescope-github.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\në\2\0\0\5\0\v\0\0296\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\b\0'\2\t\0B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\b\0'\2\n\0B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\b\0'\2\5\0B\0\2\1K\0\1\0\agh\rfrecency\19load_extension\15extensions\1\0\0\bfzf\1\0\0\1\0\4\28override_generic_sorter\1\25override_file_sorter\2\nfuzzy\2\14case_mode\15smart_case\nsetup\14telescope\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18todo-comments\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\nR\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\25use_diagnostic_signs\2\nsetup\ftrouble\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/opt/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-expand-region"] = {
    config = { "\27LJ\2\nË\2\0\0\6\0\17\0!6\0\0\0009\0\1\0009\0\2\0005\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0005\2\a\0'\3\b\0'\4\5\0005\5\t\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0005\2\n\0'\3\v\0'\4\f\0005\5\r\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0005\2\14\0'\3\15\0'\4\f\0005\5\16\0B\0\5\1K\0\1\0\1\0\1\tdesc\18Shrink region\n<A-j>\1\3\0\0\6n\6v\1\0\1\tdesc\18Shrink region!<Plug>(expand_region_shrink)\r<A-Down>\1\3\0\0\6n\6v\1\0\1\tdesc\18Expand region\n<A-k>\1\3\0\0\6n\6v\1\0\1\tdesc\18Expand region!<Plug>(expand_region_expand)\v<A-Up>\1\3\0\0\6n\6v\bset\vkeymap\bvim\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/vim-expand-region",
    url = "https://github.com/terryma/vim-expand-region"
  },
  ["vim-sandwich"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/vim-sandwich",
    url = "https://github.com/machakann/vim-sandwich"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/vim-startify",
    url = "https://github.com/mhinz/vim-startify"
  },
  ["vim-test"] = {
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/Users/kohei_watanabe/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^bufdelete"] = "bufdelete.nvim",
  ["^chowcho"] = "chowcho.nvim",
  ["^cmp"] = "nvim-cmp",
  ["^hop"] = "hop.nvim",
  ["^hop%.hint"] = "hop.nvim",
  ["^luasnip"] = "LuaSnip",
  ["^neo%-tree"] = "neo-tree.nvim",
  ["^neotest"] = "neotest",
  ["^package%-info"] = "package-info.nvim",
  ["^telescope"] = "telescope.nvim",
  ["^telescope%.builtin"] = "telescope.nvim",
  ["^trouble"] = "trouble.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Setup for: hop.nvim
time([[Setup for hop.nvim]], true)
try_loadstring("\27LJ\2\nï\1\0\0\6\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0006\3\0\0'\5\3\0B\3\2\0029\3\4\0039\3\5\3=\3\a\2B\0\2\1K\0\1\0\14direction\1\0\1\22current_line_only\2\17AFTER_CURSOR\18HintDirection\rhop.hint\14hint_chr1\bhop\frequireó\1\0\0\6\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0006\3\0\0'\5\3\0B\3\2\0029\3\4\0039\3\5\3=\3\a\2B\0\2\1K\0\1\0\14direction\1\0\1\22current_line_only\2\18BEFORE_CURSOR\18HintDirection\rhop.hint\15hint_char1\bhop\frequire©\1\0\0\6\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0006\3\0\0'\5\3\0B\3\2\0029\3\4\0039\3\5\3=\3\a\2B\0\2\1K\0\1\0\14direction\1\0\2\22current_line_only\2\16hint_offset\3ˇˇˇˇ\15\18AFTER_CvURSOR\18HintDirection\rhop.hint\15hint_char1\bhop\frequire•\1\0\0\6\0\b\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0006\3\0\0'\5\3\0B\3\2\0029\3\4\0039\3\5\3=\3\a\2B\0\2\1K\0\1\0\14direction\1\0\2\22current_line_only\2\16hint_offset\3\1\18BEFORE_CURSOR\18HintDirection\rhop.hint\15hint_char1\bhop\frequireF\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\31hint_lines_skip_whitespace\bhop\frequire9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\18hint_patterns\bhop\frequire6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\15hint_char2\bhop\frequire€\3\1\0\a\0\26\0@6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0003\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0003\4\b\0005\5\t\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\n\0003\4\v\0005\5\f\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\r\0003\4\14\0005\5\15\0B\0\5\1'\0\16\0006\1\0\0009\1\1\0019\1\2\1'\3\17\0\18\4\0\0'\5\18\0&\4\5\0043\5\19\0005\6\20\0B\1\5\0016\1\0\0009\1\1\0019\1\2\1'\3\17\0\18\4\0\0'\5\21\0&\4\5\0043\5\22\0005\6\23\0B\1\5\0016\1\0\0009\1\1\0019\1\2\1'\3\17\0\18\4\0\0'\5\4\0&\4\5\0043\5\24\0005\6\25\0B\1\5\1K\0\1\0\1\0\1\tdesc\21[Hop] Hint char2\0\1\0\2\tdesc\24[Hop] Hint patterns\vsilent\2\0\6/\1\0\1\tdesc\21[Hop] Hint lines\0\6l\6n\21<leader><leader>\1\0\2\vsilent\2\nremap\2\0\6T\1\0\2\vsilent\2\nremap\2\0\6t\1\0\2\vsilent\2\nremap\2\0\6F\1\0\2\vsilent\2\nremap\2\0\6f\5\bset\vkeymap\bvim\0", "setup", "hop.nvim")
time([[Setup for hop.nvim]], false)
-- Setup for: package-info.nvim
time([[Setup for package-info.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\tshow\17package-info\frequire9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\thide\17package-info\frequire;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\vtoggle\17package-info\frequire;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\vdelete\17package-info\frequire<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\finstall\17package-info\frequireC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\19change_version\17package-info\frequireñ\4\1\0\6\0\22\00016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0003\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0003\4\b\0005\5\t\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\n\0003\4\v\0005\5\f\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\r\0003\4\14\0005\5\15\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\16\0003\4\17\0005\5\18\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\19\0003\4\20\0005\5\21\0B\0\5\1K\0\1\0\1\0\2\fnoremap\2\tdesc Change node package version\0\15<leader>np\1\0\2\fnoremap\2\tdesc\25Install node package\0\15<leader>ni\1\0\2\fnoremap\2\tdesc\24Delete node package\0\15<leader>nd\1\0\2\fnoremap\2\tdesc\29Toggle node package info\0\15<leader>nt\1\0\2\fnoremap\2\tdesc\27Hide node package info\0\15<leader>nh\1\0\2\fnoremap\2\tdesc\27Show node package info\0\15<leader>ns\6n\bset\vkeymap\bvim\0", "setup", "package-info.nvim")
time([[Setup for package-info.nvim]], false)
-- Setup for: neo-tree.nvim
time([[Setup for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nfocus\rneo-tree\frequireM\0\0\6\0\4\0\n6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0+\3\2\0+\4\2\0+\5\2\0B\0\5\1K\0\1\0\fbuffers\tshow\rneo-tree\frequireW\0\0\4\0\4\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0+\3\1\0B\0\3\1K\0\1\0\15filesystem\24reveal_current_file\rneo-tree\frequireB\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\fbuffers\nfocus\rneo-tree\frequireE\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\15git_status\nfocus\rneo-tree\frequireª\1\1\0\6\0\14\0\0296\0\0\0009\0\1\0009\0\2\0\18\1\0\0'\3\3\0'\4\4\0003\5\5\0B\1\4\1\18\1\0\0'\3\3\0'\4\6\0003\5\a\0B\1\4\1\18\1\0\0'\3\3\0'\4\b\0003\5\t\0B\1\4\1\18\1\0\0'\3\3\0'\4\n\0003\5\v\0B\1\4\1\18\1\0\0'\3\3\0'\4\f\0003\5\r\0B\1\4\1K\0\1\0\0\n<C-3>\0\n<C-2>\0\n<C-1>\0\18<leader><S-e>\0\14<leader>e\6n\bset\vkeymap\bvim\0", "setup", "neo-tree.nvim")
time([[Setup for neo-tree.nvim]], false)
-- Setup for: neotest
time([[Setup for neotest]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\2\0B\0\1\1K\0\1\0\brun\fneotest\frequire[\0\0\5\0\a\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\2\0006\2\3\0009\2\4\0029\2\5\2'\4\6\0B\2\2\0A\0\0\1K\0\1\0\6%\vexpand\afn\bvim\brun\fneotest\frequire@\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0B\0\1\1K\0\1\0\rrun_last\brun\fneotest\frequireB\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0B\0\1\1K\0\1\0\vtoggle\fsummary\fneotest\frequireG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0B\0\1\1K\0\1\0\vtoggle\17output_panel\fneotest\frequireÏ\2\1\0\6\0\19\0)6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0003\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0003\4\b\0005\5\t\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\n\0003\4\v\0005\5\f\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\r\0003\4\14\0005\5\15\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\16\0003\4\17\0005\5\18\0B\0\5\1K\0\1\0\1\0\1\tdesc\23Toggle test output\0\15<leader>to\1\0\1\tdesc\24Toggle test summary\0\15<leader>ts\1\0\1\tdesc\18Run last test\0\15<leader>tl\1\0\1\tdesc\18Run test file\0\15<leader>tf\1\0\1\tdesc\rRun test\0\15<leader>tt\6n\bset\vkeymap\bvim\0", "setup", "neotest")
time([[Setup for neotest]], false)
-- Setup for: chowcho.nvim
time([[Setup for chowcho.nvim]], true)
try_loadstring("\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\brun\fchowcho\frequireU\0\0\3\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0006\2\3\0009\2\4\0029\2\5\2B\0\2\1K\0\1\0\18nvim_win_hide\bapi\bvim\brun\fchowcho\frequirel\1\0\6\0\b\0\0176\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0003\4\5\0004\5\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\6\0003\4\a\0004\5\0\0B\0\5\1K\0\1\0\0\v<C-w>q\0\v<C-w>w\6n\bset\vkeymap\bvim\0", "setup", "chowcho.nvim")
time([[Setup for chowcho.nvim]], false)
-- Setup for: trouble.nvim
time([[Setup for trouble.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\vtoggle\ftrouble\frequireP\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\26workspace_diagnostics\vtoggle\ftrouble\frequireO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\25document_diagnostics\vtoggle\ftrouble\frequireB\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\floclist\vtoggle\ftrouble\frequireC\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rquickfix\vtoggle\ftrouble\frequireI\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\19lsp_references\vtoggle\ftrouble\frequireÃ\4\1\0\6\0\21\00016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0003\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0003\4\a\0005\5\b\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\t\0003\4\n\0005\5\v\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\f\0003\4\r\0005\5\14\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\15\0003\4\16\0005\5\17\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\18\0003\4\19\0005\5\20\0B\0\5\1K\0\1\0\1\0\3\vsilent\2\tdesc\":TroubleToggle lsp_references\fnoremap\2\0\agR\1\0\3\vsilent\2\tdesc\28:TroubleToggle quickfix\fnoremap\2\0\15<leader>xq\1\0\3\vsilent\2\tdesc\27:TroubleToggle loclist\fnoremap\2\0\15<leader>xl\1\0\3\vsilent\2\tdesc(:TroubleToggle document_diagnostics\fnoremap\2\0\15<leader>xd\1\0\3\vsilent\2\tdesc):TroubleToggle workspace_diagnostics\fnoremap\2\0\1\0\3\vsilent\2\tdesc\19:TroubleToggle\fnoremap\2\0\15<leader>xx\6n\bset\vkeymap\bvim\0", "setup", "trouble.nvim")
time([[Setup for trouble.nvim]], false)
-- Setup for: telescope.nvim
time([[Setup for telescope.nvim]], true)
try_loadstring("\27LJ\2\nD\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\15find_files\22telescope.builtin\frequireS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\vhidden\2\15find_files\22telescope.builtin\frequireM\0\0\3\0\4\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0009\0\3\0B\0\1\1K\0\1\0\rfrecency\15extensions\14telescope\frequireC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14live_grep\22telescope.builtin\frequireA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\fbuffers\22telescope.builtin\frequireC\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\14help_tags\22telescope.builtin\frequireN\0\0\3\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0009\0\3\0009\0\4\0B\0\1\1K\0\1\0\vissues\agh\15extensions\14telescope\frequireÃ\4\1\0\6\0\25\00096\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0003\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\a\0003\4\b\0005\5\t\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\n\0003\4\v\0005\5\f\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\r\0003\4\14\0005\5\15\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\16\0003\4\17\0005\5\18\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\19\0003\4\20\0005\5\21\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\22\0003\4\23\0005\5\24\0B\0\5\1K\0\1\0\1\0\1\tdesc\25:Telescope gh issues\0\15<leader>gi\1\0\1\tdesc\25:Telescope help_tags\0\15<leader>fh\1\0\1\tdesc\23:Telescope buffers\0\15<leader>fb\1\0\1\tdesc\25:Telescope live_grep\0\15<leader>fg\1\0\3\vsilent\2\tdesc\24:Telescope frecency\fnoremap\2\0\15<leader>fr\1\0\1\tdesc;:Telescope find_files find_command=rg,--hidden,--files\0\15<leader>fF\1\0\1\tdesc\26:Telescope find_files\0\15<leader>ff\6n\bset\vkeymap\bvim\0", "setup", "telescope.nvim")
time([[Setup for telescope.nvim]], false)
-- Setup for: bufdelete.nvim
time([[Setup for bufdelete.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\4\0\2\0\b6\0\0\0'\2\1\0B\0\2\0029\0\1\0)\2\0\0+\3\2\0B\0\3\1K\0\1\0\14bufdelete\frequireX\1\0\6\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0003\4\5\0005\5\6\0B\0\5\1K\0\1\0\1\0\1\tdesc\r:Bdelete\0\14<leader>w\6n\bset\vkeymap\bvim\0", "setup", "bufdelete.nvim")
time([[Setup for bufdelete.nvim]], false)
-- Config for: modes.nvim
time([[Config for modes.nvim]], true)
try_loadstring("\27LJ\2\n∆\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\vcolors\1\0\4\19set_cursorline\2\17line_opacity\4ÊÃô≥\6ÊÃŸ˛\3\15set_cursor\2\15set_number\2\1\0\4\vdelete\f#c75c6a\vinsert\f#78ccc5\vvisual\f#9745be\tcopy\f#f5c359\nsetup\nmodes\frequire\0", "config", "modes.nvim")
time([[Config for modes.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n;\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: mason.nvim
time([[Config for mason.nvim]], true)
try_loadstring("\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\nmason\frequire\0", "config", "mason.nvim")
time([[Config for mason.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: git.nvim
time([[Config for git.nvim]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\bgit\frequire\0", "config", "git.nvim")
time([[Config for git.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: nvim-hlslens
time([[Config for nvim-hlslens]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fhlslens\frequire\0", "config", "nvim-hlslens")
time([[Config for nvim-hlslens]], false)
-- Config for: vim-expand-region
time([[Config for vim-expand-region]], true)
try_loadstring("\27LJ\2\nË\2\0\0\6\0\17\0!6\0\0\0009\0\1\0009\0\2\0005\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0005\2\a\0'\3\b\0'\4\5\0005\5\t\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0005\2\n\0'\3\v\0'\4\f\0005\5\r\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0005\2\14\0'\3\15\0'\4\f\0005\5\16\0B\0\5\1K\0\1\0\1\0\1\tdesc\18Shrink region\n<A-j>\1\3\0\0\6n\6v\1\0\1\tdesc\18Shrink region!<Plug>(expand_region_shrink)\r<A-Down>\1\3\0\0\6n\6v\1\0\1\tdesc\18Expand region\n<A-k>\1\3\0\0\6n\6v\1\0\1\tdesc\18Expand region!<Plug>(expand_region_expand)\v<A-Up>\1\3\0\0\6n\6v\bset\vkeymap\bvim\0", "config", "vim-expand-region")
time([[Config for vim-expand-region]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: bufferline.nvim
time([[Config for bufferline.nvim]], true)
try_loadstring("\27LJ\2\n”\1\0\0\6\0\v\0\0236\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\0016\0\3\0009\0\4\0009\0\5\0'\2\6\0'\3\a\0'\4\b\0004\5\0\0B\0\5\0016\0\3\0009\0\4\0009\0\5\0'\2\6\0'\3\t\0'\4\n\0004\5\0\0B\0\5\1K\0\1\0!<Cmd>BufferLineCycleNext<CR>\n<C-l>!<Cmd>BufferLineCyclePrev<CR>\n<C-h>\6n\bset\vkeymap\bvim\nsetup\15bufferline\frequire\0", "config", "bufferline.nvim")
time([[Config for bufferline.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nƒ\3\0\0\6\0\20\0\0296\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\5\0005\4\3\0004\5\0\0=\5\4\4=\4\6\0035\4\a\0004\5\0\0=\5\4\4=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0035\4\r\0=\4\14\3B\1\2\0016\1\0\0'\3\15\0B\1\2\0029\1\16\1B\1\1\0029\2\17\0015\3\19\0=\3\18\2K\0\1\0\1\3\0\0\15javascript\19typescript.tsx\27filetype_to_parsername\btsx\23get_parser_configs\28nvim-treesitter.parsers\fautotag\1\0\1\venable\2\frainbow\1\0\2\venable\2\18extended_mode\2\21ensure_installed\1\f\0\0\btsx\ttoml\tfish\tjson\tyaml\bcss\tscss\thtml\blua\vsvelte\belm\vindent\1\0\1\venable\2\14highlight\1\0\1\17auto_install\2\fdisable\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: lazygit.nvim
time([[Config for lazygit.nvim]], true)
try_loadstring("\27LJ\2\nS\0\0\5\0\6\0\b6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0B\0\4\1K\0\1\0\21<Cmd>LazyGit<CR>\14<leader>G\6n\bset\vkeymap\bvim\0", "config", "lazygit.nvim")
time([[Config for lazygit.nvim]], false)
-- Config for: git-conflict.nvim
time([[Config for git-conflict.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17git-conflict\frequire\0", "config", "git-conflict.nvim")
time([[Config for git-conflict.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.api.nvim_create_user_command, 'Copilot', function(cmdargs)
          require('packer.load')({'copilot.lua'}, { cmd = 'Copilot', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'copilot.lua'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Copilot ', 'cmdline')
      end})
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au FocusLost * ++once lua require("packer.load")({'gitsigns.nvim', 'trouble.nvim', 'todo-comments.nvim'}, { event = "FocusLost *" }, _G.packer_plugins)]]
vim.cmd [[au TermEnter * ++once lua require("packer.load")({'nvim-scrollbar'}, { event = "TermEnter *" }, _G.packer_plugins)]]
vim.cmd [[au TextChanged * ++once lua require("packer.load")({'nvim-scrollbar'}, { event = "TextChanged *" }, _G.packer_plugins)]]
vim.cmd [[au VimResized * ++once lua require("packer.load")({'nvim-scrollbar'}, { event = "VimResized *" }, _G.packer_plugins)]]
vim.cmd [[au WinEnter * ++once lua require("packer.load")({'nvim-scrollbar'}, { event = "WinEnter *" }, _G.packer_plugins)]]
vim.cmd [[au WinScrolled * ++once lua require("packer.load")({'nvim-scrollbar'}, { event = "WinScrolled *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'cmp-buffer', 'auto-save.nvim', 'copilot.lua', 'cmp_luasnip', 'cmp-path', 'cmp-nvim-ultisnips', 'cmp-nvim-lua', 'cmp-emoji'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'lspsaga.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au InsertLeave * ++once lua require("packer.load")({'null-ls.nvim'}, { event = "InsertLeave *" }, _G.packer_plugins)]]
vim.cmd [[au TabEnter * ++once lua require("packer.load")({'nvim-scrollbar'}, { event = "TabEnter *" }, _G.packer_plugins)]]
vim.cmd [[au CursorHold * ++once lua require("packer.load")({'gitsigns.nvim', 'trouble.nvim', 'todo-comments.nvim'}, { event = "CursorHold *" }, _G.packer_plugins)]]
vim.cmd [[au BufWinEnter * ++once lua require("packer.load")({'nvim-scrollbar'}, { event = "BufWinEnter *" }, _G.packer_plugins)]]
vim.cmd [[au CmdwinLeave * ++once lua require("packer.load")({'nvim-scrollbar'}, { event = "CmdwinLeave *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
