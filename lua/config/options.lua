-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.g.lazyvim_picker = "snacks"
vim.g.root_spec = { "lsp", { ".git", "lua", ".project", ".projectile" }, "cwd" }
vim.g.input_method_default = "korean"
local opt = vim.opt

opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

opt.spell = false
opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
opt.showcmd = true
opt.cmdheight = 0
opt.expandtab = true
opt.scrolloff = 10
opt.shell = "zsh"
opt.inccommand = "split"
opt.ignorecase = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"
opt.formatoptions:append({ "r" })
vim.o.showcmdloc = "statusline"
