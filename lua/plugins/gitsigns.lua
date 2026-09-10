-- lua/plugins/gitsigns.lua
return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre", -- load when opening a file
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      numhl = true,      -- highlight line numbers
      linehl = false,     -- highlight entire line
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true,  -- show inline blame for current line
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",  -- end of line
        delay = 500,
      },
      update_debounce = 100,
      status_formatter = nil, -- use default
    })
    local gs = require('gitsigns')

	vim.keymap.set("n", "<leader>5", gs.next_hunk, { desc = "Next git hunk" })
	vim.keymap.set("n", "<leader>8", gs.prev_hunk, { desc = "Previous git hunk" })
	vim.keymap.set("n", "<leader>0", gs.stage_hunk, { desc = "Stage hunk" })
	vim.keymap.set("n", "<leader>-", gs.reset_hunk, { desc = "Reset hunk" })
	vim.keymap.set("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Stage hunk (visual)" })
	vim.keymap.set("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Reset hunk (visual)" })
	vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
	vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
	vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
	vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
	vim.keymap.set("n", "<leader>hb", function() gs.blame_line { full = true } end, { desc = "Blame line" })
	vim.keymap.set("n", "<leader>/", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
	vim.keymap.set("n", "<leader>7", gs.diffthis, { desc = "Diff this buffer" })
	vim.keymap.set("n", "<leader>4", function() gs.diffthis("~") end, { desc = "Diff against index" })
  end,



}

