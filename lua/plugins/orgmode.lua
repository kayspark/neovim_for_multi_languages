return {
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
      },
    },
    event = "BufReadPre",
    config = function()
      require("orgmode").setup({
        org_todo_keywords = { "TODO(t)", "WAIT(w)", "PROC(p)", "HOLD(h)", "|", "DONE(d)", "CANCEL(c)" },
        org_todo_keyword_faces = {
          --        DELEGATED = ':background #FFFFFF :slant italic :underline on',
          TODO = ":background #000000 :foreground #E78284", -- overrides builtin color for `TODO` keyword
          WAIT = ":background #000000 :foreground #E7C664", -- overrides builtin color for `WAIT` keyword
          PROC = ":background #000000 :foreground #E7C664", -- overrides builtin color for `PROC` keyword
          HOLD = ":background #000000 :foreground #E7C664", -- overrides builtin color for `HOLD` keyword
          DONE = ":background #000000 :foreground #86DC2F", -- overrides builtin color for `DONE` keyword
          CANCEL = ":background #000000 :foreground #E78284", -- overrides builtin color for `CANCEL` keyword
        },
        mappings = {
          text_objects = {
            inner_heading = "ic",
            around_heading = "ac",
            inner_subtree = "is",
            around_subtree = "as",
            inner_heading_from_root = "iC",
            around_heading_from_root = "aC",
            inner_subtree_from_root = "iS",
            around_subtree_from_root = "aS",
          },
        },
        emacs_config = {
          excutable_path = "/usr/local/bin/emacs",
          config_path = "~/.dotfiles/.doom.d/init.el",
        },
        org_agenda_files = { "~/org/*.org", "~/org/org-roam/**/*" },
        org_default_notes_file = "~/org/notes.org",
        org_capture_templates = {
          T = {
            description = "Todo",
            template = "* TODO %?\n %u",
            target = "~/org/todo.org",
          },
          n = {
            description = "Notes",
            template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
            target = "~/org/notes.org",
          },
        },
      })
    end,
  },
}
