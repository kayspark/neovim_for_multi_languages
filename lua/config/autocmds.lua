-- -- Turn off paste mode when leaving insert
-- vim.api.nvim_create_autocmd("InsertLeave", {
--   pattern = "*",
--   command = "set nopaste",
-- })
--
-- -- Disable the concealing in some file formats
-- -- The default conceallevel is 3 in LazyVim
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "json", "jsonc" },
--   callback = function()
--     vim.opt.conceallevel = 0
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = { "*tmux.conf" },
--   command = "execute 'silent !tmux source <afile> --silent'",
-- })
--
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = { "config.fish" },
--   command = "execute 'silent !source <afile> --silent'",
-- })

-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
--   pattern = { "bubu" },
--   callback = function()
--     vim.cmd([[set filetype=javascript]])
--   end,
-- })

-- Gracefully stop all LSP clients on exit to prevent orphaned processes
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.lsp.stop_client(vim.lsp.get_clients())
  end,
})

-- Enable spell checking for prose filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "org" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "cjk" }
  end,
})
