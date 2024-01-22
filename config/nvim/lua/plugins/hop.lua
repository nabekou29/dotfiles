return {{
    'phaazon/hop.nvim',
    module = {'hop', 'hop.hint'},
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {{'unblevable/quick-scope'}},
    config = function()
        require('hop').setup {}

        vim.keymap.set('', 'f', ':HopChar1CurrentLineAC<CR>', {
            silent = true
        })
        vim.keymap.set('', 'F', ':HopChar1CurrentLineBC<CR>', {
            silent = true
        })
        vim.keymap.set('', 't', ':HopChar1AC<CR>', {
            silent = true
        })
        vim.keymap.set('', 'T', ':HopChar1BC<CR>', {
            silent = true
        })

        local hop_prefix = '<leader><leader>'
        vim.keymap.set('n', hop_prefix .. 'l', ':HopLineStart<CR>')
        vim.keymap.set('n', hop_prefix .. '/', ':HopPattern<CR>')
        vim.keymap.set('n', hop_prefix .. 'f', ':HopChar2<CR>')
    end
}}
