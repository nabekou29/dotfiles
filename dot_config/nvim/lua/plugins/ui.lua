return {
  -- icon
  {
    "nvim-mini/mini.icons",
    opts = {},
    config = function(_, opts)
      require("mini.icons").setup(opts)
      require("mini.icons").mock_nvim_web_devicons()
    end,
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
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      file_types = { "markdown" },
    },
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

  -- 非アクティブなタブを暗く表示
  {
    "tadaa/vimade",
    event = { "VeryLazy" },
    opts = function()
      vim.cmd([[let vimade.basebg='#001040']])
      vim.cmd([[let vimade.fadelevel=0.66]])

      return {
        recipe = { "default", { animate = true } },
        blocklist = {
          default = {
            buf_opts = {
              ft = {
                "toggleterm",
              },
            },
          },
        },
      }
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
      labels = vim.split("asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM1234567890", ""),
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
      "kazhala/close-buffers.nvim",
    },
    -- event = { "VeryLazy" },
    keys = {
      { "<M-[>", "<Cmd>BufferLineCyclePrev<CR>" },
      { "<M-]>", "<Cmd>BufferLineCycleNext<CR>" },
      { "<C-M-[>", "<Cmd>BufferLineMovePrev<CR>" },
      { "<C-M-]>", "<Cmd>BufferLineMoveNext<CR>" },
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
            Snacks.bufdelete.delete(bufnum)
          end,
          middle_mouse_command = function(bufnum)
            Snacks.bufdelete.delete(bufnum)
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
                  return buf.name:match("%.test") or buf.name:match("%.spec") or buf.name:match("_test%.") or buf.name:match("_spec%.")
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
    dependencies = { "nvim-mini/mini.icons" },
    event = { "VeryLazy" },
    opts = {
      hide = {
        cursorline = "smart",
        focused_win = false,
        only_win = false,
      },
      render = function(props)
        local MiniIcons = require("mini.icons")
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = vim.fn.fnamemodify(bufname, ":t")

        -- UUIDパターン（8-4-4-4-12形式）を含むファイルは非表示
        local uuid_pattern = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
        if filename:match(uuid_pattern) then
          return {}
        end

        if filename == "" then
          filename = "[No Name]"
        end
        local ft_icon, ft_hl = MiniIcons.get("file", filename)

        -- 親ディレクトリを表示するパターン（Lua pattern）
        local show_parent_patterns = {
          "^index%..+", -- index.ts, index.d.ts など
          "^init%.[^.]+$", -- init.ts, init.lua など
          "^page%.[^.]+$", -- Next.js: page.tsx
          "^layout%.[^.]+$", -- Next.js: layout.tsx
          "^route%.[^.]+$", -- Next.js: route.ts
          "^loading%.[^.]+$", -- Next.js: loading.tsx
          "^error%.[^.]+$", -- Next.js: error.tsx
          "^not%-found%.[^.]+$", -- Next.js: not-found.tsx
          "^template%.[^.]+$", -- Next.js: template.tsx
          "^default%.[^.]+$", -- Next.js: default.tsx
          "^middleware%.[^.]+$", -- Next.js: middleware.ts
          "^package%.json$", -- package.json
          "^tsconfig%.json$", -- tsconfig.json
          ".*%.config%.[^.]+$", -- *.config.ts, *.config.js など
        }

        local function should_show_parent(name)
          for _, pattern in ipairs(show_parent_patterns) do
            if name:match(pattern) then
              return true
            end
          end
          return false
        end

        local display_name = filename
        if should_show_parent(filename) then
          local parent = vim.fn.fnamemodify(bufname, ":h:t")
          if parent and parent ~= "" and parent ~= "." then
            display_name = parent .. "/" .. filename
          end
        end

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
          { ft_icon .. " ", group = ft_hl },
          {
            display_name .. " ",
            gui = vim.bo[props.buf].modified and "bold,italic" or "bold",
            guifg = vim.bo[props.buf].modified and "#ffbc94" or "#FFFFFF",
          },
        }
      end,
    },
  },

  -- ステータスバー
  {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    cond = function()
      return not vim.env.OVIM_SESSION_ID
    end,
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
        inactive_sections = {},
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

  {
    "nabekou29/pair-lens.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.api.nvim_set_hl(0, "PairLensVirtualText", { fg = "#3b5f6f" })
      vim.api.nvim_set_hl(0, "PairLensVirtualTextNum", { fg = "#3b5f6f", bold = true })
      vim.api.nvim_set_hl(0, "PairLensVirtualTextCode", { fg = "#3b5f6f", italic = true, underline = true })
    end,
    opts = {
      style = {
        -- format = "󰶢 ({line_count}:{start_line}-{end_line}) {start_text}",
        format = function(info)
          local line_info = string.format("(%d:%d-%d) ", info.line_count, info.start_line, info.end_line)
          local start_text = info.start_text
          return {
            { "󰶢 ", "PairLensVirtualText" },
            { line_info, "PairLensVirtualTextNum" },
            { start_text, "PairLensVirtualTextCode" },
          }
        end,
      },
      disable_filetypes = {},
      custom_queries = {},
      min_lines = 12,
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
        diagnostics_hint_symbol = "●",
        diagnostics_info_symbol = "●",
        diagnostics_warn_symbol = "●",
        diagnostics_error_symbol = "●",
      }
    end,
  },

  -- LSP の起動状況などを右下に表示
  {
    "j-hui/fidget.nvim",
    event = { "VeryLazy" },
    config = function()
      -- Highlight を定義
      vim.cmd([[ hi FidgetNormal guifg=#ccc guibg=#3777bd ]])

      require("fidget").setup({
        notification = {
          window = { normal_hl = "FidgetNormal", winblend = 80, border = "single" },
        },
        integration = {
          ["nvim-tree"] = {
            enable = false,
          },
        },
      })
    end,
  },
}
