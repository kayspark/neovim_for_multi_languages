-- Leader keys (must be set before lazy.nvim loads)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable markdown recommended style (overrides shiftwidth in md files)
vim.g.markdown_recommended_style = 0

local opt = vim.opt

-- Appearance
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.showmode = false
opt.showcmd = true
opt.cmdheight = 0
vim.o.showcmdloc = "statusline"
opt.termguicolors = true
opt.list = true
opt.wrap = false
opt.linebreak = true
opt.laststatus = 3
opt.pumheight = 10
opt.smoothscroll = true
opt.conceallevel = 2

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.formatoptions:append("r")
opt.virtualedit = "block"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Windows
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"
opt.winminwidth = 5
opt.scrolloff = 10
opt.sidescrolloff = 8

-- Folds
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Files & undo
opt.autowrite = true
opt.confirm = true
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200

-- Clipboard
opt.clipboard = "unnamedplus"

-- Completion
opt.completeopt = "menu,menuone,noselect,popup"
opt.wildmode = "longest:full,full"

-- Spelling
opt.spell = false
opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
opt.spelllang = { "en" }

-- Session
opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"

-- Shell
opt.shell = "zsh"

-- Mouse
opt.mouse = "a"

-- Timing
opt.timeoutlen = 300
opt.jumpoptions = "view"
