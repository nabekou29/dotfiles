return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "tkmpypy/chowcho.nvim",
      "adelarsq/image_preview.nvim",
    },
    keys = {
      { "<leader>e", "<Cmd>Neotree position=float focus<CR>" },
      { "<leader>E", "<Cmd>Neotree position=left focus<CR>" },
      { "<C-1>", "<Cmd>Neotree source=filesystem reveal=true <CR>" },
      { "<C-2>", "<Cmd>Neotree source=buffers focus<CR>" },
      { "<C-3>", "<Cmd>Neotree source=git_status focus<CR>" },
    },
    opts = {
      source_selector = {
        winbar = true,
        statusline = true,
      },
      window = {
        position = "float",
        mappings = {
          ["w"] = "custom_open_with_window_picker",
          ["<right>"] = "toggle_node",
          ["<space>"] = {
            "toggle_node",
            nowait = true, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
        },
      },
      commands = {
        custom_open_with_window_picker = function(state)
          local chowcho = require("chowcho")

          local tree = state.tree
          local node = tree:get_node()
          local path = node.path

          chowcho.run(function(window)
            -- ファイルを開く
            vim.api.nvim_set_current_win(window)
            vim.api.nvim_command("edit " .. path)
          end)
        end,
      },
      nesting_rules = {
        ["package.json"] = {
          pattern = "^package%.json$", -- <-- Lua pattern
          files = { "package-lock.json", "pnpm*" }, -- <-- glob pattern
        },
        ["tsx"] = {
          "spec.tsx",
          "test.tsx",
          "stories.tsx",
          "spec.ts",
          "test.ts",
          "stories.ts",
        },
        ["ts"] = {
          "spec.tsx",
          "test.tsx",
          "stories.tsx",
          "spec.ts",
          "test.ts",
          "stories.ts",
        },
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    requires = { "kyazdani42/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<Cmd>NvimTreeToggle<CR>" },
      { "<leader>E", "<Cmd>NvimTreeFindFile<CR>" },
      { "<C-1>", "<Cmd>NvimTreeFindFile<CR>" },
    },
    opts = function()
      vim.api.nvim_set_hl(0, "@nvim-tree-decorator.test-file", { fg = "#6c6c6c" })

      local grouping_regexps = {
        "(.*)_",
      }

      local Decorator = require("nvim-tree.api").decorator.UserDecorator:extend()
      function Decorator:new()
        self.enabled = true
        self.highlight_range = "all"
      end

      function Decorator:highlight_group(node)
        local name = node.name
        if name:match("_test") or name:match("%.test") or name:match("_spec") or name:match("%.spec") or name:match("%.stories") then
          return "@nvim-tree-decorator.test-file"
        end
        return nil
      end

      return {
        disable_netrw = true,
        hijack_netrw = true,
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        view = {
          float = {
            enable = true,
            open_win_config = function()
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * 0.5
              local window_h = screen_h * 0.9
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
              return {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
          width = function()
            return math.floor(vim.opt.columns:get() * 0.5)
          end,
        },
        renderer = {
          special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
          decorators = {
            "Git",
            "Open",
            "Hidden",
            "Modified",
            "Bookmark",
            "Diagnostics",
            Decorator,
            "Copied",
            "Cut",
          },
          group_empty = true,
        },
        sort = {
          folders_first = true,
          sorter = function(nodes)
            -- _test や .test を削って比較する
            local remove_test = function(name)
              return name:gsub("(.*)_test", "%1"):gsub("(.*)%.test", "%1"):gsub("(.*)_spec", "%1"):gsub("(.*)%.spec", "%1"):gsub("(.*)%.stories", "%1")
            end
            table.sort(nodes, function(a, b)
              if a.type ~= b.type then
                -- ディレクトリを先に表示
                return a.type < b.type
              end

              local a_original_name = a.name
              local b_original_name = b.name
              local a_name = remove_test(a_original_name)
              local b_name = remove_test(b_original_name)

              if a_name == b_name then
                return #a_original_name <= #b_original_name
              else
                return a_name <= b_name
              end
            end)
          end,
        },
        actions = {
          open_file = {
            window_picker = {
              picker = function()
                local async = require("plenary.async")
                local chowcho_run = async.wrap(require("chowcho").run, 1)
                local win = nil
                async.util.block_on(function()
                  win = chowcho_run()
                end)
                return win
              end,
            },
          },
        },
      }
    end,
  },

  {
    "A7Lavinraj/fyler.nvim",
    enabled = false,
    event = { "VeryLazy" },
    keys = {
      { "<leader>e", "<Cmd>Fyler<CR>" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      icon_provider = "nvim-web-devicons",
    },
  },

  {
    "stevearc/oil.nvim",
    event = { "BufReadPre" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  {
    "rgroli/other.nvim",
    main = "other-nvim",
    cmd = { "Other", "OtherTabNew", "OtherVsplit", "OtherSplit", "OtherClear" },
    keys = {
      { "<leader>ll", "<Cmd>Other<CR>" },
      { "<leader>lL", "<Cmd>OtherClear<CR><Cmd>Other<CR>" },
      { "<leader>li", "<Cmd>Other impl<CR>" },
      { "<leader>lt", "<Cmd>Other test<CR>" },
      { "<leader>ls", "<Cmd>Other stories<CR>" },
      { "<leader>lc", "<Cmd>Other css<CR>" },
    },
    opts = {
      showMissingFiles = false,
      mappings = {
        -- js, ts
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).*.([jt]sx?)$",
          target = {
            { target = "/%1/%2/%3.test.%4", context = "test" },
          },
        },
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).test.([jt]sx?)$",
          target = {
            { target = "/%1/%2/%3.%4", context = "impl" },
          },
        },
        -- ts, tsx
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).*.([jt]sx)$",
          target = {
            { target = "/%1/%2/%3.stories.%4", context = "stories" },
            { target = "/%1/%2/%3.module.scss", context = "css" },
          },
        },
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).test.([jt]sx)$",
          target = {
            { target = "/%1/%2/%3.%4", context = "impl" },
            { target = "/%1/%2/%3.module.scss", context = "css" },
            { target = "/%1/%2/%3.stories.tsx", context = "stories" },
          },
        },
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).stories.*$",
          target = {
            { target = "/%1/%2/%3.tsx", context = "impl" },
            { target = "/%1/%2/%3.test.tsx", context = "test" },
            { target = "/%1/%2/%3.module.scss", context = "css" },
          },
        },
        {
          pattern = "/(.*)/(.*)/([a-zA-Z-_]*).module.scss$",
          target = {
            { target = "/%1/%2/%3.tsx", context = "impl" },
            { target = "/%1/%2/%3.test.tsx", context = "test" },
            { target = "/%1/%2/%3.stories.tsx", context = "stories" },
          },
        },
      },
      style = {
        border = "rounded",
      },
    },
  },
}
