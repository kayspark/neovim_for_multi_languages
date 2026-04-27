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
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gvdiffsplit", "Glog", "Gread", "Gwrite" },
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Fugitive status" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Fugitive commit" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Fugitive blame" },
      { "<leader>gl", "<cmd>Git log --oneline<cr>", desc = "Fugitive log" },
    },
  },
  {
    "sindrets/diffview.nvim",
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
