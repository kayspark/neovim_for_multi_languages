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
  {
    "nvim-orgmode/orgmode",
    commit = "2cb04d704de2e205bdd0b52179d392c18bfad5be",
    lazy = false,
    ft = "org",
    config = function()
      require("orgmode").setup_ts_grammar()
      require("orgmode").setup({
        org_todo_keywords = { "🟡(t)", "🟢(p)", "🔴(h)", "|", "☑️(d)", "🟠(w)" },
        org_todo_keyword_faces = {
          --        DELEGATED = ':background #FFFFFF :slant italic :underline on',
          TODO = ":background #000000 :foreground #E78284", -- overrides builtin color for `TODO` keyword
        },
        mappings = {
          text_objects = {
            inner_heading = "ic",
            around_heading = "ac",
            inner_subtree = "is",
            around_subtree = "as",
            inner_heading_from_root = "iC",
            around_heading_from_root = "aC",
            inner_subtree_from_root = "iS",
            around_subtree_from_root = "aS",
          },
        },
        org_agenda_files = { "~/Org/*.org", "~/Org/org-roam/**/*" },
        org_default_notes_file = "~/Org/notes.org",
        org_capture_templates = {
          T = {
            description = "Todo",
            template = "* 🟡 %?\n %u",
            target = "~/Org/todo.org",
          },
          n = {
            description = "Notes",
            template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
            target = "~/Org/notes.org",
          },
        },
      })
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        event = "BufReadPost",
        opts = function(_, opts)
          -- add tsx and treesitter
          vim.list_extend(opts.ensure_installed, { "org" })
          opts.highlight = {
            enable = true,
            -- Required for spellcheck, some LaTex highlights and
            -- code block highlights that do not have ts grammar
            additional_vim_regex_highlighting = { "org" },
          }
        end,
      },
    },
  },
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
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "tsx",
        "toml",
        "typescript",
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
