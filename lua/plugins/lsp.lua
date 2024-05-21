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
        "css-lsp",
        "flake8",
        "fish",
        "fish_indent",
        "graphql",
        "java-language-server",
        "jdtls",
        "lua_ls",
        "pyright",
        "stylelua",
        "ruff_lsp",
        "shellcheck",
        "shfmt",
        "svelte-language-server",
        "vue-language-server",
        "r-language-server",
        "sqlfluff",
        "sqls",
        "yamlls",
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
      servers = {
        jdtls = {},
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
          if neoconf.get("is-volar-project") then
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
