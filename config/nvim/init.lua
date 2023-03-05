-- https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md
local ok, res = pcall(require, 'base')
if not (ok) then print(res) end
require "plugins"

require("which-key").setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
})

vim.keymap.set({'n', 'v'}, '<A-Up>', '<Plug>(expand_region_expand)', {})
vim.keymap.set({'n', 'v'}, '<A-k>', '<Plug>(expand_region_expand)', {})
vim.keymap.set({'n', 'v'}, '<A-Down>', '<Plug>(expand_region_shrink)', {})
vim.keymap.set({'n', 'v'}, '<A-j>', '<Plug>(expand_region_shrink)', {})

vim.keymap.set("n", "<leader>w", "<cmd>Bdelete<CR>", {})

require("auto-save").setup {
    -- your config goes here
    -- or just leave it empty :)
    trigger_events = {
        "InsertLeave" -- "TextChanged"
    }
}

-- https://github.com/EdenEast/nightfox.nvim
-- Default options
require('nightfox').setup({
    options = {
        -- Compiled file's destination location
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled", -- Compiled file suffix
        transparent = true, -- Disable setting background
        terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
        dim_inactive = false, -- Non focused panes set to alternative background
        module_default = true, -- Default enable value for modules
        colorblind = {
            enable = false, -- Enable colorblind support
            simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
            severity = {
                protan = 0, -- Severity [0,1] for protan (red)
                deutan = 0, -- Severity [0,1] for deutan (green)
                tritan = 0 -- Severity [0,1] for tritan (blue)
            }
        },
        styles = { -- Style to be applied to different syntax groups
            comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE"
        },
        inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false
        },
        modules = { -- List of various plugins and additional options
            -- ...
        }
    },
    palettes = {},
    specs = {},
    groups = {}
})

vim.cmd("colorscheme nightfox")

require'telescope'.setup {}
require"telescope".load_extension("frecency")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fF',
               function() builtin.find_files({hidden = true}) end, {})
vim.keymap.set('n', '<leader>FF',
               function() builtin.find_files({hidden = true}) end, {})
vim.keymap.set("n", "<leader>fr",
               "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>",
               {noremap = true, silent = true})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require('lualine').setup()
require('modes').setup({
    colors = {
        copy = "#f5c359",
        delete = "#c75c6a",
        insert = "#78ccc5",
        visual = "#9745be"
    },
    -- Set opacity for cursorline and number background
    line_opacity = 0.35,
    -- Enable cursor hiighlights
    set_cursor = true,
    -- Enable cursorline initially, and disable cursorline for inactive windows
    -- or ignored filetypes
    set_cursorline = true,
    -- Enable line number highlights to match cursorline
    set_number = true
})

require("bufferline").setup {}
vim.keymap.set('n', '<C-h>', '<Cmd>BufferLineCyclePrev<CR>', {})
vim.keymap.set('n', '<C-l>', '<Cmd>BufferLineCycleNext<CR>', {})

-- https://zenn.dev/botamotch/articles/21073d78bc68bf
require("mason").setup()
require("mason-lspconfig").setup()
require("lspsaga").setup({})

local on_attach = function(client, bufnr)
    local keymap = vim.keymap.set
    keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

    -- vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
    keymap('n', 'gf', '<cmd>lua vim.lsp.buf.format()<CR><cmd>write<CR>')

    keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')

    -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
    keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>")
    -- vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    -- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    -- vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

    -- vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    keymap("n", "gn", "<cmd>Lspsaga rename<CR>")
    keymap("n", "gN", "<cmd>Lspsaga rename ++project<CR>")

    -- vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    keymap("n", "ga", "<cmd>Lspsaga code_action<CR>")

    -- vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')

    -- vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')
    -- vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    keymap("n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
    keymap("n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>")
end
require('mason-lspconfig').setup_handlers({
    function(server)
        local opt = {
            -- -- Function executed when the LSP server startup
            -- on_attach = function(client, bufnr)
            --   local opts = { noremap=true, silent=true }
            --   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            --   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
            -- end,
            capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp
                                                                            .protocol
                                                                            .make_client_capabilities()),
            on_attach = on_attach
        }

        if server == 'stylelint_lsp' then
            require('lspconfig')[server].setup({
                capabilities = opt.capabilities,
                on_attach = opt.on_attach,
                filetypes = {
                    "css", "less", "scss", "sugarss", "vue", "wxss" --  "javascript", "javascriptreact", "typescript","typescriptreact"
                }
            })
            return
        end
        require('lspconfig')[server].setup(opt)
    end
})

-- LSP handlers
-- Off (ver1)
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = false
-- })
-- Off (ver2)
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function()
-- end

-- -- Reference highlight
-- vim.cmd [[
-- highlight LspReferenceText cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
-- highlight LspReferenceRead cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
-- highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
-- augroup lsp_document_highlight
--     autocmd!
--     autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
--     autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
-- augroup END
-- ]]

require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
}
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
               {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xw",
               "<cmd>TroubleToggle workspace_diagnostics<cr>",
               {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
               {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
               {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
               {silent = true, noremap = true})
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
               {silent = true, noremap = true})

-- 3. completion (hrsh7th/nvim-cmp)
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    sources = {
        {name = "nvim_lsp"}, {name = "buffer"}, {name = "path"}, {
            name = 'spell',
            option = {
                keep_all_entries = false,
                enable_in_context = function() return true end
            }
        }
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm {select = true}
    }),
    experimental = {ghost_text = true}
})

