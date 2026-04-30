return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
  	triggers = {  
    	{ "<leader>?", mode = { "n", "v" } }, -- Only trigger on ? key in normal and visual modes  
  	},  
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
} 
