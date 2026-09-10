local M = {}

function M.start_project()
  local name = vim.fn.input("Project name: ")
  local root = vim.fn.getcwd() .. "/" .. name
  local src = root .. "/src"
  vim.fn.mkdir(src, "p")

  -- write main.cpp
  local main_cpp = src .. "/main.cpp"
  if vim.fn.filereadable(main_cpp) == 0 then
    local f = io.open(main_cpp, "w")
    f:write([[
#include <iostream>

int main() {
    std::cout << "Hello from ]] .. name .. [[!" << std::endl;
    return 0;
}
]])
    f:close()
  end

  -- write CMakeLists.txt
  local cmake = root .. "/CMakeLists.txt"
  if vim.fn.filereadable(cmake) == 0 then
    local f = io.open(cmake, "w")
    f:write([[
cmake_minimum_required(VERSION 3.16)
project(]] .. name .. [[)
set(CMAKE_CXX_STANDARD 20)
add_executable(]] .. name .. [[ src/main.cpp)
]])
    f:close()
  end

  vim.cmd("cd " .. name)
  vim.cmd("e " .. main_cpp)
  print("Project '" .. name .. "' created at " .. root)
end

return M

