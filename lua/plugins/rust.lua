if true then
  return {}
end

local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
local codelldb_adapter = {
  type = "server",
  port = "${port}",
  executable = {
    command = mason_path .. "bin/codelldb",
    args = { "--port", "${port}" },
    -- On windows you may have to uncomment this:
    -- detached = false,
  },
}

local opts = {
  tools = {
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
    dap = {
      adapter = codelldb_adapter,
    },
    server = {
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
}

return {
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "folke/neoconf.nvim",
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
    config = function()
      require("rust-tools").setup(opts)
    end,
    init = function()
      require("lazyvim.util").on_attach(function(_, bufnr)
        -- stylua: ignore
        vim.keymap.set("n", "<leader>ch", require("rust-tools").hover_actions.hover_actions, { buffer = bufnr })
      end)
    end,
  },
}
