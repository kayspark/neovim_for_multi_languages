return {

  -- {
  --   "kylechui/nvim-surround",
  --   version = "*", -- Use for stability; omit to use `main` branch for the latest features
  --   event = "VeryLazy",
  --   config = function()
  --     require("nvim-surround").setup({
  --       -- Configuration here, or leave empty to use defaults
  --     })
  --   end,
  -- },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "sd",
        delete = "sx",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "ss",
        update_n_lines = "sn",
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            vim.cmd.cprev()
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.cmd.cnext()
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
  -- {
  --   "ThePrimeagen/refactoring.nvim",
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim" },
  --     { "nvim-treesitter/nvim-treesitter" },
  --   },
  -- },
  -- {
  --   "ThePrimeagen/harpoon",
  --   dependencies = "nvim-lua/plenary.nvim",
  --   opts = {
  --     global_settings = { mark_branch = true },
  --     width = vim.api.nvim_win_get_width(0) - 4,
  --   },
  --   keys = {
  --     -- harpoon
  --     { "<leader>a", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add to Harpoon" },
  --     { "<leader>0", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Show Harpoon" },
  --     { "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "Harpoon Buffer 1" },
  --     { "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "Harpoon Buffer 2" },
  --     { "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "Harpoon Buffer 3" },
  --     { "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "Harpoon Buffer 4" },
  --     { "<leader>5", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", desc = "Harpoon Buffer 5" },
  --     -- {"<leader>6", "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", { desc = "Harpoon Buffer 6" }},
  --     -- {"<leader>7", "<cmd>lua require('harpoon.ui').nav_file(7)<cr>", { desc = "Harpoon Buffer 7" }},
  --     -- {"<leader>8", "<cmd>lua require('harpoon.ui').nav_file(8)<cr>", { desc = "Harpoon Buffer 8" }},
  --     -- {"<leader>9", "<cmd>lua require('harpoon.ui').nav_file(9)<cr>", { desc = "Harpoon Buffer 9" }},
  --   },
  -- },
  -- add more treesitter parsers
  -- {
  --   "mrshmllow/orgmode-babel.nvim",
  --   dependencies = {
  --     "nvim-orgmode/orgmode",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   cmd = { "OrgExecute", "OrgTangle" },
  --   opts = {
  --     -- by default, none are enabled
  --     langs = { "python", "lua", "cpp"},

  --     -- paths to emacs packages to additionally load
  --   },
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "html",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "markdown",
        "mermaid",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "tsx",
        "toml",
        "typescript",
        "svelte",
        "vim",
        "org",
        "yaml",
      },
    },
  },
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
