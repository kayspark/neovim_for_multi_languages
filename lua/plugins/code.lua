local home = vim.fn.expand("$HOME")

return {
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "cat " .. home .. "/chatgpt_key.txt",
        -- api_key_cmd = "gpg --decrypt " .. home .. "/chatgpt_key.txt.gpg",
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  -- add toggleterm
  { "akinsho/toggleterm.nvim", config = true },
  -- nvim-nio
  { "nvim-neotest/nvim-nio" },
}
