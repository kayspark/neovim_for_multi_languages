return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      ["fish"] = { "fish_indent" },
      ["sql"] = { "sqlfluff" },
      ["sh"] = { "shfmt" },
      ["lua"] = { "stylua" },
      ["rust"] = { "rustfmt" },
      ["python"] = { "black" },
      ["javascript"] = { "prettier" },
      ["javascriptreact"] = { "prettier" },
      ["typescript"] = { "prettier" },
      ["typescriptreact"] = { "prettier" },
      ["vue"] = { "prettier" },
      ["css"] = { "prettier" },
      ["scss"] = { "prettier" },
      ["less"] = { "prettier" },
      ["html"] = { "prettier" },
      ["json"] = { "prettier" },
      ["jsonc"] = { "prettier" },
      ["yaml"] = { "prettier" },
      ["markdown"] = { "prettier" },
      ["markdown.mdx"] = { "prettier" },
      ["graphql"] = { "prettier" },
      ["handlebars"] = { "prettier" },
    },
    -- Set up format-on-save
    -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
    -- Customize formatters
    formatters = {
      sqlfluff = {
        args = { "fix", "--dialect oracle" },
      },
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  },
}
