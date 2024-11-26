return {
  {
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = { enabled = false },
        hover = { enabled = false },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  -- vim.ui.input を telescope などで置き換える
  {
    "stevearc/dressing.nvim",
    event = { "ModeChanged" },
  },
  -- CSV 用のビューア
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
  -- Markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
    init = function()
      -- Override highlight groups
      vim.cmd([[
        hi! default link RenderMarkdownH1Bg @markup.heading
        hi! default link RenderMarkdownH2Bg @markup.heading
        hi! default link RenderMarkdownH3Bg @markup.heading
        hi! default link RenderMarkdownH4Bg @markup.heading
        hi! default link RenderMarkdownH5Bg @markup.heading
        hi! default link RenderMarkdownH10Bg @markup.heading
      ]])
    end,
  },
  -- help
  {
    "OXY2DEV/helpview.nvim",
    ft = "help",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  -- 画像の表示
  {
    "3rd/image.nvim",
    enabled = false,
    lazy = false,
    dependencies = { "luarocks.nvim" },
    opts = {},
  },
  -- 非アクティブなタブを暗く表示
  {
    "tadaa/vimade",
    event = "VeryLazy",
    opts = function()
      vim.cmd([[let vimade.basebg='#001040']])
      vim.cmd([[let vimade.fadelevel=0.65]])

      local Default = require("vimade.recipe.default").Default
      return Default({ animate = true })
    end,
  },
  -- 起動時の画面
  {
    "folke/drop.nvim",
    enabled = false,
    event = { "VeryLazy" },
    opts = {
      screensaver = 3 * 60 * 1000,
    },
  },
  {
    "goolord/alpha-nvim",
    event = { "VimEnter" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local Ascii = require("ascii_art")

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
        dashboard.button("e", "  New file", "<Cme>ene <BAR> startinsert <CR>"),
        dashboard.button("f", "󰈞  Find file", function()
          require("telescope").extensions.smart_open.smart_open({ cwd_only = true })
        end),
        dashboard.button("g", "  Grep word", "<Cmd>Telescope egrepify<CR>"),
        dashboard.button("q", "  Quit", "<Cmd>qa<CR>"),
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
      { "<C-w>w", "<Cmd>Chowcho<CR>" },
      {
        "<C-w>q",
        function()
          require("chowcho").run(vim.api.nvim_win_hide)
        end,
        desc = ":Chowcho (quit)",
      },
    },
    opts = {
      labels = { "a", "s", "d", "g", "h", "k", "l" },
      icon_enabled = true,
      text_color = "#FFFFFF",
      bg_color = "#545454",
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
    keys = {
      { "<C-w>r", "<Cmd>WinResizerStartResize<CR>", desc = "WinResizerStartResize" },
      { "<C-w>m", "<Cmd>WinResizerStartMove<CR>", desc = "WinResizerStartMove" },
    },
    init = function()
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
    -- event = { "VeryLazy" },
    keys = {
      { "<C-h>", "<Cmd>BufferLineCyclePrev<CR>" },
      { "<C-l>", "<Cmd>BufferLineCycleNext<CR>" },
      { "<C-M-h>", "<Cmd>BufferLineMovePrev<CR>" },
      { "<C-M-l>", "<Cmd>BufferLineMoveNext<CR>" },
      {
        "<leader>bg",
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
      {
        "<leader>bb",
        function()
          vim.o.showtabline = vim.o.showtabline == 2 and 0 or 2
          vim.cmd("BufferLineSortByDirectory")
        end,
        desc = "Toggle BufferLine Visible",
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
          name_formatter = function(buf_)
            local buf = buf_
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
                  return buf.name:match("%.test")
                    or buf.name:match("%.spec")
                    or buf.name:match("_test%.")
                    or buf.name:match("_spec%.")
                end,
                auto_close = false,
              },
              {
                name = " Story",
                highlight = { sp = "#FC2A72" },
                matcher = function(buf)
                  return buf.name:match("%.stories")
                end,
                auto_close = false,
              },
              {
                name = " Style",
                highlight = { sp = "#998626" },
                matcher = function(buf)
                  return buf.name:match("%.css") or buf.name:match("%.scss")
                end,
                auto_close = false,
              },
              {
                name = "󰗊 Locals",
                highlight = { sp = "#2F3C5C" },
                matcher = function(buf)
                  return buf.path:match("translation.json")
                end,
                auto_close = false,
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
                auto_close = false,
              },
              {
                name = " Config",
                highlight = { sp = "#4c4c4c" },
                matcher = function(buf)
                  return buf.name:match("%.config") or buf.name:match("^%..*rc$")
                end,
                auto_close = false,
              },
              {
                name = " Obsidian",
                highlight = { sp = "#8658F6" },
                matcher = function(buf)
                  return buf.path:lower():match("obsidian")
                end,
                auto_close = false,
              },
            },
          },
        },
      })
      vim.o.showtabline = 0
    end,
  },
  -- ファイルの状態を表示
  {
    "b0o/incline.nvim",
    event = { "VeryLazy" },
    opts = {
      hide = {
        cursorline = true,
        focused_win = false,
        only_win = false,
      },
      render = function(props)
        local devicons = require("nvim-web-devicons")
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end
        local ft_icon, ft_color = devicons.get_icon_color(filename)

        local function get_git_diff()
          local icons = { removed = " ", changed = " ", added = " " }

          local signs = vim.b[props.buf].gitsigns_status_dict
          local labels = {}
          if signs == nil then
            return labels
          end
          for name, icon in pairs(icons) do
            if tonumber(signs[name]) and signs[name] > 0 then
              table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
            end
          end
          if #labels > 0 then
            table.insert(labels, { "┊ " })
          end
          return labels
        end

        local function get_diagnostic_label()
          local icons = { error = " ", warn = " ", info = " ", hint = " " }
          local label = {}

          for severity, icon in pairs(icons) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > 0 then
              table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
            end
          end
          if #label > 0 then
            table.insert(label, { "┊ " })
          end
          return label
        end

        return {
          { get_diagnostic_label() },
          { get_git_diff() },
          { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
          {
            filename .. " ",
            gui = vim.bo[props.buf].modified and "bold,italic" or "bold",
            guifg = vim.bo[props.buf].modified and "#ffbc94" or "#FFFFFF",
          },
        }
      end,
    },
  },
  -- バッファを閉じる操作の拡張
  {
    "kazhala/close-buffers.nvim",
    event = { "VeryLazy" },
    keys = {
      { "<C-w>d", "<Cmd>BDelete! this<CR>" },
      { "<leader>w", "<Cmd>BDelete! this<CR>" },
      { "<leader>W", "<Cmd>BDelete! this<CR>" },
      { "<C-w>D", "<Cmd>BDelete other<CR>" },
    },
    opts = {},
  },
  -- ステータスバー
  {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return {
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
      }
    end,
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
  -- quick fix をいい感じに
  {
    "kevinhwang91/nvim-bqf",
    event = { "VeryLazy" },
  },
  -- 関数やオブジェクトのまとまりをわかりやすいように
  {
    "shellRaining/hlchunk.nvim",
    event = { "VeryLazy" },
    opts = {
      chunk = {
        enable = true,
        use_treesitter = true,
        style = { { fg = "#208aca" }, { fg = "#9f1b2e" } },
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = "»",
        },
      },
    },
  },
  --- fold
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = { "VeryLazy" },
    opts = {},
  },
  -- スクロールバー表示
  {
    "dstein64/nvim-scrollview",
    event = { "VeryLazy" },
    opts = function()
      return {
        diagnostics_severities = {
          vim.lsp.protocol.DiagnosticSeverity.Information,
          vim.lsp.protocol.DiagnosticSeverity.Warning,
          vim.lsp.protocol.DiagnosticSeverity.Error,
        },
        diagnostics_hint_symbol = "🔧",
        diagnostics_info_symbol = "",
        diagnostics_warn_symbol = "",
        diagnostics_error_symbol = "",
      }
    end,
  },
  -- スクロールをスムーズに
  {
    "karb94/neoscroll.nvim",
    keys = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    opts = {},
  },
  -- LSP の起動状況などを右下に表示
  {
    "j-hui/fidget.nvim",
    event = { "VeryLazy" },
    config = function()
      -- Highlight を定義
      vim.cmd([[ hi FidgetNormal guifg=#ccc guibg=#3777bd ]])

      require("fidget").setup({
        progress = {
          ignore = {
            function(msg)
              if msg.lsp_client.name == "null-ls" then
                -- cspell がカーソル移動のたびに code_action を送ってくるので無視
                return msg.title == "code_action"
              end
              return false
            end,
          },
        },
        notification = {
          window = { normal_hl = "FidgetNormal", winblend = 80, border = "single" },
        },
      })
    end,
  },
  {
    "shortcuts/no-neck-pain.nvim",
    event = { "VeryLazy" },
    opts = {
      width = 160,
    },
  },
}
