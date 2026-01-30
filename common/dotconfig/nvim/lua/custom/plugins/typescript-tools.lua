return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  opts = {
    settings = {
      -- Performance: spawn separate tsserver for diagnostics
      separate_diagnostic_server = true,
      publish_diagnostic_on = 'insert_leave',
      -- Expose all code actions
      expose_as_code_action = 'all',
      -- Inlay hints configuration
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
  keys = {
    { '<leader>T', nil, desc = '[T]ypeScript' },
    { '<leader>To', '<cmd>TSToolsOrganizeImports<cr>', desc = '[O]rganize imports' },
    { '<leader>Ts', '<cmd>TSToolsSortImports<cr>', desc = '[S]ort imports' },
    { '<leader>Tu', '<cmd>TSToolsRemoveUnused<cr>', desc = 'Remove [U]nused' },
    { '<leader>Ti', '<cmd>TSToolsAddMissingImports<cr>', desc = 'Add missing [I]mports' },
    { '<leader>Tf', '<cmd>TSToolsFixAll<cr>', desc = '[F]ix all' },
    { '<leader>Td', '<cmd>TSToolsGoToSourceDefinition<cr>', desc = 'Go to source [D]efinition' },
    { '<leader>Tr', '<cmd>TSToolsRenameFile<cr>', desc = '[R]ename file' },
    { '<leader>TR', '<cmd>TSToolsFileReferences<cr>', desc = 'File [R]eferences' },
  },
}
