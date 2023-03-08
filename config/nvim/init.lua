-- https://github.com/willelz/nvim-lua-guide-ja/blob/master/README.ja.md
local ok, res = pcall(require, 'base')
if not (ok) then print(res) end
require "plugins"

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

-- https://zenn.dev/botamotch/articles/21073d78bc68bf
require("mason").setup()
require("mason-lspconfig").setup()
require("lspsaga").setup({})

local on_attach = function(client, bufnr)
    local keymap = vim.keymap.set
    keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

    -- vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
    keymap('n', 'gf',
           '<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR><cmd>write<CR>')
    keymap('n', 'gF',
           '<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR><cmd>write<CR>')

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

require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true
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
