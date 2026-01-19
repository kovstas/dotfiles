return {
  {
    'scalameta/nvim-metals',
    dependencies = {
      {
        'j-hui/fidget.nvim',
        opts = {},
      },
      {
        'mfussenegger/nvim-dap',
        config = function(self, opts)
          -- Debug settings if you're using nvim-dap
          local dap = require 'dap'

          dap.configurations.scala = {
            {
              type = 'scala',
              request = 'launch',
              name = 'RunOrTest',
              metals = {
                runType = 'runOrTestFile',
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = 'scala',
              request = 'launch',
              name = 'Test Target',
              metals = {
                runType = 'testTarget',
              },
            },
          }
        end,
      },
    },
    ft = { 'scala', 'sbt', 'java' },
    opts = function()
      local metals_config = require('metals').bare_config()

      -- Example of settings
      metals_config.settings = {
        serverVersion = 'latest.stable',
        showImplicitArguments = true,
        excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
        bloopJvmProperties = {
          '-Xmx4G',
          '-Xss8M',
        },
        -- Java 21 module system exports for Metals JavacMtags (harmless for Java 17)
        serverProperties = {
          '-Xmx4G',
          '-Xss4m',
          '--add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED',
          '--add-exports=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED',
          '--add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED',
          '--add-exports=jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED',
          '--add-exports=jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED',
          '--add-exports=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED',
          '--add-exports=jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED',
          '--add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED',
          '--add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED',
          '--add-opens=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED',
          '--add-opens=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED',
          '--add-opens=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED',
          '--add-opens=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED',
          '--add-opens=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED',
          '--add-opens=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED',
        },
      }

      -- *READ THIS*
      -- I *highly* recommend setting statusBarProvider to either "off" or "on"
      --
      -- "off" will enable LSP progress notifications by Metals and you'll need
      -- to ensure you have a plugin like fidget.nvim installed to handle them.
      --
      -- "on" will enable the custom Metals status extension and you *have* to have
      -- a have settings to capture this in your statusline or else you'll not see
      -- any messages from metals. There is more info in the help docs about this
      metals_config.init_options.statusBarProvider = 'off'

      -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
      metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()

      metals_config.on_attach = function(client, bufnr)
        require('metals').setup_dap()

        local map = function(mode, keys, desc, func)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'Metals: ' .. desc })
        end

        -- LSP mappings
        map('n', 'gD', 'Go to defenition', vim.lsp.buf.definition)
        map('n', 'K', 'Hover', vim.lsp.buf.hover)
        map('n', 'gi', 'Implementation', vim.lsp.buf.implementation)
        map('n', 'gr', 'References', vim.lsp.buf.references)
        map('n', 'gds', 'Document Symbol', vim.lsp.buf.document_symbol)
        map('n', 'gws', 'Workspace Symbol', vim.lsp.buf.workspace_symbol)
        map('n', '<leader>cl', 'Codelens', vim.lsp.codelens.run)
        map('n', '<leader>sh', 'Signature Help', vim.lsp.buf.signature_help)
        map('n', '<leader>rn', 'Rename', vim.lsp.buf.rename)
        map('n', '<leader>f', 'Fomat', vim.lsp.buf.format)
        map('n', '<leader>ca', 'Code Action', vim.lsp.buf.code_action)

        map('n', '<leader>ws', 'Hover Worksheet', function()
          require('metals').hover_worksheet()
        end)

        -- all workspace diagnostics
        map('n', '<leader>aa', 'Workspace diagnostic', vim.diagnostic.setqflist)

        -- all workspace errors
        map('n', '<leader>ae', 'Workspace errors', function()
          vim.diagnostic.setqflist { severity = 'E' }
        end)

        -- all workspace warnings
        map('n', '<leader>aw', 'Workspace warnings', function()
          vim.diagnostic.setqflist { severity = 'W' }
        end)

        -- buffer diagnostics only
        map('n', '<leader>d', 'Buffer diagnostics', vim.diagnostic.setloclist)

        map('n', '[c', 'Goto Prev', function()
          vim.diagnostic.goto_prev { wrap = false }
        end)

        map('n', ']c', 'Goto Next', function()
          vim.diagnostic.goto_next { wrap = false }
        end)

        -- Example ma`ppings for usage with nvim-dap. If you don't use that, you can
        -- skip these
        map('n', '<leader>dc', 'Debug skip these', function()
          require('dap').continue()
        end)

        map('n', '<leader>dr', 'Toggle', function()
          require('dap').repl.toggle()
        end)

        map('n', '<leader>dK', 'Hover', function()
          require('dap.ui.widgets').hover()
        end)

        map('n', '<leader>dt', 'Toggle breakpoint', function()
          require('dap').toggle_breakpoint()
        end)

        map('n', '<leader>dso', 'Step Over', function()
          require('dap').step_over()
        end)

        map('n', '<leader>dsi', 'Step Into', function()
          require('dap').step_into()
        end)

        map('n', '<leader>dl', 'Run last', function()
          require('dap').run_last()
        end)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = self.ft,
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'scala' })
    end,
  },
}
