return {
  {
    "ravenxrz/DAPInstall.nvim",
    lazy = true,
    config = function()
      require("dap_install").setup({})
      require("dap_install").config("python", {})
    end,
  },
  "rcarriga/nvim-dap-ui",
  event = "VeryLazy",
  dependencies = {
    {
      "mfussenegger/nvim-dap",
      event = "VeryLazy",
      setup = function(ops)
        local dap = require("dap")
        dap.listeners.after.event_initialized["dapui_config"] = function()
          require("dapui").open(ops)
        end

        dap.listeners.before.event_terminated["dapui_config"] = function()
          require("dapui").close(ops)
        end

        dap.listeners.before.event_exited["dapui_config"] = function()
          require("dapui").close(ops)
        end
      end,
      config = function()
        require("dap").adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            -- provide the absolute path for `codelldb` command if not using the one installed using `mason.nvim`
            command = "codelldb",
            args = { "--port", "${port}" },
            -- On windows you may have to uncomment this:
            -- detached = false,
          },
        }
        require("dap").configurations.c = {
          {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
              local path
              vim.ui.input({ prompt = "Path to executable: ", default = vim.loop.cwd() .. "/build/" }, function(input)
                path = input
              end)
              vim.cmd([[redraw]])
              return path
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
        }
      end,
    },
  },
  config = function()
    require("dapui").setup({
      expand_lines = true,
      icons = { expanded = "", collapsed = "", circular = "" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 0.33,
          position = "right",
        },
        {
          elements = {
            { id = "repl", size = 0.45 },
            { id = "console", size = 0.55 },
          },
          size = 0.27,
          position = "bottom",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5, -- Floats will be treated as percentage of your screen.
        border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    })

    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  end,
}
