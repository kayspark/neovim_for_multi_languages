# LazyVim Replacement — Design Spec

**Date:** 2026-04-13
**Status:** Approved
**Scope:** Replace LazyVim framework with lazy.nvim loader + Neovim 0.12 native features

## Motivation

The current config uses LazyVim as an opinionated framework layer on top of lazy.nvim.
Over time, most defaults have been overridden or disabled (noice, neo-tree, telescope,
bufferline, blink.cmp, catppuccin, dashboard). Neovim 0.12 now provides native LSP
management, completion, and improved defaults that make the framework layer redundant.

Removing LazyVim means: fewer plugins (36 → 22), no hidden config layer, faster startup,
and a config that IS the config — no mental overhead of "what does LazyVim set behind
the scenes."

## Approach

**Hybrid (C):** Keep lazy.nvim as plugin loader. Use Neovim 0.12 native features
aggressively. Plugins only where built-ins fall short.

## File Structure

```
~/.config/nvim/
├── init.lua                  # Bootstrap lazy.nvim, require config modules
├── lua/
│   ├── config/
│   │   ├── options.lua       # All vim options (LazyVim sensible defaults + user overrides)
│   │   ├── keymaps.lua       # User keymaps only (no LazyVim layer)
│   │   ├── autocmds.lua      # User autocmds + ported LazyVim essentials
│   │   └── lsp.lua           # vim.lsp.config() + vim.lsp.enable() + native completion
│   └── plugins/
│       ├── colorizer.lua     # nvim-highlight-colors
│       ├── conform.lua       # Formatter config
│       ├── database.lua      # vim-dadbod + dadbod-ui + dadbod-completion
│       ├── editor.lua        # which-key + mini.ai + mini.pairs + mini.icons
│       ├── git.lua           # gitsigns + neogit + diffview (merged from 3 files)
│       ├── lint.lua          # nvim-lint (shellcheck etc.)
│       ├── orgmode.lua       # Org-mode config
│       ├── snacks.lua        # snacks.nvim (picker, explorer, indent, words, quickfile)
│       ├── theme.lua         # nepes colorscheme
│       ├── tmux.lua          # smart-splits.nvim
│       ├── tree-sitter.lua   # nvim-treesitter + textobjects + autotag
│       ├── trouble.lua       # trouble.nvim + todo-comments.nvim
│       └── ui.lua            # grug-far, ts-comments, lazydev, SchemaStore
├── ftplugin/                 # (keep as-is)
├── spell/                    # (keep as-is)
└── stylua.toml               # (keep as-is)

Deleted:
  - lazyvim.json, neoconf.json
  - plugins/completion.lua, plugins/lsp.lua
  - plugins/noice.lua, plugins/neo-tree.lua, plugins/snacks-picker.lua
  - plugins/gitsigns.lua, plugins/git_diff.lua, plugins/neogit.lua
```

## Plugin Inventory (22 plugins)

### Core
| Plugin | Purpose | Load |
|--------|---------|------|
| folke/lazy.nvim | Plugin loader | bootstrap |
| folke/snacks.nvim | Picker, explorer, indent, words, quickfile | `lazy = false` |
| folke/which-key.nvim | Keybinding hints | `event = "VeryLazy"` |

### Editor
| Plugin | Purpose | Load |
|--------|---------|------|
| echasnovski/mini.ai | Enhanced text objects | `event = "VeryLazy"` |
| echasnovski/mini.pairs | Auto-close brackets | `event = "InsertEnter"` |
| echasnovski/mini.icons | Icon provider | `lazy = false` |
| MagicDuck/grug-far.nvim | Project search/replace | `cmd = "GrugFar"` |
| folke/ts-comments.nvim | Treesitter-aware commenting | `event = "VeryLazy"` |
| windwp/nvim-ts-autotag | HTML/JSX auto-close tags | `event = "InsertEnter"` |
| brenoprata10/nvim-highlight-colors | Color preview | `event = "BufReadPre"` |

### Git
| Plugin | Purpose | Load |
|--------|---------|------|
| lewis6991/gitsigns.nvim | Hunk signs/actions | `event = "BufReadPre"` |
| NeogitOrg/neogit | Git porcelain | `cmd = "Neogit"` |
| sindrets/diffview.nvim | Diff UI | `cmd = "DiffviewOpen"` |

### LSP & Tooling
| Plugin | Purpose | Load |
|--------|---------|------|
| williamboman/mason.nvim | Tool installer | `cmd = "Mason"` |
| nvim-treesitter/nvim-treesitter | Syntax + folds | `event = "BufReadPre"` |
| nvim-treesitter/nvim-treesitter-textobjects | TS text objects | with treesitter |
| mfussenegger/nvim-lint | Async linting | `event = "BufReadPre"` |
| stevearc/conform.nvim | Formatting | `event = "BufWritePre"` |
| b0o/SchemaStore.nvim | JSON/YAML schemas | with LSP |
| folke/lazydev.nvim | Nvim Lua API completions | `ft = "lua"` |

### Domain
| Plugin | Purpose | Load |
|--------|---------|------|
| nvim-orgmode/orgmode | Org-mode | `event = "BufReadPre"` |
| kristijanhusak/vim-dadbod-ui | Database UI (Oracle) | `cmd = "DBUI"` |
| mrjones2014/smart-splits.nvim | Pane navigation | `keys = {...}` |
| kayspark/nvim-nepes | Theme | `lazy = false, priority = 1000` |
| mfussenegger/nvim-jdtls | Java LSP | `ft = "java"` |

