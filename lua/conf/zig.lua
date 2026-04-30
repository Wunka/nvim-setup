local M = {}

-- Setup LSP
function M.setup_lsp()
  -- define zls config (no lspconfig framework)
  vim.lsp.config.zls = {
	root_markers = { "zls.json", "build.zig", ".git" },
	  -- cmd = {"/home/Wunka/.config/nvim/zls/zig-out/bin/zls"},

	  settings = {
		zls = {
		zig_exe_path = "/home/Wunka/Documents/Cubyz/master/compiler/zig/zig",
		zig_lib_path = "/home/Wunka/Documents/Cubyz/master/compiler/zig/lib",
		  modules = {
			main = "src/main.zig",
		  },
		  -- core stuff
		  enable_snippets = true,
		  warn_style = true,
		  enable_semantic_tokens = true,

		  -- quality-of-life
		  enable_inlay_hints = true,
		  enable_argument_placeholders = true,

		  -- performance
		  enable_build_on_save = false, -- let zig build handle this
		},
	  },
  }

  -- enable zls
  vim.lsp.enable("zls")
end

-- Setup build/test/run terminals using ToggleTerm
function M.setup_terminals()
  local Terminal = require("toggleterm.terminal").Terminal

  local zig_build = Terminal:new({
    cmd = "zig build",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    close_on_exit = false,
    float_opts = { border = "curved" },
  })

  local zig_test = Terminal:new({
    cmd = "zig test src/main.zig",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    close_on_exit = false,
    float_opts = { border = "curved" },
  })

  local zig_run = Terminal:new({
    cmd = "zig build run",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    close_on_exit = false,
    float_opts = { border = "curved" },
  })

  function M.toggle_build()
    zig_build:toggle()
  end

  function M.toggle_test()
    zig_test:toggle()
  end

  function M.toggle_run()
    zig_run:toggle()
  end
end

-- Keymaps
function M.setup_keymaps()
  vim.keymap.set("n", "<leader>zb", M.toggle_build, { desc = "Zig Build", noremap = true, silent = true })
  vim.keymap.set("n", "<leader>zt", M.toggle_test,  { desc = "Zig Test",  noremap = true, silent = true })
  vim.keymap.set("n", "<leader>zr", M.toggle_run,   { desc = "Zig Run",   noremap = true, silent = true })
end

-- Master setup
function M.setup()
  M.setup_lsp()
  M.setup_terminals()
  M.setup_keymaps()
end

return M
