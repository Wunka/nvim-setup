return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "BufReadPost",
  config = function()
    require("lualine").setup({
      options = {
        theme = "nordic",          -- match your colorscheme
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        globalstatus = true,       -- single statusline for all windows
        icons_enabled = true,
        disabled_filetypes = {},
      },
      sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1 } },  -- relative path
		lualine_x = { {
			"buffers",
			mode = 2
		}, "fileformat", "filetype" },
		lualine_y = { "progress" },                -- shows percentage through file
		lualine_z = { "location" },               -- shows 702L, 15C
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "quickfix", "nvim-tree" },
    })
  end,
}

