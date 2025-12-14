-- lua/plugins/slime.lua
return {
  'jpalardy/vim-slime',
  init = function()
    -- Default to using tmux as the target
    vim.g.slime_target = 'tmux'
    -- Default tmux target: current session, window 1, pane 0
    vim.g.slime_default_config = { socket_name = 'default', target_pane = '{last}' }
    -- Don’t prompt every time
    vim.g.slime_dont_ask_default = 1

    -- Optional: map <leader>sp to send paragraph, <leader>sl to send line
    vim.keymap.set('n', '<leader>sp', '<Plug>SlimeParagraphSend', { desc = 'Send Paragraph to REPL' })
    vim.keymap.set('n', '<leader>sl', '<Plug>SlimeLineSend', { desc = 'Send Line to REPL' })
    vim.keymap.set('v', '<leader>ss', '<Plug>SlimeRegionSend', { desc = 'Send Selection to REPL' })
  end,
}
