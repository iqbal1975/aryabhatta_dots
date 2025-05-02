return {
  {
    "vhyrro/luarocks.nvim",
    -- enabled = false,
    priority = 1001, -- We'd like this plugin to load first out of the rest
    config = true, -- This automatically runs `require("luarocks-nvim").setup()`
    opts = {},
  },
  {
    "nvim-neorg/neorg",
    -- enabled = false,
    dependencies = { "luarocks.nvim" },
    -- put any other flags you wanted to pass to lazy here!
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = function()
      local neorgPath = "~/Documents/Neorg"
      require("neorg").setup({
        -- put any of your previous config here
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.keybinds"] = {}, -- Adds default keybindings
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          }, -- Enables support for completion plugins
          ["core.journal"] = {}, -- Enables support for the journal module
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                work = neorgPath .. "/work",
                home = neorgPath .. "/home",
              },
              default_workspace = "home",
            },
          },
          ["core.presenter"] = {
            config = {
              zen_mode = "zen-mode",
            },
          },
          ["core.qol.todo_items"] = {
            config = {
              create_todo_parents = true,
            },
          },
        },
      })
    end,
  },
}
