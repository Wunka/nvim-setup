vim.keymap.set("n", "<leader>cb", function()

  local root = vim.fn.getcwd()
  local build_dir = root .. "/build"

  -- Create build directory if it doesn't exist
  if vim.fn.isdirectory(build_dir) == 0 then
    vim.fn.mkdir(build_dir, "p")
  end

  -- Parse executable name from CMakeLists.txt
  local exe_name = "a"
  for line in io.lines(root .. "/CMakeLists.txt") do
    local match = line:match("add_executable%((%S+)")
    if match then
      exe_name = match
      break
    end
  end

  -- LLVM-MinGW absolute paths (adjust if needed)
  local clang = "C:/llvm-mingw/bin/clang.exe"
  local clangxx = "C:/llvm-mingw/bin/clang++.exe"

  -- Build command
  local command = table.concat({
    "cd " .. build_dir,
    "cmake .. -G \"MinGW Makefiles\" " ..
      "-D\"CMAKE_C_COMPILER:PATH=" .. clang .. "\" " ..
      "-D\"CMAKE_CXX_COMPILER:PATH=" .. clangxx .. "\"",
    "cmake --build ."
  }, " && ")

  -- Launch ToggleTerm float
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = command,
    direction = "float",
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      winblend = 10,
    },
    close_on_exit = false,
    hidden = true,
  })

  term:toggle()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>cr", function()

  local root = vim.fn.getcwd()
  local build_dir = root .. "/build"

  -- Create build directory if it doesn't exist
  if vim.fn.isdirectory(build_dir) == 0 then
    vim.fn.mkdir(build_dir, "p")
  end
  
  -- Parse executable from last created exe File in build directory
  local exe_name = "a" 
  local last_time = 0
  for _, file in ipairs(vim.fn.glob(build_dir .. "/*.exe", false, true)) do
  	local mod_time = vim.fn.getftime(file)
	if mod_time > last_time then
		last_time = mod_time
		exe_name = vim.fn.fnamemodify(file, ":t:r")
	end
  end

  -- run command
  local command = table.concat({
    "cd " .. build_dir,
    exe_name .. ".exe"
  }, " && ")

  -- Launch ToggleTerm float
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = command,
    direction = "float",
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      winblend = 10,
    },
    close_on_exit = false,
    hidden = true,
  })

  term:toggle()
end, { noremap = true, silent = true })


vim.api.nvim_create_user_command("CppStart", function()
  local name = vim.fn.input("Project name: ")
  local root = vim.fn.getcwd() .. "/" .. name
  local src = root .. "/src"

  -- Create folders
  vim.fn.mkdir(src, "p")

  -- Write main.cpp
  local main_cpp = src .. "/main.cpp"
  if vim.fn.filereadable(main_cpp) == 0 then
    local file = io.open(main_cpp, "w")
    file:write([[
#include <iostream>

int main() {
    std::cout << "Hello from ]] .. name .. [[!" << std::endl;
    return 0;
}
]])
    file:close()

	vim.cmd("cd " .. name)
  end

  -- Write CMakeLists.txt
  local cmake = root .. "/CMakeLists.txt"
  if vim.fn.filereadable(cmake) == 0 then
    local file = io.open(cmake, "w")
    file:write([[
cmake_minimum_required(VERSION 3.16)

project(]] .. name .. [[)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
    add_compile_options(-Wall -pedantic -Wextra -O0)
endif ()
 
if (CMAKE_CXX_COMPILER_ID MATCHES Clang)
    add_compile_options(-Wall -pedantic -Wextra -O0) 
endif ()

add_executable(]] .. name .. [[ src/main.cpp)
]])
    file:close()
  end

  print("Project '" .. name .. "' created at " .. root)
  vim.cmd("e " .. main_cpp)
end, {})

vim.api.nvim_create_user_command("CppFix", function()
  require("conf.cppfix").run()
end, {})

-- vim.api.nvim_create_autocmd("BufReadPost", {
--   pattern = "*.cpp",
--   callback = function()
--     require("conf.cppfix").run()
--   end
-- })

