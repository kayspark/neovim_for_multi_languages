return {
  -- add any tools you want to have installed below
  --
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "sqls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "pmizio/typescript-tools.nvim",
      "nanotee/sqls.nvim",
    },
    opts = {
      -- options for vim.diagnostic.config()
      inlay_hints = {
        enabled = true,
      },
      sqls = {
        cmd = { "sqls" },
        filetypes = { "sql", "oracle" },
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.executeCommand = true
          require("sqls").on_attach(client, _)
        end,
      },
    },
  },
}
