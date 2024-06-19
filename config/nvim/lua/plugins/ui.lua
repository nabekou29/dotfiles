local Ascii = require("ascii_art")

return {
  -- カラースキーマ
  {
    "EdenEast/nightfox.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparent = true,
      },
    },
    config = function(_, opts)
      require("nightfox").setup(opts)
      vim.opt.pumblend = 20
      vim.cmd("colorscheme nightfox")
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")
    end,
  },
  {
    "hat0uma/csvview.nvim",
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    opts = {},
  },
  -- 画像の表示
  {
    "3rd/image.nvim",
    lazy = false,
    dependencies = { "luarocks.nvim" },
    opts = {},
  },
  -- 非アクティブなタブを暗く表示
  {
    "levouh/tint.nvim",
    cmd = { "TintStart" },
    -- event = { "FocusLost", "CursorHold" },
    init = function()
      function StartTint()
        require("tint")
      end
      vim.cmd("command! TintStart lua StartTint()")
    end,
    opts = {
      tint_background_colors = true,
      highlight_ignore_patterns = {
        "SignColumn",
        "LineNr",
        "CursorLine",
        "WinSeparator",
        "VertSplit",
        "StatusLineNC",
      },
    },
  },
  -- 起動時の画面
  {
    "goolord/alpha-nvim",
    event = { "VimEnter" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Header
      local hl_group_name = "AlphaHeader"
      dashboard.section.header.val = Ascii.miku
      dashboard.section.header.opts.hl = hl_group_name
      vim.cmd("hi " .. hl_group_name .. " guifg=#21F9C9")
      -- vim.cmd("hi " .. hl_group_name .. " guifg=#53912F")

      -- Menu
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
        dashboard.button("g", "  Grep word", ":Telescope live_grep<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      -- Set footer
      local function footer()
        local total_plugins = #vim.tbl_keys(require("lazy").plugins())
        local version = vim.version()
        local version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
        return "⚡" .. total_plugins .. " plugins" .. version_info
      end
      dashboard.section.footer.val = footer()

      alpha.setup(dashboard.config)
    end,
  },
  -- ウィンドウの選択
  {
    "tkmpypy/chowcho.nvim",
    keys = {
      { "<C-w>w", ":Chowcho<CR>" },
      {
        "<C-w>q",
        function()
          require("chowcho").run(vim.api.nvim_win_hide)
        end,
        desc = ":Chowcho (quit)",
      },
    },
    opts = {
      icon_enabled = true,
      text_color = "#FFFFFF",
      bg_color = "#555555",
      active_border_color = "#0A8BFF",
      border_style = "default",
      use_exclude_default = false,
      exclude = function(buf)
        local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
        if bt == "nofile" then
          return true
        end

        local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
        if ft == "neo-tree" then
          return true
        end
      end,
      zindex = 10000,
    },
  },
  -- ウィンドウのリサイズ
  {
    "simeji/winresizer",
    cmd = { "WinResizerStartResize", "WinResizerStartMove", "WinResizerStartFocus" },
    init = function()
      vim.keymap.set("n", "<C-w>r", ":WinResizerStartResize<CR>", {
        desc = ":WinResizerStartResize",
      })
      vim.keymap.set("n", "<C-w>m", ":WinResizerStartMove<CR>", {
        desc = ":WinResizerStartMove",
      })

      vim.g.winresizer_start_key = "<C-w>r"
    end,
  },
  -- バッファーのタブ表示
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "kazhala/close-buffers.nvim",
    },
    event = { "VeryLazy" },
    keys = {
      { "<C-h>", "<Cmd>BufferLineCyclePrev<CR>" },
      { "<C-l>", "<Cmd>BufferLineCycleNext<CR>" },
      { "<C-M-h>", "<Cmd>BufferLineMovePrev<CR>" },
      { "<C-M-l>", "<Cmd>BufferLineMoveNext<CR>" },
      {
        "<leader>bt",
        function()
          require("telescope.bufferline").buffer_line_group_picker()
        end,
        desc = "Toggle Buffer Group",
      },
      {
        "<leader>bs",
        "<Cmd>BufferLineSortByDirectory<CR>",
        desc = "Sort Buffer By Directory",
      },
    },
    config = function()
      ---@diagnostic disable-next-line: different-requires
      local bufferline = require("bufferline")
      local groups = require("bufferline.groups")
      bufferline.setup({
        highlights = {
          separator = {
            fg = "#1D2A31",
          },
          separator_selected = {
            fg = "#2B383E",
          },
          separator_visible = {
            fg = "#2B383E",
          },
          tab_separator = {
            fg = "#1D2A31",
          },
          tab_separator_selected = {
            fg = "#1D2A31",
          },
        },
        options = {
          separator_style = "slant", -- "thin",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local icon = ""
            if level:match("error") then
              icon = ""
            elseif level:match("warning") then
              icon = ""
            end
            return " " .. icon .. " " .. count
          end,
          tab_size = 10,
          max_name_length = 24,
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
          close_command = function(bufnum)
            require("close_buffers").delete({ type = bufnum })
          end,
          middle_mouse_command = function(bufnum)
            require("close_buffers").delete({ type = bufnum })
          end,
          show_duplicate_prefix = false,
          duplicates_across_groups = false,
          name_formatter = function(buf)
            -- index.ts などのファイルをわかりやすいように表示
            if buf.name:match("index%.") then
              local parentDir = buf.path:match("^.*/(.*)/[^/]*$")

              if parentDir then
                local name = parentDir .. "/" .. buf.name
                if name:len() > 24 then
                  local suffix = "…/" .. buf.name
                  local subP = parentDir:sub(1, 24 - suffix:len())
                  name = subP .. suffix
                end

                return name
              end
            end

            return buf.name
          end,
          groups = {
            items = {
              groups.builtin.pinned:with({ icon = "" }),
              groups.builtin.ungrouped,
              {
                name = " Test",
                highlight = { sp = "#1994E3" },
                matcher = function(buf)
                  return buf.name:match("%.test") or buf.name:match("%.spec")
                end,
              },
              {
                name = " Story",
                highlight = { sp = "#FC2A72" },
                matcher = function(buf)
                  return buf.name:match("%.stories")
                end,
              },
              {
                name = " Style",
                highlight = { sp = "#998626" },
                matcher = function(buf)
                  return buf.name:match("%.css") or buf.name:match("%.scss")
                end,
              },
              {
                name = "󰗊 Locals",
                highlight = { sp = "#2F3C5C" },
                matcher = function(buf)
                  return buf.path:match("translation.json")
                end,
              },
              {
                name = "󰈙 Docs",
                highlight = { sp = "#2C682A" },
                matcher = function(buf)
                  if buf.path:lower():match("obsidian") then
                    return false
                  end
                  return buf.name:match("%.md")
                end,
              },
              {
                name = " Config",
                highlight = { sp = "#4c4c4c" },
                matcher = function(buf)
                  return buf.name:match("%.config") or buf.name:match("^%..*rc$")
                end,
              },
              {
                name = " Obsidian",
                highlight = { sp = "#8658F6" },
                matcher = function(buf)
                  return buf.path:lower():match("obsidian")
                end,
              },
            },
          },
        },
      })
    end,
  },
  -- バッファを閉じる操作の拡張
  {
    "kazhala/close-buffers.nvim",
    event = { "VeryLazy" },
    keys = {
      { "<C-w>d", ":BDelete this<CR>" },
      { "<leader>w", ":BDelete this<CR>" },
      { "<leader>W", ":BDelete! this<CR>" },
      { "<C-w>D", ":BDelete other<CR>" },
    },
    opts = {},
  },
  -- ステータスバー
  {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
  -- モードをわかりやすく
  {
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
        line_opacity = 0.35,
        set_cursor = true,
        set_cursorline = true,
        set_number = true,
      })
    end,
  },
  -- 関数やオブジェクトのまとまりをわかりやすいように
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    opts = {
      indent = { use_treesitter = true },
      chunk = { style = { { fg = "#208aca" }, { fg = "#9f1b2e" } } },
      line_num = { enable = false, use_treesitter = true, style = "#208aca" },
    },
  },
  --- fold
  {
    "kevinhwang91/nvim-ufo",
    enabled = false,
    dependencies = { "kevinhwang91/promise-async" },
    event = { "VeryLazy" },
    opts = {},
  },
  -- スクロールバー表示
  {
    "petertriho/nvim-scrollbar",
    event = { "VeryLazy" },
    opts = {},
  },
  -- スクロールをスムーズに
  {
    "karb94/neoscroll.nvim",
    event = { "VeryLazy" },
    opts = {},
  },
  -- LSP の起動状況などを右下に表示
  {
    "j-hui/fidget.nvim",
    event = { "UIEnter" },
    config = function()
      -- Highlight を定義
      vim.cmd([[ hi FidgetNormal guifg=#ccc guibg=#1994E3 ]])

      require("fidget").setup({
        notification = {
          window = { normal_hl = "FidgetNormal", winblend = 80 },
        },
      })
    end,
  },
}
