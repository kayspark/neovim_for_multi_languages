return {
  {
    "simrat39/rust-tools.nvim",
    keys = {
      --  { "<leader>K", "<cmd>RustOpenExternalDocs<Cr>", desc = "RustOpenExternalDocs" },
      { "<leader>Rr", "<cmd>RustRunnables<Cr>", desc = "Runnables" },
      { "<leader>Rt", "<cmd>lua _CARGO_TEST()<cr>", desc = "Cargo Test" },
      { "<leader>Rm", "<cmd>RustExpandMacro<Cr>", desc = "Expand Macro" },
      { "<leader>Rc", "<cmd>RustOpenCargo<Cr>", desc = "Open Cargo" },
      { "<leader>Rp", "<cmd>RustParentModule<Cr>", desc = "Parent Module" },
      { "<leader>Rd", "<cmd>RustDebuggables<Cr>", desc = "Debuggables" },
      { "<leader>Rv", "<cmd>RustViewCrateGraph<Cr>", desc = "View Crate Graph" },
      {
        "<leader>RR",
        "<cmd>lua require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml()<Cr>",
        desc = "Reload Workspace",
      },
      { "<leader>Ro", "<cmd>RustOpenExternalDocs<Cr>", desc = "Open External Docs" },
      { "<leader>Ry", "<cmd>lua require'crates'.open_repository()<cr>", desc = "[crates] open repository" },
      { "<leader>RP", "<cmd>lua require'crates'.show_popup()<cr>", desc = "[crates] show popup" },
      { "<leader>Ri", "<cmd>lua require'crates'.show_crate_popup()<cr>", desc = "[crates] show info" },
      { "<leader>Rf", "<cmd>lua require'crates'.show_features_popup()<cr>", desc = "[crates] show features" },
      { "<leader>RD", "<cmd>lua require'crates'.show_dependencies_popup()<cr>", desc = "[crates] show dependencies" },
    },
    config = function()
      require("rust-tools").setup({
        tools = {
          executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
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
        dap = {
          adapter = {
            type = "server",
            port = "${port}",
            executable = {
              command = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/") .. "bin/codelldb",
              args = { "--port", "${port}" },
              -- On windows you may have to uncomment this:
              -- detached = false,
            },
          },
        },
        server = {
          on_attach = function(client, bufnr)
            require("lvim.lsp").common_on_attach(client, bufnr)
            local rt = require("rust-tools")
            vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
          end,

          capabilities = require("lvim.lsp").common_capabilities(),
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
      })
    end,
  },
  {
    "saecki/crates.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
        popup = {
          border = "rounded",
        },
      })
    end,
  },
}
