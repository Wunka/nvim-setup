local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
    width = math.floor(vim.o.columns * 0.9),
    height = math.floor(vim.o.lines * 0.9),
  },
  hidden = true,
  on_open = function(term)
    vim.cmd("startinsert!")
  end,
  on_close = function(term)
    vim.cmd("stopinsert")
  end,
})

function M.toggle()
  lazygit:toggle()
end

return M

