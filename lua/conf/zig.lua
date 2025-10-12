local M = {}

-- Setup LSP
function M.setup_lsp()
  local lspconfig = require("lspconfig")
  lspconfig.zls.setup({})
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
    cmd = "zig test src/main.zig", -- adjust if needed
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
  vim.keymap.set("n", "<leader>zt", M.toggle_test, { desc = "Zig Test", noremap = true, silent = true })
  vim.keymap.set("n", "<leader>zr", M.toggle_run,  { desc = "Zig Run", noremap = true, silent = true })
end

-- Master setup
function M.setup()
  M.setup_lsp()
  M.setup_terminals()
  M.setup_keymaps()
end

return M

