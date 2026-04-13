-- Native Neovim 0.12+ LSP completion (replaces blink.cmp)
return {
  -- Disable blink.cmp (LazyVim default)
  { "saghen/blink.cmp", enabled = false },

  -- Enable native LSP completion via LspAttach
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("native_lsp_completion", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
              autotrigger = true,
            })
          end
        end,
      })
    end,
  },
}
