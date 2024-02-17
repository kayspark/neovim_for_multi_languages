-- overwrite lazyvim mappings with vim-tmux-navigator mappings
-- see: https://github.com/christoomey/vim-tmux-navigator/blob/master/plugin/tmux_navigator.vim

--vim.keymap.set("n", "<leader>;", "<cmd>Alpha<cr>", { desc = "Start page" })
-- buffer
vim.keymap.set("n", "<leader>bj", "<cmd>bn<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader>bk", "<cmd>bp<cr>", { desc = "Previous" })
vim.keymap.set("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous" })
vim.keymap.set("n", "<leader>bsd", "<cmd>%bd|e#|bd#<cr>|'<cr>", { desc = "Delete surrounding" })
