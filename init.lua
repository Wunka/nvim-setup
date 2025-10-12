require("conf.lazy")
require("conf.zig").setup()

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

local lazygit = require("conf.lazygit")
vim.keymap.set("n", "<leader>gg", lazygit.toggle, { noremap = true, silent = true, desc = "Toggle LazyGit" })

-- Set transparent background
vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight NormalNC guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight SignColumn guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight VertSplit guibg=NONE ctermbg=NONE]])

