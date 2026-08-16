-- Register the mdx filetype
vim.filetype.add({ extension = { mdx = "mdx" } })
-- Configure treesitter to use the markdown parser for mdx files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "mdx",
  once = true,
  callback = function()
    vim.treesitter.language.register("markdown", "mdx")
  end,
})
