local Customize = {}

-- {{{ Customize documentation.
-- Customize table is a plugin name and true or false.  Using nvim_tree as the
-- example:
--   true - plugin is loaded
--  false - plugin is NOT loaded.
--
-- This is a quick way to determine when a customization is interfering with
-- your expected behavior or two plugins are impacting with each other.

-- ------------------------------------------------------------------------- }}}

Customize = {
  -- {{{ Enable or disable plugins.

  plugins = {
    -- ["ChatGPT.nvim"] = { enabled = true },
    -- ["LuaSnip"] = { enabled = true },
    -- ["SchemaStore.nvim"] = { enabled = true },
    -- ["alpha-nvim"] = { enabled = true },
    -- ["bufferline.nvim"] = { enabled = true },
    -- ["catppuccin"] = { enabled = true },
    -- ["cmp-buffer"] = { enabled = true },
    -- ["cmp-emoji"] = { enabled = true },
    -- ["cmp-nvim-lsp"] = { enabled = true },
    -- ["cmp-path"] = { enabled = true },
    -- ["cmp_luasnip"] = { enabled = true },
    -- ["crates.nvim"] = { enabled = true },
    -- ["dressing.nvim"] = { enabled = true },
    -- ["editorconfig"] = { enabled = true },
    -- ["flit.nvim"] = { enabled = true },
    -- ["friendly-snippets"] = { enabled = true },
    -- ["fzf"] = { enabled = false },
    -- ["fzf-lua"] = { enabled = false },
    -- ["gh.nvim"] = { enabled = true },
    -- ["gitsigns.nvim"] = { enabled = true },
    -- ["harpoon"] = { enabled = true },
    -- ["indent-blankline"] = { enabled = true },
    -- ["leap.nvim"] = { enabled = true },
    -- ["litee.nvim"] = { enabled = true },
    -- ["lualine.nvim"] = { enabled = true },
    -- ["mason.nvim"] = { enabled = true },
    -- ["mason-lspconfig.nvim"] = { enabled = true },
    -- ["mason-nvim-dap.nvim"] = { enabled = true },
    -- ["mind.nvim"] = { enabled = true },
    -- ["mini.ai"] = { enabled = true },
    -- ["mini.animate"] = { enabled = true },
    -- ["mini.bufremove"] = { enabled = true },
    -- ["mini.surround"] = { enabled = true },
    -- ["mini-comment"] = { enabled = true },
    -- ["mini-indentscope"] = { enabled = true },
    -- ["mini-pairs"] = { enabled = true },
    -- ["moonbow"] = { enabled = true },
    -- ["neo-tree.nvim"] = { enabled = true },
    -- ["neoconf.nvim"] = { enabled = true },
    -- ["neodev.nvim"] = { enabled = true },
    -- ["noice.nvim"] = { enabled = true },
    -- ["nui.nvim"] = { enabled = true },
    -- ["null-ls.nvim"] = { enabled = true },
    -- ["nvim-cmp"] = { enabled = true },
    -- ["nvim-colorizer.lua"] = { enabled = true },
    -- ["nvim-dap"] = { enabled = true },
    -- ["nvim-dap-virtual-text"] = { enabled = true },
    -- ["nvim-lspconfig"] = { enabled = true },
    -- ["nvim-navic"] = { enabled = true },
    -- ["nvim-notify"] = { enabled = true },
    -- ["nvim-spectre"] = { enabled = true },
    -- ["nvim-treesitter"] = { enabled = true },
    -- ["nvim-treesitter-textobjects"] = { enabled = true },
    -- ["nvim-ts-context-commentstring"] = { enabled = true },
    -- ["nvim-web-devicons"] = { enabled = true },
    -- ["onenord.nvim"] = { enabled = true },
    -- ["persistence.nvim"] = { enabled = true },
    -- ["plenary.nvim"] = { enabled = true },
    -- ["scope.nvim"] = { enabled = true },
    -- ["symbols-outline.nvim"] = { enabled = true },
    -- ["tailwindcss-colorizer-cmp.nvim"] = { enabled = true },
    -- ["telescope-dap.nvim"] = { enabled = true },
    -- ["telescope-file-browser.nvim"] = { enabled = true },
    -- ["telescope-project.nvim"] = { enabled = true },
    -- ["telescope-undo.nvim"] = { enabled = true },
    -- ["telescope.nvim"] = { enabled = true },
    -- ["tidy.nvim"] = { enabled = true },
    -- ["todo-comments.nvim"] = { enabled = true },
    -- ["toggleterm.nvim"] = { enabled = true },
    -- ["tokyonight.nvim"] = { enabled = true },
    -- ["trouble.nvim"] = { enabled = true },
    -- ["typescript.nvim"] = { enabled = true },
    -- ["trouble.nvim"] = { enabled = true },
    -- ["vim-illuminate"] = { enabled = true },
    -- ["vim-repeat"] = { enabled = true },
    -- ["vim-startuptime"] = { enabled = true },
    -- ["which-key.nvim"] = { enabled = true },
    -- ["zen-mode.nvim"] = { enabled = true },
    -- ["zk-nvim"] = { enabled = true },
  },

  -- ------------------------------------------------------------------------- }}}
  -- {{{ Debug Adapter Protocol (DAP) debuggers

  debuggers = {
    ["bash"] = { enabled = true },
    ["dart"] = { enabled = false },
    ["go"] = { enabled = true },
    ["haskell"] = { enabled = false },
    ["java"] = { enabled = false },
    ["lua"] = { enabled = true },
    ["python"] = { enabled = true },
    ["ruby"] = { enabled = false },
    ["rust"] = { enabled = true },
  },

  -- ------------------------------------------------------------------------- }}}
}

return Customize
