return {
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPre",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
