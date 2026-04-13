return {
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      dashboard = { enabled = false },
      picker = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      words = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      notifier = { enabled = true },
      bigfile = { enabled = true },
      statuscolumn = { enabled = true },
      input = { enabled = true },
      scroll = { enabled = false },
    },
    keys = {
      { "<leader>ff", function() require("snacks").picker.files() end, desc = "Find files" },
      { "<leader>fg", function() require("snacks").picker.grep() end, desc = "Grep" },
      { "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() require("snacks").picker.help() end, desc = "Help" },
      { "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent files" },
      { "<leader>e", function() require("snacks").explorer() end, desc = "File explorer" },
    },
  },
}
