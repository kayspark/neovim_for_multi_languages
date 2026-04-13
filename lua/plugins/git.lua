return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "]g", ":Gitsigns next_hunk<CR>", desc = "Goto next git hunk" },
      { "[g", ":Gitsigns prev_hunk<CR>", desc = "Goto previous git hunk" },
      { "gS", ":Gitsigns stage_buffer<CR>", desc = "Stage Buffer" },
      { "gx", ":Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
      { "gs", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
      { "gX", ":Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
      { "gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Hunk" },
      { "gh", ":Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    opts = {
      signs = {
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
      integrations = {
        diffview = true,
      },
    },
    keys = {
      { "<leader>gc", "<cmd>lua require('neogit').open({'commit'})<CR>", desc = "Neogit commit" },
      { "<leader>gg", "<cmd>lua require('neogit').open()<CR>", desc = "Neogit status" },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    opts = {
      file_panel = {
        position = "bottom",
        height = 20,
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
    },
  },
}
