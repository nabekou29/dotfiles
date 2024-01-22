-- https://github.com/akinsho/bufferline.nvim
return {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = {"BufReadPre", "BufNewFile"},
    config = function()
        vim.keymap.set('n', '<C-h>', '<Cmd>BufferLineCyclePrev<CR>', {})
        vim.keymap.set('n', '<C-l>', '<Cmd>BufferLineCycleNext<CR>', {})
        local bufferline = require('bufferline')
        require("bufferline").setup {}
    end
}
