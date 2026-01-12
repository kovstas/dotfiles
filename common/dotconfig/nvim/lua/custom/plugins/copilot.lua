return {
  'zbirenbaum/copilot.lua',
  event = 'VeryLazy',
  opts = {
    suggestion = {
      enabled = true, -- allow suggestions when enabled
      auto_trigger = true, -- feel free to set false if you prefer manual triggers
      keymap = {
        accept = false,
        accept_word = false,
        accept_line = false,
        next = false,
        prev = false,
        dismiss = false,
      },
    },
    panel = { enabled = true },
    filetypes = { ['*'] = true },
  },
  config = function(_, opts)
    require('copilot').setup(opts)

    -- Start disabled by default
    local ok, cmd = pcall(require, 'copilot.command')
    if ok then
      local gh_copilot_enabled = os.getenv 'GH_COPILOT_ENABLED'
      if gh_copilot_enabled == nil or gh_copilot_enabled ~= 'true' then
        cmd.disable()
      end
    end

    -- Optional: your <S-Tab> accept mapping (works only when Copilot is enabled)
    vim.keymap.set('i', '<S-Tab>', function()
      local ok_s, s = pcall(require, 'copilot.suggestion')
      if ok_s and s.is_visible() then
        s.accept()
        return ''
      end
      return '<S-Tab>'
    end, { expr = true, silent = true, replace_keycodes = false })
  end,
}
