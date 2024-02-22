return {
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
        item = { "", "" },
        section = { "", "" },
      },
      integrations = {
        diffview = true,
      },
    },
    keys = {
      { "<leader>gc", "<cmd>lua require('neogit').open({'commit'})<CR>", desc = "Git commit" },
      { "<leader>gg", "<cmd>lua require('neogit').open()<CR>", desc = "Git commit" },
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
      hooks = {
        view_opened = function()
          local stdout = vim.loop.new_tty(1, false)
          if stdout ~= nil then
            stdout:write(
              ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format(
                "DIFF_VIEW",
                vim.fn.system({ "base64" }, "+4")
              )
            )
            vim.cmd([[redraw]])
          end
        end,
        view_closed = function()
          local stdout = vim.loop.new_tty(1, false)
          if stdout ~= nil then
            stdout:write(
              ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format(
                "DIFF_VIEW",
                vim.fn.system({ "base64" }, "-1")
              )
            )
            vim.cmd([[redraw]])
          end
        end,
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffviewOpen" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
}
