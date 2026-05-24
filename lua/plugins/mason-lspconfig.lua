return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig", -- still needed for server metadata
  },
  opts = {
    -- ensure_installed = { "zls", "clangd" },
  },
  config = function(_, opts)
    require("mason-lspconfig").setup(opts)

    ------------------------------------------------------------------
    -- shared on_attach (replaces your default handler)
    ------------------------------------------------------------------
    local on_attach = function(client, bufnr)
      vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration" })
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
      vim.keymap.set("n", "<leader>gS", function()
        vim.cmd("vsplit")
        vim.lsp.buf.definition()
      end, { buffer = bufnr, desc = "Go to Definition in Split" })
      vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP Hover" })
      vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to Implementation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Symbol References" })
	end

    ------------------------------------------------------------------
    -- default config (applies to all servers)
    ------------------------------------------------------------------
    vim.lsp.config["*"] = {
      on_attach = on_attach,
    }

    ------------------------------------------------------------------
    -- zls (custom)
    ------------------------------------------------------------------
    vim.lsp.config.zls = vim.tbl_extend("force", vim.lsp.config["*"], {
	  -- cmd = {"/home/Wunka/.config/nvim/zls/zig-out/bin/zls", "--log-level", "warn", "--log-fil", vim.fn.stdpath('cache') .. "/zls.log"},
      root_markers = { "zls_main.zig", "build.zig", ".git" },
    })

    ------------------------------------------------------------------
    -- clangd (custom)
    ------------------------------------------------------------------
    vim.lsp.config.clangd = vim.tbl_extend("force", vim.lsp.config["*"], {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
        "--completion-style=detailed",
        "--pch-storage=memory",
      },
      root_markers = { ".git", "." },
      init_options = {
        compilationDatabaseFallback = true,
      },
    })

    ------------------------------------------------------------------
    -- enable everything Mason installed
    ------------------------------------------------------------------
	for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
	  vim.lsp.enable(server)
	end
  end,
}
