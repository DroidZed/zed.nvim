return {
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    priority = 49,
    dependencies = {
      'saghen/blink.cmp',
    },
    opts = {
      preview = {

        enable = true,
        enable_hybrid_mode = true,

        callbacks = {
          on_attach = function(_, wins)
            ---@type boolean
            local attach_state = spec.get({ 'preview', 'enable' }, { fallback = true, ignore_enable = true })

            if attach_state == false then
              return
            end

            for _, win in ipairs(wins) do
              vim.wo[win].conceallevel = 3
            end
          end,

          on_detach = function(_, wins)
            for _, win in ipairs(wins) do
              vim.wo[win].conceallevel = 0
            end
          end,

          on_enable = function(_, wins)
            local attach_state = spec.get({ 'preview', 'enable' }, { fallback = true, ignore_enable = true })

            if attach_state == false then
              ---@type string[]
              local preview_modes = spec.get({ 'preview', 'modes' }, { fallback = {}, ignore_enable = true })
              ---@type string[]
              local hybrid_modes = spec.get({ 'preview', 'hybrid_modes' }, { fallback = {}, ignore_enable = true })

              local concealcursor = ''

              for _, mode in ipairs(preview_modes) do
                if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ 'n', 'v', 'i', 'c' }, mode) then
                  concealcursor = concealcursor .. mode
                end
              end

              for _, win in ipairs(wins) do
                vim.wo[win].conceallevel = 3
                vim.wo[win].concealcursor = concealcursor
              end
            else
              for _, win in ipairs(wins) do
                vim.wo[win].conceallevel = 3
              end
            end
          end,

          on_disable = function(_, wins)
            for _, win in ipairs(wins) do
              vim.wo[win].conceallevel = 0
            end
          end,

          on_hybrid_enable = function(_, wins)
            ---@type string[]
            local preview_modes = spec.get({ 'preview', 'modes' }, { fallback = {}, ignore_enable = true })
            ---@type string[]
            local hybrid_modes = spec.get({ 'preview', 'hybrid_modes' }, { fallback = {}, ignore_enable = true })

            local concealcursor = ''

            for _, mode in ipairs(preview_modes) do
              if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ 'n', 'v', 'i', 'c' }, mode) then
                concealcursor = concealcursor .. mode
              end
            end

            for _, win in ipairs(wins) do
              vim.wo[win].concealcursor = concealcursor
            end
          end,

          on_hybrid_disable = function(_, wins)
            ---@type string[]
            local preview_modes = spec.get({ 'preview', 'modes' }, { fallback = {}, ignore_enable = true })
            local concealcursor = ''

            for _, mode in ipairs(preview_modes) do
              if vim.list_contains({ 'n', 'v', 'i', 'c' }, mode) then
                concealcursor = concealcursor .. mode
              end
            end

            for _, win in ipairs(wins) do
              vim.wo[win].concealcursor = concealcursor
            end
          end,

          on_mode_change = function(_, wins, current_mode)
            ---@type string[]
            local preview_modes = spec.get({ 'preview', 'modes' }, { fallback = {}, ignore_enable = true })
            ---@type string[]
            local hybrid_modes = spec.get({ 'preview', 'hybrid_modes' }, { fallback = {}, ignore_enable = true })

            local concealcursor = ''

            for _, mode in ipairs(preview_modes) do
              if vim.list_contains(hybrid_modes, mode) == false and vim.list_contains({ 'n', 'v', 'i', 'c' }, mode) then
                concealcursor = concealcursor .. mode
              end
            end

            for _, win in ipairs(wins) do
              if vim.list_contains(preview_modes, current_mode) then
                vim.wo[win].conceallevel = 3
                vim.wo[win].concealcursor = concealcursor
              else
                vim.wo[win].conceallevel = 0
                vim.wo[win].concealcursor = ''
              end
            end
          end,

          on_splitview_open = function(_, _, win)
            vim.wo[win].conceallevel = 3
            vim.wo[win].concealcursor = 'n'
          end,
        },

        map_gx = true,

        debounce = 150,
        icon_provider = 'internal',

        filetypes = { 'markdown', 'quarto', 'rmd', 'typst' },
        ignore_buftypes = { 'nofile' },
        raw_previews = {},

        modes = { 'n', 'no', 'c' },
        hybrid_modes = {},

        linewise_hybrid_mode = false,
        max_buf_lines = 1000,

        draw_range = { 2 * vim.o.lines, 2 * vim.o.lines },
        edit_range = { 0, 0 },

        splitview_winopts = {
          split = 'right',
        },
      },
    },
  },
}
