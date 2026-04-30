require("conf.lazy")
require("conf.zig").setup()
require("conf.cpp")

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

local lazygit = require("conf.lazygit")
local wk = require("which-key")

wk.add({
	-- Set up buffer navigation and deletion mappings
	{'<leader>ä', ":bnext<CR>", desc = "Go to next buffer" },
	{'<leader>ö', ":bprevious<CR>", desc = "Go to previous buffer" },
	{'<leader>ü', ":bdelete<CR>", desc = "Delete current buffer" },
	{"<leader>#", ":DevdocsOpen<CR>", desc = "Open Devdocs"},
	
	{ "<leader>g", group = "git"},
	{ "<leader>gg", lazygit.toggle, desc = "Toggle LazyGit"},
})
-- vim.keymap.set("n", "<leader>gg", lazygit.toggle, { noremap = true, silent = true, desc = "Toggle LazyGit" })
 
-- Set up buffer navigation and deletion mappings
-- vim.keymap.set("n", '<leader>ä', ":bnext<CR>", { desc = "Go to next buffer" })
-- vim.keymap.set("n", '<leader>ö', ":bprevious<CR>", { desc = "Go to previous buffer" })
-- vim.keymap.set("n", '<leader>ü', ":bdelete<CR>", { desc = "Delete current buffer" })
--
-- vim.keymap.set("n", "<leader>#", ":DevdocsOpen<CR>", { desc = "Open Devdocs"})

-- vim.keymap.set("i", '<Right>', "copilot#Accept('<CR>')", {expr=true, noremap = true, silent = true })
vim.opt.cmdheight = 0

-- C++ configuration I don't want to touch
-- local dap = require('dap')
--   dap.adapters.lldb = {
--   	type = 'executable',
--   	command = 'C:\\llvm-mingw\\bin\\lldb-dap.exe', -- adjust as needed, must be absolute path
--   	name = 'lldb'
--   }
--
-- dap.configurations.cpp = {
--   {
--     name = 'Launch',
--     type = 'lldb',
--     request = 'launch',
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--     args = {},
--
--     -- 💀
--     -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
--     --
--     --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
--     --
--     -- Otherwise you might get the following error:
--     --
--     --    Error on launch: Failed to attach to the target process
--     --
--     -- But you should be aware of the implications:
--     -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
--     runInTerminal = false,
--   },
-- }
-- local cppstart = require("conf.cppstart")
-- vim.keymap.set("n", "<leader>cs", cppstart.start_project, { desc = "Create new C++ project" })

-- Transparent background
vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE ctermbg=NONE
]])
