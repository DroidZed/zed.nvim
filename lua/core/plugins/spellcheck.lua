return {
  {
    'nvimtools/none-ls.nvim',
    event = 'VeryLazy',
    dependencies = { 'davidmh/cspell.nvim' },
    opts = function(_, opts)
      local cspell = require 'cspell'
      local config = {
        on_add_to_json = function(payload)
          os.execute(
            string.format(
              "jq -S '.words |= sort' %s > %s.tmp && mv %s.tmp %s",
              payload.cspell_config_path,
              payload.cspell_config_path,
              payload.cspell_config_path,
              payload.cspell_config_path
            )
          )
        end,
        config_file_preferred_name = 'cspell.json',
        cspell_config_dirs = { '~/.config/' },
      }

      opts.sources = opts.sources or {}
      table.insert(
        opts.sources,
        cspell.diagnostics.with {
          config = config,
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.HINT
          end,
        }
      )
      table.insert(
        opts.sources,
        cspell.code_actions.with {
          config = config,
        }
      )
    end,
  },
}
