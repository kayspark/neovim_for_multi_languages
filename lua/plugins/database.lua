return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      {
        "tpope/vim-dadbod",
        init = function()
          -- Use sqlcl-legacy wrapper (handles Java 11+ selection) for Oracle 11.2
          vim.g.dbext_default_ORA_bin = vim.fn.expand("~/.config/bin/sqlcl-legacy")
        end,
      },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.dbui_save_location = "~/workspace/sql/dadbod_queries"
      vim.g.dbs = {}
      -- nc_ees_prod: EESUSER@ees.nepes.co.kr:1521/NEPESDB1
      local u, p, h = vim.env.NC_EES_PROD_USER, vim.env.NC_EES_PROD_PASS, vim.env.NC_EES_PROD_HOST
      if u and p and h then
        table.insert(vim.g.dbs, { name = "nc_ees_prod", url = "oracle://" .. u .. ":" .. p .. "@" .. h .. ":1521/NEPESDB1" })
      end
      -- laweh_ees: eesadm@ns3-ees-db.nepes.co.kr:1521/EESDB
      local eu, ep = vim.env.LAWEH_EES_DB_USER, vim.env.LAWEH_EES_DB_PASS
      if eu and ep then
        table.insert(vim.g.dbs, { name = "laweh_ees", url = "oracle://" .. eu .. ":" .. ep .. "@ns3-ees-db.nepes.co.kr:1521/EESDB" })
      end
      -- nc_mes: mighty@mes.nepes.co.kr:1521/CCUBE
      local mu, mp = vim.env.NC_MES_DB_USER, vim.env.NC_MES_DB_PASS
      if mu and mp then
        table.insert(vim.g.dbs, { name = "nc_mes", url = "oracle://" .. mu .. ":" .. mp .. "@mes.nepes.co.kr:1521/CCUBE" })
      end
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = { "kristijanhusak/vim-dadbod-completion" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "vim-dadbod-completion" })
    end,
  },
}
