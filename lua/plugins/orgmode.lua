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
        org_todo_keywords = { "PLANNED(p)", "TODO(t)", "PROG(g)", "REVIEW(r)", "|", "DONE(d)", "CANCEL(c)" },
        org_todo_keyword_faces = {
          PLANNED = ":background #000000 :foreground #6b7280", -- 계획됨 (grey)
          TODO = ":background #000000 :foreground #2563eb",    -- 할 일 (blue)
          PROG = ":background #000000 :foreground #d97706",    -- 진행 중 (amber)
          REVIEW = ":background #000000 :foreground #ea580c",  -- 검토 중 (orange)
          DONE = ":background #000000 :foreground #16a34a",    -- 완료 (green)
          CANCEL = ":background #000000 :foreground #94a3b8",  -- 취소 (slate)
        },
        mappings = {
          org = {
            org_next_visible_heading = "]h",
            org_previous_visible_heading = "[h",
            org_forward_heading_same_level = "]s",
            org_backward_heading_same_level = "[s",
            outline_up_heading = "]u",
          },
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
          executable_path = "emacsclient -nw",
          config_path = "~/.config/doom/config.el",
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
