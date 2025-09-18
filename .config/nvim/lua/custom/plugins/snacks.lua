-- lua/custom/plugins/snacks_copilot_toggle.lua
return {
  'folke/snacks.nvim',
  event = 'VeryLazy',
  dependencies = { 'zbirenbaum/copilot.lua' },
  opts = function(_, opts)
    opts = opts or {}
    local snacks = require 'snacks'

    -- Track state; start disabled
    vim.g.snacks_copilot_enabled = false

    snacks
      .toggle({
        name = 'Toggle (Copilot Completion)',
        color = { enabled = 'azure', disabled = 'orange' },
        get = function()
          return vim.g.snacks_copilot_enabled
        end,
        set = function(state)
          vim.g.snacks_copilot_enabled = not not state
          -- make sure Copilot is loaded before toggling
          pcall(function()
            require('lazy').load { plugins = { 'copilot.lua' } } -- plugin name = repo tail
          end)
          local cmd = require 'copilot.command'
          if state then
            cmd.enable()
          else
            cmd.disable()
          end
        end,
      })
      :map '<leader>at' -- press <leader> a t to toggle
    return opts
  end,
}
