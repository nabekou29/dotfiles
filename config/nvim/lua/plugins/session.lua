return {
  {
    'rmagatti/session-lens',
    -- enabled = false,
    lazy = false,
    dependencies = {
      {
        'rmagatti/auto-session',
        dependencies = {
          {
            "tiagovla/scope.nvim",
            lazy = false,
            config = function()
              vim.opt.sessionoptions = { -- required
                "buffers",
                "tabpages",
                "globals",
              }
              require("scope").setup({})
            end
          },
        },
        init = function()
          -- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        end,
        config = function()
          require("auto-session").setup {
            log_level = "error",
            auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
            pre_save_cmds = {
              function()
                vim.cmd([[ScopeSaveState]]) -- Scope.nvim saving
              end
            },
            post_restore_cmds = {
              function()
                vim.cmd([[ScopeLoadState]]) -- Scope.nvim loading
                vim.cmd([[ScopeSaveState]])
              end
            },
          }
        end
      },
      'nvim-telescope/telescope.nvim'
    },
    config = function()
      require('session-lens').setup({ --[[your custom config--]] })
    end
  },
}
