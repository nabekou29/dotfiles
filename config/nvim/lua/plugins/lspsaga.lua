return {
    'nvimdev/lspsaga.nvim',
    cmd = {'Lspsaga'},
    event = {'LspAttach'},
    dependencies = {{"nvim-tree/nvim-web-devicons"}, -- Please make sure you install markdown and markdown_inline parser
    {"nvim-treesitter/nvim-treesitter"}},
    init = function()
        local keymap = vim.keymap.set
        keymap('n', 'gh', '<cmd>Lspsaga finder<CR>')

        keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>')

        keymap('n', 'gd', '<cmd>Lspsaga peek_definition<CR>')
        keymap('n', 'gD', '<cmd>Lspsaga goto_definition<CR>')
        keymap('n', 'gn', '<cmd>Lspsaga rename<CR>')
        keymap('n', 'gN', '<cmd>Lspsaga rename ++project<CR>')

        keymap('n', 'ga', '<cmd>Lspsaga code_action<CR>')

        keymap('n', 'g[', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
        keymap('n', 'g]', '<cmd>Lspsaga diagnostic_jump_next<CR>')
    end,
    config = function()
        require('lspsaga').setup {}
    end

    -- "nvimdev/lspsaga.nvim",
    -- cmd = {"Lspsaga"},
    -- event = {"BufReadPre", "BufNewFile"},
    -- dependencies = {{"nvim-tree/nvim-web-devicons"}, -- Please make sure you install markdown and markdown_inline parser
    -- {"nvim-treesitter/nvim-treesitter"}},
    -- init = function()
    --     local keymap = vim.keymap.set
    --     keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

    --     keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

    --     keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
    --     keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>")
    --     keymap("n", "gn", "<cmd>Lspsaga rename<CR>")
    --     keymap("n", "gN", "<cmd>Lspsaga rename ++project<CR>")

    --     keymap("n", "ga", "<cmd>Lspsaga code_action<CR>")

    --     keymap("n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
    --     keymap("n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>")
    -- end,
    -- config = function()
    --     require("lspsaga").setup {
    --         debug = false,
    --         use_saga_diagnostic_sign = true,
    --         -- diagnostic sign
    --         error_sign = "",
    --         warn_sign = "",
    --         hint_sign = "",
    --         infor_sign = "",
    --         diagnostic_header_icon = "   ",
    --         -- code action title icon
    --         code_action_icon = "🔧",
    --         code_action_prompt = {
    --             enable = true,
    --             sign = true,
    --             sign_priority = 40,
    --             virtual_text = true
    --         },
    --         finder_definition_icon = "  ",
    --         finder_reference_icon = "  ",
    --         max_preview_lines = 10,
    --         finder_action_keys = {
    --             open = "o",
    --             vsplit = "s",
    --             split = "i",
    --             quit = "q",
    --             scroll_down = "<C-f>",
    --             scroll_up = "<C-b>"
    --         },
    --         code_action_keys = {
    --             quit = "q",
    --             exec = "<CR>"
    --         },
    --         rename_action_keys = {
    --             quit = "<C-c>",
    --             exec = "<CR>"
    --         },
    --         definition_preview_icon = "  ",
    --         border_style = "single",
    --         rename_prompt_prefix = "➤",
    --         rename_output_qflist = {
    --             enable = false,
    --             auto_open_qflist = false
    --         },
    --         server_filetype_map = {},
    --         diagnostic_prefix_format = "%d. ",
    --         diagnostic_message_format = "%m %c",
    --         highlight_prefix = false
    --     }

    -- end
}
