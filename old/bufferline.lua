return {
  "akinsho/bufferline.nvim",
  version = "*",  -- use latest stable
  dependencies = "nvim-tree/nvim-web-devicons", -- for icons
  event = "VeryLazy", -- lazy-load
  config = function()
    require("bufferline").setup({
      options = {
        numbers = "ordinal",           
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = { style = "icon", icon = "▎" },
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 30,
        max_prefix_length = 15,
        tab_size = 21,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            padding = 1,
          },
        },
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "thin",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
      },
      -- optional highlight section; you can remove if you don't have nordic.bufferline
      -- highlights = require("nordic.bufferline") or {},
    })
  end,
}
