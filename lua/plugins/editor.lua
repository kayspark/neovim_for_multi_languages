return {
  --  {
  --    "kylechui/nvim-surround",
  --    event = "VeryLazy",
  --    config = function()
  --      require("nvim-surround").setup({
  --        -- Configuration here, or leave empty to use defaults
  --      })
  --    end,
  --  },
  -- { "tris203/precognition.nvim", config = {} },
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        },
        presets = {
          operators = false, -- adds help for operators like d, y, ...
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
    },
  },
}
