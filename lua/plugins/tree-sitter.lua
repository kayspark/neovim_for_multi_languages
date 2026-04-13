vim.filetype.add({
  filename = {
    ["envrc"] = "bash",
  },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          require("nvim-treesitter-textobjects").setup({
            select = { lookahead = true },
          })
        end,
      },
    },
    config = function()
      -- New nvim-treesitter (main branch) — highlight/indent are native Neovim 0.12
      require("nvim-treesitter").install({
        "bash", "c", "cpp", "fish", "html", "java",
        "javascript", "json", "lua", "kdl",
        "markdown", "markdown_inline", "mermaid",
        "python", "query", "regex", "rust", "sql",
        "svelte", "toml", "tsx", "typescript",
        "vim", "vimdoc", "yaml",
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
