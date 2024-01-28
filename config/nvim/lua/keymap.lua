-- Key Binding (Pluginは除く)
vim.keymap.set({ 'n', 'i', 'v' }, '<C-a>', '<HOME>', {})
vim.keymap.set({ 'n', 'i', 'v' }, '<C-e>', '<END>', {})
vim.keymap.set('n', '<C-S-h>', '<cmd>wincmd h<CR>', {})
vim.keymap.set('n', '<C-S-l>', '<cmd>wincmd l<CR>', {})
vim.keymap.set('n', '<C-S-j>', '<cmd>wincmd j<CR>', {})
vim.keymap.set('n', '<C-S-k>', '<cmd>wincmd k<CR>', {})


-- Clipboard
vim.keymap.set('n', '<leader>cp', '<cmd>:let @+ = expand("%:.")<CR>', {
  desc = 'Copy Relative Path',
})
vim.keymap.set('n', '<leader>cP', '<cmd>:let @+ = expand("%:p")<CR>', {
  desc = 'Copy Full Path',
})
vim.keymap.set('n', '<leader>cf', '<cmd>:let @+ = expand("%:t")<CR>', {
  desc = 'Copy File Name',
})
