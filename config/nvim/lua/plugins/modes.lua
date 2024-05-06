-- https://github.com/mvllow/modes.nvim
return {
  "mvllow/modes.nvim",
  event = { "ModeChanged" },
  config = function()
    require("modes").setup({
      colors = {
        copy = "#f5c359",
        delete = "#c75c6a",
        insert = "#78ccc5",
        visual = "#9745be",
      },
      -- Set opacity for cursorline and number background
      line_opacity = 0.35,
      -- Enable cursor hiighlights
      set_cursor = true,
      -- Enable cursorline initially, and disable cursorline for inactive windows
      -- or ignored filetypes
      set_cursorline = true,
      -- Enable line number highlights to match cursorline
      set_number = true,
    })
  end,
}
