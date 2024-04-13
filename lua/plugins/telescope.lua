return {
  "telescope.nvim",
  dependencies = {
    {
      "debugloop/telescope-undo.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("undo")
      end,
    },
  },
}
