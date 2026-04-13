return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    -- Provides cmd/filetypes/root_markers defaults for all servers.
    -- Must load before config/lsp.lua calls vim.lsp.enable().
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
}
