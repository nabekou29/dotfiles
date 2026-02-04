return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    keys = {
      -- stylua: ignore start
      { "<leader>ks", function() require("kulala").run() end,              desc = "Send request" },
      { "<leader>ka", function() require("kulala").run_all() end,          desc = "Send all requests" },
      { "<leader>kb", function() require("kulala").scratchpad() end,       desc = "Open scratchpad" },
      { "<leader>kr", function() require("kulala").replay() end,           desc = "Replay last request" },
      { "<leader>ke", function() require("kulala").set_selected_env() end, desc = "Select environment" },
      -- stylua: ignore end
    },
    opts = {
      global_keymaps = false,
    },
  },
}
