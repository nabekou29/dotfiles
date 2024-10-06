return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
      { "nvim-neotest/neotest-vim-test", dependencies = { "vim-test/vim-test" } },
    },
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        mode = "n",
        desc = "Run test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        mode = "n",
        desc = "Run test file",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        mode = "n",
        desc = "Run last test",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        mode = "n",
        desc = "Toggle test summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        mode = "n",
        desc = "Toggle test output",
      },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-vitest")({
            vitestCommand = "pnpm vitest",
            vitestConfigFile = function()
              return nil
            end,
          }),
        },
      }
    end,
  },
}
