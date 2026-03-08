-- Smart pane navigation: seamless C-h/j/k/l across Neovim splits and terminal panes.
-- Supports WezTerm + Kitty + tmux (auto-detected at runtime).
return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  opts = function()
    local mux = nil -- auto-detect
    if vim.env.KITTY_PID then
      mux = "kitty"
    elseif vim.env.TERM_PROGRAM == "WezTerm" then
      mux = "wezterm"
    elseif vim.env.TMUX then
      mux = "tmux"
    end
    return {
      at_edge = "stop",
      multiplexer_integration = mux,
    }
  end,
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
