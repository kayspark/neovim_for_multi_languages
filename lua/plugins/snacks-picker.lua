return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      picker = { enabled = true },
      explorer = { enabled = true },
    },
  },
  -- disable telescope (snacks replaces it)
  { "nvim-telescope/telescope.nvim", enabled = false },
  { "nvim-telescope/telescope-fzf-native.nvim", enabled = false },
}
