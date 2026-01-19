return {
  'sudo-tee/opencode.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'opencode_output' },
      },
      ft = { 'markdown', 'opencode_output' },
    },
    'folke/snacks.nvim',
  },
  config = function()
    require('opencode').setup {
      default_mode = 'build',
      keymap = {
        editor = {
          ['<leader>oc'] = { 'toggle' },
          ['<leader>of'] = { 'toggle_focus' },
          ['<leader>oi'] = { 'open_input' },
          ['<leader>oI'] = { 'open_input_new_session' },
          ['<leader>oo'] = { 'open_output' },
          ['<leader>oq'] = { 'close' },
          ['<leader>os'] = { 'select_session' },
          ['<leader>oS'] = { 'send_selection', mode = 'v' },
          ['<leader>op'] = { 'configure_provider' },
          ['<leader>od'] = { 'diff_open' },
          ['<leader>o]'] = { 'diff_next' },
          ['<leader>o['] = { 'diff_prev' },
          ['<leader>ox'] = { 'diff_close' },
          ['<leader>ora'] = { 'diff_revert_all_last_prompt' },
          ['<leader>ort'] = { 'diff_revert_this_last_prompt' },
          ['<leader>o/'] = { 'quick_chat', mode = { 'n', 'x' } },
        },
      },
      ui = {
        position = 'right',
        window_width = 0.40,
      },
    }
  end,
  keys = {
    { '<leader>o', nil, desc = 'AI/OpenCode' },
    { '<leader>oc', desc = 'Toggle OpenCode' },
    { '<leader>of', desc = 'Focus OpenCode' },
    { '<leader>oi', desc = 'Open input' },
    { '<leader>oI', desc = 'New session' },
    { '<leader>oo', desc = 'Open output' },
    { '<leader>oq', desc = 'Close' },
    { '<leader>os', desc = 'Select session' },
    { '<leader>oS', desc = 'Send selection', mode = 'v' },
    { '<leader>op', desc = 'Configure provider' },
    { '<leader>od', desc = 'Open diff' },
    { '<leader>o/', desc = 'Quick chat', mode = { 'n', 'x' } },
  },
}
