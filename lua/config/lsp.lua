-- Native Neovim 0.12 LSP configuration
-- nvim-lspconfig provides cmd/filetypes/root_markers defaults.
-- This file adds server-specific settings and enables all servers.

-- Server-specific settings (override defaults from nvim-lspconfig)
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = function()
        return require("schemastore").json.schemas()
      end,
      validate = { enable = true },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = function()
        return require("schemastore").yaml.schemas()
      end,
    },
  },
})

-- Enable all servers
vim.lsp.enable({
  "lua_ls", "vtsls", "pyright", "bashls",
  "jsonls", "yamlls",
  "clangd", "gopls", "r_language_server", "rust_analyzer",
  "dockerls", "docker_compose_language_service",
  "ansiblels", "marksman", "sqls", "texlab",
  "tailwindcss", "eslint", "taplo",
})

-- Global LspAttach — native completion + inlay hints
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("native_lsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    -- Native completion with autotrigger
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
        autotrigger = true,
      })
    end
    -- Inlay hints
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})
