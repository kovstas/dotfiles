return {
  'Aietes/esp32.nvim',
  dependencies = { 'folke/snacks.nvim' },
  opts = {
    idf_path = '~/esp/esp-idf',
    export_path = '~/esp/esp-idf/export.sh',
    build_dir = 'build',
  },
  config = function(_, opts)
    require('esp32').setup(opts)
  end,
  keys = {
    {
      '<leader>em',
      function()
        require('esp32').pick 'monitor'
      end,
      desc = 'ESP32: Pick and Monitor',
    },
  },
}
