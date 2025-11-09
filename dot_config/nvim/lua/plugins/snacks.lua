return {
  {
    "folke/snacks.nvim",
    -- "nabekou29/snacks.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    priority = 1000,
    lazy = false,
    opts = function()
      local scroll_filter_buftype = {
        terminal = true,
      }
      local scroll_filter_filetype = {
        scrollview_sign = true,
        ["blink-cmp-menu"] = true,
      }

      ---@type snacks.Config
      return {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = {
          enabled = false,
        },
        image = {
          formats = { "png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff", "heic", "avif", "mp4", "mov", "avi", "mkv", "webm", "pdf", "svg" },
        },
        indent = {
          enabled = false,
          chunk = {
            enabled = true,
            only_current = false,
            priority = 200,
            char = {
              corner_top = "╭",
              corner_bottom = "╰",
              horizontal = "─",
              vertical = "│",
              arrow = ">",
            },
          },
          filter = function(buf)
            return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
          end,
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
            marks = {
              exclude = "0123456789[]'\".",
            },
          },
          formatters = {
            file = {
              filename_first = false, -- display filename before the file path
              truncate = 80, -- truncate the file path to (roughly) this length
              filename_only = false, -- only show the filename
              icon_width = 2, -- width of the icon (in characters)
              git_status_hl = true, -- use the git status highlight group for the filename
            },
          },
          win = {
            input = {
              keys = {
                ["<C-S-j>"] = { "history_forward", mode = { "i", "n" } },
                ["<C-S-k>"] = { "history_back", mode = { "i", "n" } },
              },
            },
          },
        },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = {
          enabled = false,
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
          filter = function(buf)
            if vim.g.snacks_scroll == false or vim.b[buf].snacks_scroll == false then
              return false
            end
            if scroll_filter_buftype[vim.bo[buf].buftype] or scroll_filter_filetype[vim.bo[buf].filetype] then
              return false
            end

            return true
          end,
        },
        statuscolumn = { enabled = false },
        words = { enabled = true },
        lazygit = { enabled = false },
        terminal = { enabled = false },

        styles = {
          input = {
            relative = "cursor",
            row = -3,
            col = 0,
          },
          -- terminal = {
          --   relative = "editor",
          --   position = "float",
          --   border = "double",
          --   backdrop = 60,
          --   height = 0.9,
          --   width = 0.9,
          --   zindex = 50,
          -- },
          -- lazygit = {
          --   relative = "editor",
          --   border = "double",
          -- },
          zen = {
            relative = "editor",
            zindex = 100,
          },
        },
      }
    end,
    keys = function()
      local smart_opts = {
        matcher = {
          cwd_bonus = true,
        },
      }
      return {
      -- stylua: ignore start
      -- Fuzzy finder (nvim-telescope/telescope.nvim)
      { "<leader>ff", function() Snacks.picker.smart(smart_opts) end,  desc = "Smart Find Files" },
      { "<leader>fr", function() Snacks.picker.recent() end,           desc = "Recent Files" },
      { "<leader>fg", function() Snacks.picker.grep() end,             desc = "Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end,          desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end,             desc = "Help" },
      { "<leader>ft", function() Snacks.picker.todo_comments() end,    desc = "Todo Comments" },
      { "<leader>fm", function() Snacks.picker.marks() end,             desc = "Marks" },
      { "<leader>:",  function() Snacks.picker.command_history() end,  desc = "Command History" },

      -- Delete buffer (kazhala/close-buffers.nvim)
      { "<leader>w",  function() Snacks.bufdelete.delete() end,        desc = "Delete buffer" },
      { "<leader>W",  function() Snacks.bufdelete.other() end,         desc = "Delete other buffers" },
      { "<C-w>D",     function() Snacks.bufdelete.other() end,         desc = "Delete other buffers" },

      -- { "<leader>e",  function() Snacks.explorer() end,                desc = "Explorer" },

      -- Words
      { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",         mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",         mode = { "n", "t" } },
        -- stylua: ignore end
      }
    end,
    config = function(_, opts)
      ---@diagnostic disable-next-line: duplicate-set-field 上書き
      vim.print = function(...)
        Snacks.debug.inspect(...)
      end

      -- 500ms 後に indent を有効化。起動直後はエラーになることがある。
      vim.defer_fn(function()
        Snacks.indent.enable()
      end, 500)

      require("snacks").setup(opts)
    end,
  },
}