-- LazyGit 召喚
vim.keymap.set('n', '<leader>G', '<Cmd>LazyGit<CR>')

-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save#code-1
local null_ls = require("null-ls")
local command_resolver = require('null-ls.helpers.command_resolver')
local async_formatting = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    vim.lsp.buf_request(bufnr, "textDocument/formatting",
                        vim.lsp.util.make_formatting_params({}),
                        function(err, res, ctx)
        if err then
            local err_msg = type(err) == "string" and err or err.message
            -- you can modify the log message / level (or ignore it completely)
            vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
            return
        end

        -- don't apply results if buffer is unloaded or has been modified
        if not vim.api.nvim_buf_is_loaded(bufnr) or
            vim.api.nvim_buf_get_option(bufnr, "modified") then return end

        if res then
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            vim.lsp.util.apply_text_edits(res, bufnr, client and
                                              client.offset_encoding or "utf-16")
            vim.api.nvim_buf_call(bufnr, function()
                vim.cmd("silent noautocmd update")
            end)
        end
    end)
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    sources = { --
        -- 本当はLintの表示も null_ls でやりたいけど、stylelint がなぜか動かないのでやめる
        -- diagnostics
        -- null_ls.builtins.diagnostics.eslint.with({
        --     diagnostics_format = '[eslint] #{m}\n(#{c})'
        -- }), --
        -- null_ls.builtins.diagnostics.stylelint.with({
        --     diagnostics_format = '[stylelint] #{m}\n(#{c})'
        -- }), --
        -- format
        null_ls.builtins.formatting.eslint.with({}), --
        null_ls.builtins.formatting.stylelint.with({}), --
        null_ls.builtins.formatting.prettierd.with({}), --
        null_ls.builtins.formatting.lua_format --
        --
        --
    },
    debug = false
    -- on_attach = function(client, bufnr)
    --     if client.supports_method("textDocument/formatting") then
    --         vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
    --         vim.api.nvim_create_autocmd("BufWritePost", {
    --             group = augroup,
    --             buffer = bufnr,
    --             callback = function() async_formatting(bufnr) end
    --         })
    --     end
    -- end
})

local ts = require "nvim-treesitter.configs"

ts.setup {
    highlight = {enable = true, disable = {}},
    indent = {enable = true, disable = {}},
    ensure_installed = {
        "tsx", "toml", "fish", "json", "yaml", "css", "scss", "html", "lua",
        "svelte", "elm"
    },
    auto_install = true,
    rainbow = {enable = true, extended_mode = true}
}

local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = {"javascript", "typescript.tsx"}

require'colorizer'.setup()

require('gitsigns').setup()

require('git-conflict').setup()

require("todo-comments").setup()

local chowcho = require('chowcho')
chowcho.setup {
    icon_enabled = true, -- required 'nvim-web-devicons' (default: false)
    text_color = '#FFFFFF',
    bg_color = '#555555',
    active_border_color = '#0A8BFF',
    border_style = 'default', -- 'default', 'rounded',
    use_exclude_default = false,
    exclude = function(buf, win)
        -- Exclude a window from the choice based on its buffer information.
        -- This option is applied iff `use_exclude_default = false`.
        -- Note that below is identical to the `use_exclude_default = true`.
        local fname = vim.fn.expand('#' .. buf .. ':t')
        return fname == ''
    end,
    zindex = 10000 -- sufficiently large value to show on top of the other windows
}

vim.keymap.set('n', '<C-w>w', chowcho.run, {})
vim.keymap.set('n', '<C-w>q', function() chowcho.run(vim.api.nvim_win_hide) end,
               {})

require("indent_blankline").setup {
    show_end_of_line = true,
    show_current_context = true,
    show_current_context_start = true,

    char = "",
    char_highlight_list = {"IndentBlanklineIndent1", "IndentBlanklineIndent2"},
    space_char_highlight_list = {
        "IndentBlanklineIndent1", "IndentBlanklineIndent2"
    },
    show_trailing_blankline_indent = false
}

vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]

require('Comment').setup()

require('hlslens').setup()
require("scrollbar").setup()

require('git').setup()

require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = erue
        }
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false -- add a border to hover docs and signature help
    }
})

require("notify").setup({background_colour = "#000000"})

local hop = require('hop')
require'hop'.setup {}

local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
    hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true
    })
end, {remap = true, silent = true})
vim.keymap.set('', 'F', function()
    hop.hint_char1({
        direction = directions.BEFORE_CURSOR,
        current_line_only = true
    })
end, {remap = true, silent = true})
vim.keymap.set('', 't', function()
    hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1
    })
end, {remap = true, silent = true})
vim.keymap.set('', 'T', function()
    hop.hint_char1({
        direction = directions.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = 1
    })
end, {remap = true, silent = true})

local hop_prefix = '<leader><leader>'
vim.keymap.set('n', hop_prefix .. 'l', hop.hint_lines_skip_whitespace,
               {desc = '[Hop] Hint lines'})
vim.keymap.set('n', hop_prefix .. '/', hop.hint_patterns,
               {desc = '[Hop] Hint patterns', silent = ture})
vim.keymap.set('n', hop_prefix .. 'f', hop.hint_char2,
               {desc = '[Hop] Hint char2'})
