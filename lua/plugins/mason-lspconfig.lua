return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    -- ensure_installed = {
    --   "zls",
    -- },
    handlers = {
      -- default handler (optional, can call default setup for other servers)
      function(server_name)
        require("lspconfig")[server_name].setup({
		on_attach = function(client,bufnr)
			vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration" })
    			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
   			vim.keymap.set("n", "<leader>gS", function()
				vim.cmd('vsplit')
				vim.lsp.buf.definition()
			end, { buffer = bufnr, desc = "Go to Definition in Split" })
			vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover" })
    			vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to Implementation" })
    			-- vim.keymap.set("n", "<leader><C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
    			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
    			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Symbol References" })
    			-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
    			-- vim.keymap.set("n", "<leader>[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Go to Next Diagnostic" })
    			-- vim.keymap.set("n", "<leader>gl", vim.diagnostic.open_float, { buffer = bufnr, desc = "Open Diagnostic Float" })
    			-- vim.keymap.set("n", "<leader>]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Go to Previous Diagnostic" })
    			-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { buffer = bufnr, desc = "Diagnostic to local list" })	
		end,
		})
      end,

      -- custom handler for zls
      ["zls"] = function()
        require("lspconfig").zls.setup({
          cmd = { "/home/Dominik/.config/nvim/zls" },  -- <-- change this to your local zls binary path
          -- any other options you want
        })
      end,
    },
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
