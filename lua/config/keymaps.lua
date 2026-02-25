-- overwrite lazyvim mappings with vim-tmux-navigator mappings
-- see: https://github.com/christoomey/vim-tmux-navigator/blob/master/plugin/tmux_navigator.vim

-- buffer
vim.keymap.set("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous" })

-- increment/decrement (match Doom Emacs evil-numbers bindings)
vim.keymap.set("n", "g=", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "g-", "<C-x>", { desc = "Decrement number" })
vim.keymap.set("v", "g=", "g<C-a>", { desc = "Increment numbers sequentially" })
vim.keymap.set("v", "g-", "g<C-x>", { desc = "Decrement numbers sequentially" })

-- clipboard (matches Emacs SPC y pattern)
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>yp", '"+p', { desc = "Paste from clipboard (after)" })
vim.keymap.set("n", "<leader>yP", '"+P', { desc = "Paste from clipboard (before)" })

-- window zoom toggle (matches tmux C-b z)
vim.keymap.set("n", "<C-w>z", function()
  if vim.t.zoom_winid then
    vim.cmd("wincmd =")
    vim.t.zoom_winid = nil
  else
    vim.t.zoom_winid = vim.api.nvim_get_current_win()
    vim.cmd("wincmd _")
    vim.cmd("wincmd |")
  end
end, { desc = "Zoom toggle" })

vim.keymap.set("v", "<C-s>", "<cmd>sort<CR>") -- Sort highlighted text in visual mode with Control+S
vim.keymap.set("v", "<leader>rr", '"hy:%s/<C-r>h//g<left><left>') -- Replace all instances of highlighted words
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move current line down
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv") -- Move current line up
