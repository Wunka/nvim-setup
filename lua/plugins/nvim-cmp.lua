-- ~/.config/nvim/lua/plugins/cmp.lua
return {
  -- Completion engine
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet engine
      'L3MON4D3/LuaSnip',

      -- LSP completion source
      'hrsh7th/cmp-nvim-lsp',

      -- Snippet completions
      'saadparwaiz1/cmp_luasnip',

      -- Buffer completions
      'hrsh7th/cmp-buffer',

      -- Path completions
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end
  },
}

