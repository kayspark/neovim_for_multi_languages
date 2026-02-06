# AGENTS.md

Shared guidance for AI coding agents working in this repository (Codex and Claude).

## Current State
- Plugin source of truth: `lua/config/lazy.lua`
- `lazyvim.json` intentionally has `extras: []`
- SQL workflow is `vim-dadbod` + `vim-dadbod-ui` + `vim-dadbod-completion` (no `sqls`)
- DAP/test extras were intentionally removed to minimize plugin dependencies

## Key Files
- `init.lua`: bootstraps `config.lazy`
- `lua/config/lazy.lua`: LazyVim setup and enabled extras
- `lua/plugins/*.lua`: plugin specs and overrides
- `README.org`: user-facing docs and custom keymaps
- `docs/ops/git-signing.md`: Git commit signing runbook

## Validation Commands
```bash
nvim --headless "+checkhealth" "+qa"
luac -p lua/config/lazy.lua
```

## Editing Rules
- Keep plugin minimization as a project goal.
- Do not re-enable removed extras (`dap.*`, `test.*`) unless explicitly requested.
- For SQL, prefer preserving dadbod workflow; do not reintroduce `sqls` by default.
- Update `README.org` when keymaps or workflow docs change.

## Git Signing
If signed commits fail, use the runbook:
- `docs/ops/git-signing.md`
