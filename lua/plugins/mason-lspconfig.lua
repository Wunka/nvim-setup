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

	vim.lsp.config.clangd = require("esp32").lsp_config()


    ------------------------------------------------------------------
    -- zls (custom)
    ------------------------------------------------------------------
    vim.lsp.config.zls = vim.tbl_extend("force", vim.lsp.config["*"], {
	  -- cmd = {"/home/Wunka/.config/nvim/zls/zig-out/bin/zls", "--log-level", "warn", "--log-fil", vim.fn.stdpath('cache') .. "/zls.log"},
      	filetypes = {'zig'},
	  	root_markers = { "zls_main.zig", "build.zig", ".git" },
		settings = {
			zls = {
				highlight_global_var_declarations = false,
        		enable_build_on_save = true,
			}
		},
    })

	vim.api.nvim_create_autocmd('BufWritePre', {
	  pattern = { "*.zig", "*.zon" },
	  callback = function(ev)
		vim.lsp.buf.code_action({
		  context = { only = { "source.fixAll" } },
		  apply = true,
		})
	  end
	})
    ------------------------------------------------------------------
    -- clangd (custom)
    ------------------------------------------------------------------
    -- vim.lsp.config.clangd = vim.tbl_extend("force", vim.lsp.config["*"], {
    --   cmd = {
    --     "clangd",
    --     "--background-index",
    --     "--clang-tidy",
    --     "--header-insertion=never",
    --     "--completion-style=detailed",
    --     "--pch-storage=memory",
    --   },
    --   root_markers = { ".git", "." },
    --   init_options = {
    --     compilationDatabaseFallback = true,
    --   },
    -- })
    --
	vim.api.nvim_create_autocmd('FileType', {
	  group = vim.api.nvim_create_augroup('ziggy', {}),
	  pattern = {'ziggy', "*.ziggy"},
	  callback = function()
		vim.lsp.start {
		  name = 'Ziggy LSP',
		  cmd = { 'ziggy', 'lsp' },
		  root_dir = vim.loop.cwd(),
		  flags = { exit_timeout = 1000 },
		}
	  end,
	})

	vim.api.nvim_create_autocmd('FileType', {
	  group = vim.api.nvim_create_augroup('ziggy_schema', {}),
	  pattern = 'ziggy_schema',
	  callback = function()
		vim.lsp.start {
		  name = 'Ziggy LSP',
		  cmd = { 'ziggy', 'lsp', '--schema' },
		  root_dir = vim.loop.cwd(),
		  flags = { exit_timeout = 1000 },
		}
	  end,
	})

	vim.api.nvim_create_autocmd('FileType', {
	  group = vim.api.nvim_create_augroup('superhtml', {}),
	  pattern = {'superhtml', "*.smd"},
	  callback = function()
		vim.lsp.start {
		  name = 'SuperHTML LSP',
		  cmd = { 'superhtml', 'lsp' },
		  root_dir = vim.loop.cwd(),
		  flags = { exit_timeout = 1000 },
		}
	  end,
	})

    ------------------------------------------------------------------
    -- enable everything Mason installed
    ------------------------------------------------------------------
	for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
	  vim.lsp.enable(server)
	end
  end,
}
