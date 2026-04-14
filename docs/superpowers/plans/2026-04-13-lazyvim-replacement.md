# LazyVim Replacement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the LazyVim framework with lazy.nvim loader + Neovim 0.12 native features, reducing plugins from 36 to 22.

**Architecture:** Keep lazy.nvim as the plugin manager. Remove the LazyVim framework dependency entirely. Use Neovim 0.12 native `vim.lsp.config/enable` for LSP, native `vim.lsp.completion.enable` for completion. Port only the essential LazyVim autocmds and options; discard the rest.

**Tech Stack:** Neovim 0.12+, lazy.nvim, Lua config

**Spec:** `docs/superpowers/specs/2026-04-13-lazyvim-replacement-design.md`

---

### Task 1: Rewrite init.lua and lazy.lua — bootstrap without LazyVim

**Files:**
- Rewrite: `init.lua`
- Rewrite: `lua/config/lazy.lua`

- [ ] **Step 1: Rewrite `init.lua`**

Replace the current single-line `require("config.lazy")` with explicit module loading order:

```lua
-- Bootstrap lazy.nvim and load config
require("config.options")
require("config.lazy")
require("config.autocmds")
require("config.keymaps")
require("config.lsp")
```

- [ ] **Step 2: Rewrite `lua/config/lazy.lua`**

Remove LazyVim framework, extras imports, and LazyVim-specific globals. Keep lazy.nvim bootstrap + plugin loader:

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "nepes" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
```

- [ ] **Step 3: Smoke test**

Run: `cd ~/.config/nvim && nvim --headless -c 'qall' 2>&1`
Expected: Clean exit, no errors (plugins will fail to load at this point since we haven't updated them yet — that's fine, this validates the bootstrap)

- [ ] **Step 4: Commit**

```bash
cd ~/.config/nvim
git add init.lua lua/config/lazy.lua
git commit -m "refactor: rewrite init.lua and lazy.lua — remove LazyVim framework"
```

---

### Task 2: Rewrite options.lua — merge LazyVim defaults with user overrides

**Files:**
- Rewrite: `lua/config/options.lua`

- [ ] **Step 1: Rewrite `lua/config/options.lua`**

```lua
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
opt.formatoptions:append({ "r" })
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
```

- [ ] **Step 2: Smoke test**

Run: `cd ~/.config/nvim && nvim --headless +"lua print('leader: ' .. vim.g.mapleader)" +qall 2>&1`
Expected: `leader:  ` (space)

- [ ] **Step 3: Commit**

```bash
cd ~/.config/nvim
git add lua/config/options.lua
git commit -m "refactor: options.lua — merge LazyVim defaults with user overrides"
```

---

### Task 3: Rewrite autocmds.lua — port LazyVim essentials + keep user autocmds

**Files:**
- Rewrite: `lua/config/autocmds.lua`

- [ ] **Step 1: Rewrite `lua/config/autocmds.lua`**

```lua
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
```

- [ ] **Step 2: Commit**

```bash
cd ~/.config/nvim
git add lua/config/autocmds.lua
git commit -m "refactor: autocmds.lua — port LazyVim essentials + keep user autocmds"
```

---

### Task 4: Create config/lsp.lua — native LSP + completion

**Files:**
- Create: `lua/config/lsp.lua`

- [ ] **Step 1: Create `lua/config/lsp.lua`**

```lua
-- Native Neovim 0.12 LSP configuration
-- No nvim-lspconfig or mason-lspconfig needed

-- Server-specific settings
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("vtsls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("clangd", {})
vim.lsp.config("gopls", {})
vim.lsp.config("r_language_server", {})
vim.lsp.config("rust_analyzer", {})
vim.lsp.config("dockerls", {})
vim.lsp.config("docker_compose_language_service", {})
vim.lsp.config("ansiblels", {})
vim.lsp.config("marksman", {})
vim.lsp.config("sqls", {})
vim.lsp.config("texlab", {})
vim.lsp.config("tailwindcss", {})
vim.lsp.config("eslint", {})
vim.lsp.config("taplo", {})

-- JSON/YAML with SchemaStore (lazy-require to avoid load-time errors)
vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = function()
        return require("schemastore").json.schemas()
      end,
      validate = { enable = true },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" },
      schemas = function()
        return require("schemastore").yaml.schemas()
      end,
    },
  },
})

-- Enable all servers
vim.lsp.enable({
  "lua_ls", "vtsls", "pyright", "bashls",
  "jsonls", "yamlls",
  "clangd", "gopls", "r_language_server", "rust_analyzer",
  "dockerls", "docker_compose_language_service",
  "ansiblels", "marksman", "sqls", "texlab",
  "tailwindcss", "eslint", "taplo",
})

