-- cSpell:words gitsigns nvim topdelete changedelete keymap stylua diffthis
return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  keys = {
    -- git hunk navigation - previous / next
    { "]g", ":Gitsigns next_hunk<CR>", desc = "Goto next git hunk" },
    { "[g", ":Gitsigns prev_hunk<CR>", desc = "Goto previous git hunk" },
    { "gS", ":Gitsigns stage_buffer<CR>", desc = "Stage Buffer" },
    { "gx", ":Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
    { "gs", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
    { "gX", ":Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
    { "gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Hunk" },
    { "gh", ":Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
  },
}
