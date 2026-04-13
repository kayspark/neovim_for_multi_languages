vim.filetype.add({
  filename = {
    ["envrc"] = "bash",
  },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "fish",
        "html",
        "java",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "kdl",
        "markdown",
        "markdown_inline",
        "mermaid",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
