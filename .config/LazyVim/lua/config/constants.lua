local Constants = {}

-- {{{ Begin Constants table.  These are items used through out Neovim.

Constants = {

  -- ----------------------------------------------------------------------- }}}
  -- {{{ Display borders

  display_border = {
    border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
  },

  -- ----------------------------------------------------------------------- }}}
  -- {{{ keybinding options

  keybind_opts = {
    normal = {
      mode = "n", -- NORMAL mode
      prefix = "<leader>", -- Override this value.
      buffer = nil, -- Global mappings. Specify a buffer number for buffer
      --   local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
    },

    visual = {
      mode = "v", -- VISUAL mode
      prefix = "<leader>", -- Override this value.
      buffer = nil, -- Global mappings. Specify a buffer number for buffer
      -- local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
    },
  },
  -- ----------------------------------------------------------------------- }}}
  -- {{{ End Constants table.
}
-- ------------------------------------------------------------------------- }}}

return Constants
