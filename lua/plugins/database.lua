return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    {
      "tpope/vim-dadbod",
      init = function()
        vim.g.dbext_default_ORA_bin = "sqlplus"
      end,
      lazy = true,
    },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- Your DBUI configuration
    vim.g.dbext_default_ORA_bin = "sqlplus"
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.dbui_save_location = "~/workspace/sql/dadbod_queries"
  end,
}
