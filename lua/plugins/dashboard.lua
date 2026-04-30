return {
	'nvimdev/dashboard-nvim',
	event = 'VimEnter',
	config = function()
		require('dashboard').setup {
      		shortcuts = {
				desc = 'Lua Files',
				group = 'Number',
				action = 'Telsescope find_files',
				key = 'l'
			},
			highlights = {
				lambda = 'DashboardLambda',
				key = 'DashboardKey',
				desc = 'DashboardDesc',
				date = 'DashboardDate',
				footer = 'DashboardFooter',
		    },

			layout = {
				top_offset = 8,
				date_top_offset = 3,
				plugin_info_offset = 5,
				shortcuts_top_offset = 3,
			},
    	}
  	end,
  	dependencies = { {'nvim-tree/nvim-web-devicons'}}
} 
