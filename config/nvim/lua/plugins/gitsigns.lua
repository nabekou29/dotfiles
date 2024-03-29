return {
    'lewis6991/gitsigns.nvim', -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    event = {"FocusLost", "CursorHold"},
    config = function()
        require('gitsigns').setup({
            current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 300,
                ignore_whitespace = false
            }
        })
    end
}
