return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  init = function()
    local parsers = require("nvim-treesitter.parsers")

    parsers.ziggy = {
      install_info = {
        url = "https://github.com/kristoff-it/ziggy",
        location = "tree-sitter-ziggy",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "ziggy",
    }

    parsers.ziggy_schema = {
      install_info = {
        url = "https://github.com/kristoff-it/ziggy",
        location = "tree-sitter-ziggy-schema",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "ziggy_schema",
    }

	parsers.supermd = {
	  install_info = {
		url = "https://github.com/kristoff-it/supermd",
		location = "tree-sitter/supermd",
		files = {
		  "src/parser.c",
		  "src/scanner.c",
		},
		branch = "main",
	  },
	  filetype = "supermd",
	}

	print("supermd registered", parsers.supermd ~= nil)

	parsers.supermd_inline = {
	  install_info = {
		url = "https://github.com/kristoff-it/supermd",
		location = "tree-sitter/supermd-inline",
		files = {
		  "src/parser.c",
		  "src/scanner.c",
		},
		branch = "main",
	  },
	  filetype = "supermd_inline",
	}

    parsers.superhtml = {
      install_info = {
        url = "https://github.com/kristoff-it/superhtml",
        location = "tree-sitter-superhtml",
        files = {
          "src/parser.c",
          "src/scanner.c",
        },
        branch = "main",
      },
      filetype = "superhtml",
    }

    vim.filetype.add({
      extension = {
        smd = "supermd",
        shtml = "superhtml",
        ziggy = "ziggy",
        ["ziggy-schema"] = "ziggy_schema",
      },
    })
  end,

  opts = {
    ensure_installed = {
      "html",
      "ziggy",
      "ziggy_schema",
      "supermd",
      "supermd_inline",
      "superhtml",
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  },

 config = function()
    require("nvim-treesitter").setup()

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "superhtml",
      },
      callback = function(args)
        vim.treesitter.start(args.buf, "superhtml")
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "ziggy",
      },
      callback = function(args)
        vim.treesitter.start(args.buf, "ziggy")
      end,
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "supermd",
      },
      callback = function(args)
        vim.treesitter.start(args.buf, "supermd")
      end,
    })

  end,
}
