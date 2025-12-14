return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    require('venv-selector').setup {
      auto_refresh = true,
    }
  end,
  keys = {
    { '<leader>cv', '<cmd>VenvSelect<cr>', desc = 'Select VirtualEnv' },
    { '<leader>cV', '<cmd>VenvSelectCached<cr>', desc = 'Use Cached VirtualEnv' },
  },
}
