return {
  "telescope.nvim",
  dependencies = {
    {
      "piersolenski/telescope-import.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("import")
      end,
    },
    { "prochri/telescope-all-recent.nvim", opts = {} },
    {
      "debugloop/telescope-undo.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("undo")
      end,
    },
    {
      "vuki656/package-info.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("package_info")
      end,
    },
    {
      "danielfalk/smart-open.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("smart_open")
      end,
      dependencies = {
        "kkharji/sqlite.lua",
        { "nvim-telescope/telescope-fzy-native.nvim" },
      },
    },
  },
}
