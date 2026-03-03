-- Smart pane navigation: seamless C-h/j/k/l across Neovim splits and WezTerm panes.
-- Replaces vim-tmux-navigator — smart-splits.nvim natively supports WezTerm mux.
return {
  "mrjones2014/smart-splits.nvim",
  lazy = false, -- must not lazy-load for WezTerm integration
  opts = {
    at_edge = "stop",
  },
  keys = {
    { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left split/pane" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to below split/pane" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to above split/pane" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split/pane" },
    { "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize left" },
    { "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize down" },
    { "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize up" },
    { "<A-l>", function() require("smart-splits").resize_right() end, desc = "Resize right" },
  },
}
