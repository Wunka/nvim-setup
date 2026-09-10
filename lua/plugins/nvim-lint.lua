return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    -- define your custom linter
	lint.linters.cubyz = {
	  cmd = vim.fn.expand("~/Documents/Cubyz/linter/zig-out/bin/Cubyz-linter"),
	  stdin = true,

		args = {
		  function()
			return "--stdin-filename=" .. vim.api.nvim_buf_get_name(0)
		  end,
		},

	  stream = "stderr",
	  ignore_exitcode = true,

	  parser = function(output)
		local diagnostics = {}

		for line in output:gmatch("[^\n]+") do
		  local row, col, msg =
			line:match("error:%s+[^:]+:(%d+):(%d+):%s+(.*)")

		  if row then
			table.insert(diagnostics, {
			  lnum = tonumber(row) - 1,
			  col = tonumber(col) - 1,
			  message = msg,
			  severity = vim.diagnostic.severity.ERROR,
			  source = "cubyz",
			})
		  end
		end

		return diagnostics
	  end,
	}


    -- only apply to zig/zon
	lint.linters_by_ft = {
      zig = { "cubyz" },
      zon = { "cubyz" },
    }

    -- run only inside Cubyz project
    local function in_cubyz_project()
      return vim.fn.getcwd():find("Documents/Cubyz") ~= nil
    end

	vim.api.nvim_create_autocmd(
	  { "BufEnter", "InsertLeave", "FileChangedShellPost", "BufWritePost" },
	  {
		callback = function()
		  if in_cubyz_project() then
			lint.try_lint()
		  end
		end,
	  }
	)

  end,
}
