return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gg", false },
      { "<leader>gG", false },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    opts = {
      signs = {
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
      integrations = {
        diffview = true,
      },
    },
    keys = {
      { "<leader>gc", "<cmd>lua require('neogit').open({'commit'})<CR>", desc = "Neogit commit" },
      { "<leader>gg", "<cmd>lua require('neogit').open()<CR>", desc = "Neogit status" },
    },
  },
}
