-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
vim.keymap.set("n", "<leader>dd", function()
  Util.float_term({ "lazydocker" }, { cwd = Util.get_root() })
end, { desc = "Lazydocker" })

-- overwrite lazyvim mappings with vim-tmux-navigator mappings
-- see: https://github.com/christoomey/vim-tmux-navigator/blob/master/plugin/tmux_navigator.vim

--vim.keymap.set("n", "<leader>;", "<cmd>Alpha<cr>", { desc = "Start page" })
-- buffer
vim.keymap.set("n", "<leader>bj", "<cmd>bn<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader>bk", "<cmd>bp<cr>", { desc = "Previous" })
vim.keymap.set("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous" })
vim.keymap.set("n", "<leader>bsd", "<cmd>%bd|e#|bd#<cr>|'<cr>", { desc = "Delete surrounding" })
