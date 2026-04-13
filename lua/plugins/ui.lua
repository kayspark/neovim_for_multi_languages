return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {},
    keys = {
      { "<leader>sr", "<cmd>GrugFar<cr>", desc = "Search and replace" },
    },
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
}
