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
  -- {
  --   "phha/zenburn.nvim",
  --   name = "zenburn",
  --   opts = {
  --     transparent_background = true,
  --     lualine = true,
  --   },
  -- },
  {
    -- https://github.com/catppuccin/nvim
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flabor = "mocha",
      transparent_background = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    build = ":KanagawaCompile",
    opts = {
      compile = true,
      transparent = true,
      dimInactive = false,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
              float = {
                bg = "none",
                bg_border = "none",
                fg_border = "none",
                fg = "none",
              },
            },
          },
        },
      },
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "kanagawa"
    end,
  },
}
