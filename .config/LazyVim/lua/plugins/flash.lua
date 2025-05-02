return {
  {
    "folke/flash.nvim",
    -- enabled = false,
    event = "VeryLazy",
    -- ---@type Flash.Config
    opts = {
      search = {
        -- If mode is set to the default "exact" if you mistype a word, it will
        -- exit flash, and if then you type "i" for example, you will start
        -- inserting text and fuck up your file outside
        --
        -- Search for me adds a protection layer, so if you mistype a word, it
        -- doesn't exit
        mode = "search",
      },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
