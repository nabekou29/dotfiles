return {
  {
    'rmagatti/session-lens',
    lazy = false,
    dependencies = { {
      'rmagatti/auto-session',
      config = function()
        require("auto-session").setup {
          log_level = "error",
          auto_session_suppress_dirs = { "~/", "~/Downloads", "/" }
        }
      end
    }, 'nvim-telescope/telescope.nvim' },
    config = function()
      require('session-lens').setup({ --[[your custom config--]] })
    end
  } }
