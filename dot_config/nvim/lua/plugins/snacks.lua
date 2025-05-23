return {
  {
    -- "folke/snacks.nvim",
    "nabekou29/snacks.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = {
        enabled = true,
        ---@type fun(a: snacks.picker.explorer.Node, b: snacks.picker.explorer.Node):boolean
        sort = function(a, b) end,
      },
      image = {
        formats = { "png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff", "heic", "avif", "mp4", "mov", "avi", "mkv", "webm", "pdf", "svg" },
      },
      indent = {
        enabled = true,
        chunk = {
          enabled = true,
          only_current = true,
          priority = 200,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
      },
      input = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            layout = { layout = {
              position = "left",
              width = 0.2,
            } },
          },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 20, total = 120 },
          easing = "linear",
          fps = 30,
        },
        animate_repeat = {
          delay = 100,
          duration = { step = 5, total = 40 },
          easing = "linear",
          fps = 30,
        },
      },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      lazygit = {
        config = {
          os = {
            edit = 'nvr --servername "$NVIM" -l -s --remote {{filename}}',
            editAtLine = 'nvr --servername "$NVIM" -l -s -c {{line}} --remote {{filename}}',
            editAtLineAndWait = "nvim +{{line}} {{filename}}",
            openDirInEditor = 'nvr --servername "$NVIM" -l -s --remote {{dir}}',
            editInTerminal = false,
          },
        },
      },

      styles = {
        input = {
          relative = "cursor",
          row = -3,
          col = 0,
        },
        terminal = {
          relative = "editor",
          position = "float",
          border = "double",
          backdrop = 60,
          height = 0.9,
          width = 0.9,
          zindex = 50,
        },
        lazygit = {
          relative = "editor",
          border = "double",
        },
        zen = {
          relative = "editor",
          zindex = 100,
        },
      },
    },
    keys = {
      -- stylua: ignore start
      -- Fuzzy finder (nvim-telescope/telescope.nvim)
      { "<leader>ff", function() Snacks.picker.smart() end,            desc = "Smart Find Files" },
      { "<leader>fr", function() Snacks.picker.recent() end,           desc = "Recent Files" },
      { "<leader>fg", function() Snacks.picker.grep() end,             desc = "Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end,          desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end,             desc = "Help" },
      { "<leader>ft", function() Snacks.picker.todo_comments() end,    desc = "Todo Comments" },
      { "<leader>:",  function() Snacks.picker.command_history() end,  desc = "Command History" },

      -- Terminal (akinsho/toggleterm.nvim)
      { "<M-t>",      function() Snacks.terminal() end,                desc = "Terminal",               mode = { "n", "t" } },
      { "<leader>gd", function() Snacks.terminal('gh dash') end,       desc = "Terminal",               mode = { "n", } },
      { "<C-g>",      function() Snacks.lazygit() end,                 desc = "Lazygit",                mode = { "n", "t" } },

      -- Delete buffer (kazhala/close-buffers.nvim)
      { "<leader>w",  function() Snacks.bufdelete.delete() end,        desc = "Delete buffer" },
      { "<leader>W",  function() Snacks.bufdelete.other() end,         desc = "Delete other buffers" },
      { "<C-w>D",     function() Snacks.bufdelete.other() end,         desc = "Delete other buffers" },

      { "<leader>e",  function() Snacks.explorer() end,                desc = "Explorer" },

      -- Words
      { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",         mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",         mode = { "n", "t" } },

      -- stylua: ignore end
    },
    config = function(_, opts)
      _G.Snacks = require("snacks")

      ---@diagnostic disable-next-line: duplicate-set-field 上書き
      vim.print = function(...)
        Snacks.debug.inspect(...)
      end

      require("snacks").setup(opts)
    end,
  },
}
