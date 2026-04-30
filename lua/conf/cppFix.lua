local M = {}

function M.run()
  local root = vim.fn.getcwd()
  local build = root .. "/build"
  local compile_commands = build .. "/compile_commands.json"
  local target_compile = root .. "/compile_commands.json"
  local clangd_file = root .. "/.clangd"

  -- Copy compile_commands.json if it exists
  if vim.fn.filereadable(compile_commands) == 1 then
    vim.fn.copy(compile_commands, target_compile)
    vim.notify("✅ Copied compile_commands.json to project root", vim.log.levels.INFO)
  else
    vim.notify("⚠️ build/compile_commands.json not found", vim.log.levels.WARN)
  end

  -- Write a .clangd config file if it doesn't exist
  if vim.fn.filereadable(clangd_file) == 0 then
    local file = io.open(clangd_file, "w")
    if file then
      file:write([[
CompileFlags:
  Add: [
    "-target", "x86_64-w64-windows-gnu",
    "-isystem", "C:/llvm-mingw/lib/clang/17/include",
    "-isystem", "C:/llvm-mingw/x86_64-w64-mingw32/include",
    "-isystem", "C:/llvm-mingw/include/c++/v1",
    "-gdwarf-4"
  ]
]])
      file:close()
      vim.notify("✅ Created .clangd config in project root", vim.log.levels.INFO)
    else
      vim.notify("❌ Failed to write .clangd", vim.log.levels.ERROR)
    end
  else
    vim.notify("ℹ️ .clangd already exists, skipped", vim.log.levels.INFO)
  end
end

return M