### Dependencies (auto-loaded)
| Plugin | Required by |
|--------|-------------|
| nvim-lua/plenary.nvim | neogit, diffview |
| tpope/vim-dadbod | vim-dadbod-ui |
| kristijanhusak/vim-dadbod-completion | vim-dadbod-ui |
| folke/trouble.nvim | editor diagnostics |
| folke/todo-comments.nvim | TODO highlights |

### Dropped
LazyVim, blink.cmp, bufferline, lualine, noice, nui, nvim-notify, neo-tree,
telescope, telescope-fzf-native, flash.nvim, catppuccin, nvim-lspconfig,
mason-lspconfig, tokyonight

## LSP Configuration (config/lsp.lua)

Uses Neovim 0.12 native APIs exclusively:

```lua
-- Server configs
vim.lsp.config("lua_ls", { settings = { Lua = { workspace = { checkThirdParty = false } } } })
vim.lsp.config("vtsls", {})  -- TypeScript (vtsls preferred over ts_ls)
vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("jsonls", {
  settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
})
vim.lsp.config("yamlls", {
  settings = { yaml = { schemaStore = { enable = false, url = "" },
    schemas = require("schemastore").yaml.schemas() } },
})
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

-- Enable all
vim.lsp.enable({
  "lua_ls", "vtsls", "pyright", "bashls", "jsonls", "yamlls",
  "clangd", "gopls", "r_language_server", "rust_analyzer",
  "dockerls", "docker_compose_language_service", "ansiblels",
  "marksman", "sqls", "texlab", "tailwindcss", "eslint", "taplo",
})

-- Global LspAttach — native completion + inlay hints
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("native_lsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
    end
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})
```

**jdtls** is handled separately by nvim-jdtls plugin (ft = "java").

## Options (config/options.lua)

Merge LazyVim sensible defaults with user overrides. User values take precedence
where both define the same option.

### From LazyVim (keep)
```
autowrite, clipboard = "unnamedplus", cursorline, grepprg = "rg --vimgrep",
grepformat, laststatus = 3, number, relativenumber, signcolumn = "yes",
smartcase, smartindent, smoothscroll, termguicolors, undofile,
undolevels = 10000, updatetime = 200, wrap = false, mouse = "a",
showmode = false, list = true, pumheight = 10, shiftround = true,
timeoutlen = 300, virtualedit = "block", wildmode = "longest:full,full",
winminwidth = 5, linebreak = true, jumpoptions = "view",
sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"
```

### User overrides (keep as-is)
```
foldlevel = 20, foldmethod = "expr", foldexpr = treesitter,
spell = false, showcmd = true, cmdheight = 0, expandtab = true,
scrolloff = 10, shell = "zsh", inccommand = "split", ignorecase = true,
shiftwidth = 2, tabstop = 2, splitbelow = true, splitright = true,
splitkeep = "cursor", showcmdloc = "statusline",
completeopt = "menu,menuone,noselect,popup"
```

## Autocmds (config/autocmds.lua)

### Ported from LazyVim
1. **checktime** — reload files changed externally on FocusGained/TermClose/TermLeave
2. **highlight_yank** — flash yanked text via TextYankPost
3. **resize_splits** — equalize splits on VimResized
4. **last_loc** — restore cursor position on BufReadPost (skip gitcommit)
5. **close_with_q** — map `q` to close help, quickfix, lspinfo, man, etc.
6. **auto_create_dir** — create parent dirs on BufWritePre

### Existing user autocmds (keep)
7. **LSP cleanup** — stop all LSP clients on VimLeave
8. **markdown headings** — `]]`/`[[` navigation
9. **spell for prose** — enable spell in markdown/text/gitcommit/org

## Keymaps (config/keymaps.lua)

User keymaps only. No LazyVim keybindings ported.

### Existing (keep as-is)
- Buffer: `<leader>bn/bp`
- Increment: `g=/g-`
- Clipboard: `<leader>y`, `<leader>yp/yP`
- Zoom: `<C-w>z`
- Visual: `<C-s>` sort, `<leader>rr` replace, `J/K` move lines

### Plugin keymaps (defined in plugin specs)
- gitsigns: `]g/[g`, `gS/gx/gs/gX/gu/gh`
- neogit: `<leader>gg`, `<leader>gc`
- diffview: `<leader>gd/gD`
- smart-splits: `<C-h/j/k/l>`, `<A-h/j/k/l>`

## Testing Strategy

1. Start nvim headless — verify clean exit, no errors
2. Open a .lua file — verify LSP attaches, completion triggers
3. Open a .py file — verify pyright, formatting works
4. Run `:Mason` — verify it opens
5. Run `:GrugFar` — verify search/replace
6. Run `<leader>gg` — verify Neogit
7. Run snacks picker — verify file/grep search
8. Check `:checkhealth` for issues

## Risks

- **Some plugins may expect nvim-lspconfig:** SchemaStore and lazydev might need
  adjustment for native `vim.lsp.config()` integration. Verify during implementation.
- **No auto-install:** Adding a new LSP server requires both `:MasonInstall` and
  adding to `vim.lsp.enable()` list. More explicit but more manual.
- **Startup order:** Without LazyVim's orchestration, ensure options load before
  plugins, and LSP config loads at the right time.