-- Global LspAttach — native completion + inlay hints
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("native_lsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    -- Native completion with autotrigger
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
        autotrigger = true,
      })
    end
    -- Inlay hints
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})
```

- [ ] **Step 2: Commit**

```bash
cd ~/.config/nvim
git add lua/config/lsp.lua
git commit -m "feat: add native LSP config — vim.lsp.config/enable + native completion"
```

---

### Task 5: Rewrite plugin specs — editor.lua, snacks.lua, theme.lua

**Files:**
- Rewrite: `lua/plugins/editor.lua`
- Rewrite: `lua/plugins/snacks-picker.lua` → rename to `lua/plugins/snacks.lua`
- Rewrite: `lua/plugins/theme.lua`

- [ ] **Step 1: Rewrite `lua/plugins/editor.lua`**

Combine which-key, mini.ai, mini.pairs, mini.icons:

```lua
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 0,
      icons = { mappings = true },
      plugins = {
        marks = true,
        registers = false,
        spelling = { enabled = false },
        presets = {
          operators = false,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.icons",
    lazy = false,
    opts = {},
    init = function()
      -- Compatibility shim for plugins expecting nvim-web-devicons
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
```

- [ ] **Step 2: Rename and rewrite snacks config**

Delete `lua/plugins/snacks-picker.lua`, create `lua/plugins/snacks.lua`:

```lua
return {
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      dashboard = { enabled = false },
      picker = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      words = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      notifier = { enabled = true },
      bigfile = { enabled = true },
      statuscolumn = { enabled = true },
      input = { enabled = true },
      scroll = { enabled = false },
    },
    keys = {
      { "<leader>ff", function() require("snacks").picker.files() end, desc = "Find files" },
      { "<leader>fg", function() require("snacks").picker.grep() end, desc = "Grep" },
      { "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() require("snacks").picker.help() end, desc = "Help" },
      { "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent files" },
      { "<leader>e", function() require("snacks").explorer() end, desc = "File explorer" },
    },
  },
}
```

- [ ] **Step 3: Rewrite `lua/plugins/theme.lua`**

Remove LazyVim opts override:

```lua
return {
  {
    "kayspark/nvim-nepes",
    name = "nepes",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      theme = "dark",
    },
    config = function(_, opts)
      require("nepes").setup(opts)
      vim.cmd.colorscheme("nepes")
    end,
  },
}
```

- [ ] **Step 4: Commit**

```bash
cd ~/.config/nvim
git rm lua/plugins/snacks-picker.lua
git add lua/plugins/editor.lua lua/plugins/snacks.lua lua/plugins/theme.lua
git commit -m "refactor: rewrite editor, snacks, theme plugin specs — standalone"
```

---

### Task 6: Create git.lua — merge gitsigns + neogit + diffview

**Files:**
- Create: `lua/plugins/git.lua`
- Delete: `lua/plugins/gitsigns.lua`
- Delete: `lua/plugins/git_diff.lua`
- Delete: `lua/plugins/neogit.lua`

- [ ] **Step 1: Create `lua/plugins/git.lua`**

```lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "]g", ":Gitsigns next_hunk<CR>", desc = "Goto next git hunk" },
      { "[g", ":Gitsigns prev_hunk<CR>", desc = "Goto previous git hunk" },
      { "gS", ":Gitsigns stage_buffer<CR>", desc = "Stage Buffer" },
      { "gx", ":Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
      { "gs", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
      { "gX", ":Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
      { "gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Hunk" },
      { "gh", ":Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    opts = {
      signs = {
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
      integrations = {
        diffview = true,
      },
    },
    keys = {
      { "<leader>gc", "<cmd>lua require('neogit').open({'commit'})<CR>", desc = "Neogit commit" },
      { "<leader>gg", "<cmd>lua require('neogit').open()<CR>", desc = "Neogit status" },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    opts = {
      file_panel = {
        position = "bottom",
        height = 20,
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
    },
  },
}
```

- [ ] **Step 2: Delete old files and commit**

```bash
cd ~/.config/nvim
git rm lua/plugins/gitsigns.lua lua/plugins/git_diff.lua lua/plugins/neogit.lua
git add lua/plugins/git.lua
git commit -m "refactor: merge gitsigns + neogit + diffview into git.lua"
```

---

### Task 7: Create trouble.lua, lint.lua, ui.lua — remaining plugins

**Files:**
- Create: `lua/plugins/trouble.lua`
- Create: `lua/plugins/lint.lua`
- Create: `lua/plugins/ui.lua`

- [ ] **Step 1: Create `lua/plugins/trouble.lua`**

```lua
return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPre",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {},
    keys = {
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODOs (Trouble)" },
    },
  },
}
```

- [ ] **Step 2: Create `lua/plugins/lint.lua`**

```lua
return {
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPre",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
```

- [ ] **Step 3: Create `lua/plugins/ui.lua`**

```lua
return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {},
    keys = {
      { "<leader>sr", "<cmd>GrugFar<cr>", desc = "Search and replace" },
    },
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true, -- loaded by LSP config when jsonls/yamlls attaches
  },
}
```

- [ ] **Step 4: Commit**

```bash
cd ~/.config/nvim
git add lua/plugins/trouble.lua lua/plugins/lint.lua lua/plugins/ui.lua
git commit -m "feat: add trouble, lint, ui plugin specs"
```

---

### Task 8: Update tree-sitter.lua — add autotag + textobjects

**Files:**
- Rewrite: `lua/plugins/tree-sitter.lua`

- [ ] **Step 1: Rewrite `lua/plugins/tree-sitter.lua`**

```lua
vim.filetype.add({
  filename = {
    ["envrc"] = "bash",
  },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "fish",
        "html",
        "java",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "kdl",
        "markdown",
        "markdown_inline",
        "mermaid",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
```

- [ ] **Step 2: Commit**

```bash
cd ~/.config/nvim
git add lua/plugins/tree-sitter.lua
git commit -m "refactor: tree-sitter.lua — add autotag, textobjects, highlight, indent"
```

---

### Task 9: Update mason.lua — standalone (no mason-lspconfig)

**Files:**
- Create: `lua/plugins/mason.lua`

- [ ] **Step 1: Create `lua/plugins/mason.lua`**

Mason just installs binaries. No auto-wiring with LSP.

```lua
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    -- Config is in ftplugin/java.lua, not here
  },
}
```

- [ ] **Step 2: Commit**

```bash
cd ~/.config/nvim
git add lua/plugins/mason.lua
git commit -m "feat: add standalone mason.lua — no mason-lspconfig"
```

---

### Task 10: Delete obsolete files

**Files:**
- Delete: `lua/plugins/completion.lua`
- Delete: `lua/plugins/lsp.lua`
- Delete: `lua/plugins/noice.lua`
- Delete: `lua/plugins/neo-tree.lua`
- Delete: `lazyvim.json`
- Delete: `neoconf.json`

- [ ] **Step 1: Remove all obsolete files**

```bash
cd ~/.config/nvim
git rm lua/plugins/completion.lua lua/plugins/lsp.lua lua/plugins/noice.lua lua/plugins/neo-tree.lua lazyvim.json neoconf.json
```

- [ ] **Step 2: Commit**

```bash
cd ~/.config/nvim
git commit -m "chore: delete LazyVim-specific files — completion, lsp, noice, neo-tree, lazyvim.json, neoconf.json"
```

---

### Task 11: Full integration test

**Files:** None (testing only)

- [ ] **Step 1: Clean start — remove lazy lock and plugin cache**

```bash
cd ~/.config/nvim
rm -f lazy-lock.json
rm -rf ~/.local/share/nvim/lazy/LazyVim
```

- [ ] **Step 2: Headless startup test**

Run: `cd ~/.config/nvim && nvim --headless -c 'qall' 2>&1`
Expected: Clean exit, no errors

- [ ] **Step 3: Plugin count check**

Run: `nvim --headless +"lua print('plugins: '..#require('lazy').plugins())" +qall 2>&1`
Expected: Around 22-27 plugins (includes dependencies)

- [ ] **Step 4: LSP attach test**

Run: `nvim --headless +"lua vim.defer_fn(function() print('lsp clients: ' .. #vim.lsp.get_clients()) vim.cmd('qall') end, 3000)" lua/config/lsp.lua 2>&1`
Expected: `lsp clients: 1` (lua_ls)

- [ ] **Step 5: Interactive smoke test**

Open nvim interactively and verify:
- Colorscheme loads (nepes dark)
- Snacks picker works (`<leader>ff`)
- Snacks explorer works (`<leader>e`)
- Neogit works (`<leader>gg`)
- Gitsigns hunk navigation (`]g`, `[g`)
- Which-key popup appears on `<leader>`
- Native completion triggers in a `.lua` file
- `:Mason` opens
- `:GrugFar` opens
- `:Trouble diagnostics toggle` opens
- `:checkhealth` shows no critical issues

- [ ] **Step 6: Commit lock file**

```bash
cd ~/.config/nvim
git add lazy-lock.json
git commit -m "chore: regenerate lazy-lock.json after LazyVim removal"
```
