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
        "graphql",
        "lua_ls",
        "stylelua",
        "ruff_lsp",
        "shellcheck",
        "shfmt",
        "svelte-language-server",
        "vue-language-server",
        "sqlfluff",
        "sqls",
        "sqlls",
        "yamlls",
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    enabled = false,
    opts = function(_, opts)
      local nls = require("none-ls")
      opts.root_dir = opts.root_dir
        or require("none-ls.utils").root_pattern(".none-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend({
        -- nls.builtins.code_actions.ltrs,
        nls.builtins.code_actions.gitsigns,
        nls.builtins.code_actions.refactoring,
        nls.builtins.formatting.cbfmt,
        nls.builtins.formatting.clang_format,
        nls.builtins.formatting.fish_indent,
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.mdformat,
        nls.builtins.formatting.stylelua,
        nls.builtins.formatting.prettier,
        nls.builtins.formatting.sqlfluff.with({
          extra_args = { "fix --dialect", "oracle" }, -- change to your dialect
        }),
        nls.builtins.diagnostics.shellcheck,
      }, opts.sources or {})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "pmizio/typescript-tools.nvim",
      "nanotee/sqls.nvim",
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      inlay_hints = {
        enabled = true,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        eslint = {},
        volar = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
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
          on_attach = function(client, _)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.executeCommand = true
            require("sqls").on_attach(client, _)
          end,
        },
      },
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
        tsserver = function(_, opts)
          local neoconf = require("neoconf")
          local lspconfig = require("lspconfig")
          local root_dir = lspconfig.util.root_pattern("src/App.vue")
          if neoconf.get("is-volar-project") or root_dir() then
            lspconfig["volar"].setup({
              server = opts,
              settings = {},
            })

            require("typescript-tools").setup({
              server = opts,
              settings = {
                tsserver_plugins = {
                  "@vue/typescript-plugin",
                },
              },
              filetypes = {
                "javascript",
                "typescript",
              },
            })
          else
            require("typescript-tools").setup({
              server = opts,
            })
          end
          return true
        end,
      },
    },
  },
}
