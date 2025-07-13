return {
  'cappyzawa/telescope-terraform.nvim',
  ft = { 'terraform', 'hcl' },
  config = function()
    LazyVim.on_load('telescope.nvim', function()
      require('telescope').load_extension 'terraform'
    end)
  end,
}
