return {
  "nvim-neotest/neotest",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
    { "nvim-neotest/neotest-vim-test", dependencies = { "vim-test/vim-test" } },
  },
  init = function()
    -- test nearest
    vim.keymap.set('n', '<leader>tt',
      function() require("neotest").run.run() end,
      { desc = "Run test" })
    -- vim.keymap.set('n', '<leader>tT', function()
    --     require("neotest").run.run({strategy = "dap"})
    -- end, {desc = "Run test with DAP"})
    -- test file
    vim.keymap.set('n', '<leader>tf', function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "Run test file" })
    -- vim.keymap.set('n', '<leader>tF', function()
    --     require("neotest").run
    --         .run(vim.fn.expand("%"), {strategy = "dap"})

    vim.keymap.set('n', '<leader>tl',
      function()
        require("neotest").run.run_last()
      end, { desc = "Run last test" })
    -- vim.keymap.set('n', '<leader>tL', function()
    --     require("neotest").run.run_last({strategy = "dap"})
    -- end, {desc = "Run last test with DAP"})
    -- other
    vim.keymap.set('n', '<leader>ts',
      function()
        require("neotest").summary.toggle()
      end, { desc = "Toggle test summary" })
    vim.keymap.set('n', '<leader>to', function()
      require("neotest").output_panel.toggle()
    end, { desc = "Toggle test output" })
  end,
  config = function()
    require('neotest').setup({
      adapter = {
        -- require("neotest-vitest")({
        --   vitestCommand = "pnpm vitest",
        --   vitestConfigFile = "vitest.config.ts"
        -- }),
        require("neotest-vitest"),
        require("neotest-vim-test")({
          -- ignore_file_types = { "python", "vim", "lua" },
        })
      }
    })
  end
}
