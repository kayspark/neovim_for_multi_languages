return {
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "nepes"
    end,
  },
  {
    "kayspark/nvim-nepes",
    name = "nepes",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      theme = "dark",
    },
  },
}
