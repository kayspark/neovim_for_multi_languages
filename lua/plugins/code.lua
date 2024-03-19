local home = vim.fn.expand("$HOME")

return {
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "cat " .. home .. "/chatgpt_key.txt",
        --   api_key_cmd = "gpg --decrypt " .. home .. "/chatgpt_key.txt.gpg",
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  -- {
  --   "simrat39/outline.nvim",
  --   cmd = "outline",
  --   keys = { { "<leader>cs", "<cmd>outline<cr>", desc = "Symbols Outline" } },
  --   config = true,
  -- },
  -- add toggleterm
  { "akinsho/toggleterm.nvim", config = true },
  -- nvim-nio
  { "nvim-neotest/nvim-nio" },
}
