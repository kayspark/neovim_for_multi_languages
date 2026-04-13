local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Reload file when changed externally
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight yanked text
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Resize splits when terminal is resized
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Restore cursor position when reopening a file
autocmd("BufReadPost", {
  group = augroup("last_loc", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close certain filetypes with q
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "lspinfo",
    "notify",
    "qf",
    "checkhealth",
    "man",
    "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto-create parent directories when saving a file
autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Gracefully stop all LSP clients on exit
autocmd("VimLeave", {
  group = augroup("lsp_cleanup", { clear = true }),
  callback = function()
    vim.lsp.stop_client(vim.lsp.get_clients())
  end,
})

-- ]] / [[ heading navigation for markdown
autocmd("FileType", {
  group = augroup("markdown_headings", { clear = true }),
  pattern = "markdown",
  callback = function()
    local function jump_heading(forward)
      local flags = forward and "W" or "bW"
      vim.fn.search("^#\\+\\s", flags)
    end
    vim.keymap.set("n", "]]", function() jump_heading(true) end, { buffer = true, desc = "Next heading" })
    vim.keymap.set("n", "[[", function() jump_heading(false) end, { buffer = true, desc = "Prev heading" })
    vim.keymap.set("n", "]h", function() jump_heading(true) end, { buffer = true, desc = "Next heading" })
    vim.keymap.set("n", "[h", function() jump_heading(false) end, { buffer = true, desc = "Prev heading" })
  end,
})

-- Enable spell checking for prose filetypes
autocmd("FileType", {
  group = augroup("spell_prose", { clear = true }),
  pattern = { "markdown", "text", "gitcommit", "org" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "cjk" }
  end,
})
