-- overwrite lazyvim mappings with vim-tmux-navigator mappings
-- see: https://github.com/christoomey/vim-tmux-navigator/blob/master/plugin/tmux_navigator.vim

-- buffer
vim.keymap.set("n", "<leader>bj", "<cmd>bn<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader>bk", "<cmd>bp<cr>", { desc = "Previous" })
vim.keymap.set("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous" })

vim.keymap.set(
  "n",
  "<leader>bb",
  "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
  { desc = "Telescope buffers" }
)

-- clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- gen
vim.keymap.set("v", "<leader>]", "<cmd>Gen<CR>")
vim.keymap.set("n", "<leader>]", "<cmd>Gen<CR>")

vim.keymap.set("v", "<C-s>", "<cmd>sort<CR>") -- Sort highlighted text in visual mode with Control+S
vim.keymap.set("v", "<leader>rr", '"hy:%s/<C-r>h//g<left><left>') -- Replace all instances of highlighted words
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move current line down
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv") -- Move current line up
