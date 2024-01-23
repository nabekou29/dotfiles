return {
    'zbirenbaum/copilot.lua',
    cmd = {"Copilot"},
    event = {"InsertEnter"},
    config = function()
        require('copilot').setup {
            suggestion = {
                enabled = true,
                auto_trigger = true, -- false,
                debounce = 75,
                keymap = {
                    accept = "<M-;>",
                    accept_word = "<M-l>",
                    accept_line = "<M-j>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>"
                }
            }
        }
    end
}