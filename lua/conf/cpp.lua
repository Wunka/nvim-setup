local M = {}

local Terminal = require("toggleterm.terminal").Terminal
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function get_root()
  return vim.fn.getcwd()
end

local function get_build_dir()
  return get_root() .. "/build"
end

-- File to store last-picked target per project
local target_file = get_build_dir() .. "/.nvim_target"

-- Toggle whether to run clang-tidy during build
M.use_clang_tidy = false

------------------------------------------------------------
-- Helpers
------------------------------------------------------------
local function ensure_build_dir()
  local build_dir = get_build_dir()
  if vim.fn.isdirectory(build_dir) == 0 then
    vim.fn.mkdir(build_dir, "p")
    -- ⚠️ WSL tip: mkdir permissions may be affected if your project
    -- is on /mnt/c/... Use `sudo` if needed or change ownership.
  end
end

local function read_target()
  if vim.fn.filereadable(target_file) == 1 then
    return vim.fn.readfile(target_file)[1]
  end
end

local function write_target(target)
  ensure_build_dir()
  vim.fn.writefile({ target }, target_file)
  -- ⚠️ WSL tip: Make sure the file is writable.
  -- If you get permission errors, check `ls -l build/.nvim_target`
end

-- Launch a floating terminal to run a command
local function run_term(cmd)
  Terminal:new({
    cmd = cmd,
    direction = "float",
    close_on_exit = false,
    float_opts = {
      border = "curved",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
    },
  }):toggle()
end

------------------------------------------------------------
-- Target discovery (CMake-aware, no parsing)
------------------------------------------------------------
local function cmake_targets()
  ensure_build_dir()
  local build_dir = get_build_dir()

  -- Configure build dir if not done yet
  os.execute("cd " .. build_dir .. " && cmake ..")
  -- ⚠️ WSL tip: If cmake cannot find compilers, make sure
  -- your gcc/g++ or clang is installed in WSL (`sudo apt install build-essential clang`)

  local handle = io.popen(
    "cd " .. build_dir .. " && cmake --build . --target help"
  )
  if not handle then
    return {}
  end

  local targets = {}
  for line in handle:lines() do
    -- Typical output: "... my_target"
    local target = line:match("^%.%.%. (%S+)")
    -- ⚠️ WSL tip: Some targets like ALL_BUILD or ZERO_CHECK may appear.
    -- They are safe to ignore.
    if target and not target:match("^all$") then
      table.insert(targets, target)
    end
  end
  handle:close()
  return targets
end

------------------------------------------------------------
-- Telescope picker
------------------------------------------------------------
function M.pick_target()
  local targets = cmake_targets()
  if vim.tbl_isempty(targets) then
    vim.notify("No CMake targets found", vim.log.levels.WARN)
    -- ⚠️ WSL tip: If targets are empty:
    -- - Check that your build dir is configured (`cmake ..` ran successfully)
    -- - Ensure compilers exist in WSL
    -- - Check that your CMakeLists.txt defines at least one add_executable
    return
  end

  pickers.new({}, {
    prompt_title = "CMake Targets",
    finder = finders.new_table(targets),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(bufnr)
      actions.select_default:replace(function()
        actions.close(bufnr)
        local selection = action_state.get_selected_entry()
        write_target(selection[1])
        vim.notify("CMake target set to: " .. selection[1])
      end)
      return true
    end,
  }):find()
end

------------------------------------------------------------
-- Build / Run
------------------------------------------------------------
function M.build()
  local target = read_target()
  local build_dir = get_build_dir()
  if not target then
    vim.notify("No target selected, opening picker", vim.log.levels.INFO)
    M.pick_target()
    return
  end

 local cmake_cmd = "cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
if M.use_clang_tidy then
  cmake_cmd = cmake_cmd .. ' -DCMAKE_CXX_CLANG_TIDY="clang-tidy;-checks=*,-llvm-*,-clang-analyzer-*,-hicpp-*"'
end

local cmd = table.concat({
  "cd " .. get_build_dir(),
  cmake_cmd,
  "cmake --build . --target " .. target
}, " && ")

  -- ⚠️ WSL tip: If build fails:
  -- - Check compiler installation (`g++ --version` or `clang++ --version`)
  -- - Check for missing packages (e.g., `sudo apt install build-essential cmake`)
  -- - For Windows paths (`/mnt/c/...`) ensure CMake can handle the paths
  run_term(cmd)
end

function M.run()
  local target = read_target()
  local build_dir = get_build_dir()
  if not target then
    vim.notify("No target selected, opening picker", vim.log.levels.INFO)
    M.pick_target()
    return
  end

  local cmd = table.concat({
    "cd " .. build_dir,
    "./" .. target, -- ⚠️ WSL tip: Executable must have execute permissions
  }, " && ")

  -- ⚠️ WSL tip: If `Permission denied` occurs:
  -- `chmod +x build/<target>` or check that WSL filesystem allows execution
  run_term(cmd)
end

------------------------------------------------------------
-- Keymaps
------------------------------------------------------------
vim.keymap.set("n", "<leader>ct", M.pick_target, { desc = "Pick CMake target" })
vim.keymap.set("n", "<leader>cb", M.build, { desc = "Build C++ target" })
vim.keymap.set("n", "<leader>cr", M.run, { desc = "Run C++ target" })
vim.keymap.set("n", "<leader>ctt", function()
  M.use_clang_tidy = not M.use_clang_tidy
  vim.notify("Clang-Tidy " .. (M.use_clang_tidy and "enabled" or "disabled"))
end, { desc = "Toggle Clang-Tidy" })

return M
