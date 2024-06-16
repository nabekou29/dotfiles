return {
  {
    "tiagovla/scope.nvim",
    init = function()
      vim.opt.sessionoptions = {
        "buffers",
        "tabpages",
        "globals",
      }
    end,
    opts = {},
  },
  -- セッションの自動保存・復元
  {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = { "tiagovla/scope.nvim" },
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Downloads" },
      pre_save_cmds = {
        function()
          vim.cmd([[ScopeSaveState]])
        end,
      },
      post_restore_cmds = {
        function()
          vim.cmd([[ScopeLoadState]])
          vim.cmd([[ScopeSaveState]])
        end,
      },
    },
  },
}
