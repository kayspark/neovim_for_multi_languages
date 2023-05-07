return {
  "folke/noice.nvim",
  lazy = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        background_colour = "#303446",
        stages = "fade_in_slide_out",
        timeout = 3000,
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      },
    },
  },
  opts = {
    presets = {
      lsp_doc_border = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      bottom_search = false,
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = false,
      },
      progress = {
        enabled = true,
      },
    },
    messages = {
      enabled = false,
    },
  },
}
