return {
  --   {
  --     "rebelot/kanagawa.nvim",
  --     --    "folke/tokyonight.nvim",
  --     opts = {
  --       transparent = true,
  --       styles = {
  --         sidebars = "transparent",
  --         floats = "transparent",
  --       },
  --     },
  --   },
  {
    -- https://github.com/catppuccin/nvim
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      transparent_background = true,
      integrations = {
        notify = true,
        noice = true,
        neotree = true,
        cmp = true,
        mini = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "catppuccin-frappe"
    end,
  },
}
