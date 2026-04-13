return {
  {
    "kayspark/nvim-nepes",
    name = "nepes",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      theme = "dark",
    },
    config = function(_, opts)
      require("nepes").setup(opts)
      vim.cmd.colorscheme("nepes")
    end,
  },
}
