return {
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
}
