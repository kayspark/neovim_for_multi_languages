return {
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neoconf.nvim" },
      {
        "simrat39/rust-tools.nvim",
        keys = {
          --  { "<leader>K", "<cmd>RustOpenExternalDocs<Cr>", desc = "RustOpenExternalDocs" },
          { "<leader>cRr", "<cmd>RustRunnables<Cr>", desc = "Runnables" },
          { "<leader>cRt", "<cmd>lua _CARGO_TEST()<cr>", desc = "Cargo Test" },
          { "<leader>cRm", "<cmd>RustExpandMacro<Cr>", desc = "Expand Macro" },
          { "<leader>cRc", "<cmd>RustOpenCargo<Cr>", desc = "Open Cargo" },
          { "<leader>cRp", "<cmd>RustParentModule<Cr>", desc = "Parent Module" },
          { "<leader>cRd", "<cmd>RustDebuggables<Cr>", desc = "Debuggables" },
          { "<leader>cRv", "<cmd>RustViewCrateGraph<Cr>", desc = "View Crate Graph" },
        },

        init = function()
          require("lazyvim.util").on_attach(function(_, bufnr)
            -- stylua: ignore
            vim.keymap.set("n", "<leader>ch", require("rust-tools").hover_actions.hover_actions, { buffer = bufnr })
          end)
        end,
        opts = {
          tools = {
            --executor = require("rust-tools/executors").quickfix, -- can be quickfix or termopen
            reload_workspace_from_cargo_toml = true,
            runnables = {
              use_telescope = true,
            },
            inlay_hints = {
              auto = true,
              only_current_line = false,
              show_parameter_hints = false,
              parameter_hints_prefix = "<-",
              other_hints_prefix = "=>",
              max_len_align = false,
              max_len_align_padding = 1,
              right_align = false,
              right_align_padding = 7,
              highlight = "Comment",
            },
            hover_actions = {
              border = "rounded",
            },
            on_initialized = function()
              vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
                pattern = { "*.rs" },
                callback = function()
                  local _, _ = pcall(vim.lsp.codelens.refresh)
                end,
              })
            end,
          },
        },
      },
      {
        "saecki/crates.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },

        keys = {
          --  { "<leader>K", "<cmd>RustOpenExternalDocs<Cr>", desc = "RustOpenExternalDocs" },
          { "<leader>cRy", "<cmd>lua require'crates'.open_repository()<cr>", desc = "[crates] open repository" },
          { "<leader>cRP", "<cmd>lua require'crates'.show_popup()<cr>", desc = "[crates] show popup" },
          { "<leader>cRi", "<cmd>lua require'crates'.show_crate_popup()<cr>", desc = "[crates] show info" },
          { "<leader>cRf", "<cmd>lua require'crates'.show_features_popup()<cr>", desc = "[crates] show features" },
          {
            "<leader>cRD",
            "<cmd>lua require'crates'.show_dependencies_popup()<cr>",
            desc = "[crates] show dependencies",
          },
        },
        config = function()
          require("crates").setup()
        end,
      },
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        rust_analyzer = {
          cmd = { "rust-analyzer" },
          settings = {
            ["rust-analyzer"] = {
              lens = {
                enable = true,
              },
              checkOnSave = {
                enable = true,
                command = "clippy",
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        rust_analyzer = function(_, opts)
          require("rust-tools").setup(opts)
          --vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = buffer })
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
}
