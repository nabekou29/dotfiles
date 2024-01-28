return {
  "folke/trouble.nvim",
  event = { "VeryLazy" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.keymap.set("n", "<leader>xx", function()
      require("trouble").toggle()
    end, {

      silent = true,
      noremap = true,
      desc = ':TroubleToggle'
    })
    vim.keymap.set("n", "<leader>xX", function()
      require("trouble").toggle('workspace_diagnostics')
    end, {
      silent = true,
      noremap = true,
      desc = ':TroubleToggle workspace_diagnostics'
    })
    vim.keymap.set("n", "<leader>xd", function()
      require("trouble").toggle('document_diagnostics')
    end, {
      silent = true,
      noremap = true,
      desc = ':TroubleToggle document_diagnostics'
    })
    vim.keymap.set("n", "<leader>xl",
      function()
        require("trouble").toggle('loclist')
      end, {
        silent = true,
        noremap = true,
        desc = ':TroubleToggle loclist'
      })
    vim.keymap.set("n", "<leader>xq", function()
      require("trouble").toggle('quickfix')
    end, {
      silent = true,
      noremap = true,
      desc = ':TroubleToggle quickfix'
    })
    vim.keymap.set("n", "gR", function()
      require("trouble").toggle('lsp_references')
    end, {
      silent = true,
      noremap = true,
      desc = ':TroubleToggle lsp_references'
    })
  end,
  config = function()
    require("trouble").setup
    {
      use_diagnostic_signs = true, -- false -- enabling this will use the signs defined in your lsp client

    }
  end
}
