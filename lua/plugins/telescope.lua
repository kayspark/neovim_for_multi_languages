return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "piersolenski/telescope-import.nvim",
      config = function()
        require("telescope").load_extension("import")
      end,
    },
    { "prochri/telescope-all-recent.nvim", opts = {} },
    {
      "debugloop/telescope-undo.nvim",
      config = function()
        require("telescope").load_extension("undo")
      end,
    },
    {
      "vuki656/package-info.nvim",
      config = function()
        require("telescope").load_extension("package_info")
      end,
    },
    {
      "joshmedeski/telescope-smart-goto.nvim",
      dependencies = {
        "ThePrimeagen/harpoon",
      },
      config = function()
        require("telescope").load_extension("smart_goto")
      end,
    },
    {
      "danielfalk/smart-open.nvim",
      branch = "0.2.x",
      config = function() end,
      dependencies = {
        "kkharji/sqlite.lua",
        { "nvim-telescope/telescope-fzy-native.nvim" },
      },
    },
  },
}
