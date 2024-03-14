return {
  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "cbfmt",
        "clang-format",
        "codelldb",
        "jdtls",
        "css-lsp",
        "flake8",
        "fish",
        "fish_indent",
        "lua_ls",
        "luacheck",
        "ruff_lsp",
        "selene",
        "shellcheck",
        "shfmt",
        "sqlfluff",
        "sqls",
        "stylua",
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend({
        nls.builtins.code_actions.gitrebase,
        nls.builtins.code_actions.gitsigns.with({
          config = {
            filter_actions = function(title)
              return title:lower():match("blame") == nil -- filter out blame actions
            end,
          },
        }),
        -- nls.builtins.code_actions.ltrs,
        nls.builtins.formatting.cbfmt,
        nls.builtins.formatting.clang_format,
        nls.builtins.formatting.fish_indent,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.sqlfluff.with({
          extra_args = { "fix --dialect", "oracle" }, -- change to your dialect
        }),
        nls.builtins.diagnostics.fish,
      }, opts.sources or {})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nanotee/sqls.nvim",
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 2,
          source = "if_many",
          prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = require("lazyvim.config").icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = require("lazyvim.config").icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = require("lazyvim.config").icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = require("lazyvim.config").icons.diagnostics.Info,
          },
        },
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {},
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        sqls = {
          cmd = { "sqls" },
          filetypes = { "sql", "oracle" },
          root_dir = function(fname)
            return require("lspconfig/util").find_git_ancestor(fname) or vim.fn.getcwd()
          end,
          deprecate = {
            to = "sqlls",
            version = "0.2.0",
          },
        },
        setup = {
          sqls = function()
            require("lazyvim.util").lsp.on_attach(function(client, _)
              if client.name == "sqls" then
                client.server_capabilities.documentFormattingProvider = false
                require("sqls").on_attach(client, _)
              end
            end)
          end,
        },
      },
    },
  },
}
