return {

  -- Tokyonight Colorscheme
  { "folke/tokyonight.nvim" },

  -- Catppuccin Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = true,
  },

  -- Dracula Colorscheme
  { "Mofiqul/dracula.nvim" },

  -- Gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
  },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_background = "hard"
      -- vim.cmd.colorscheme('gruvbox-material')
    end,
  },

  -- Moonbow Colorscheme
  { "arturgoms/moonbow.nvim" },

  -- OneNord Colorscheme
  { "rmehri01/onenord.nvim" },

  -- Oxocarbon Colorscheme
  { "nyoom-engineering/oxocarbon.nvim" },

  {
    "LazyVim/LazyVim",
    opts = {
      -- Catppuccin Colorscheme
      -- colorscheme = "catppuccin",
      -- Dracula Colorscheme
      -- colorscheme = "dracula",
      -- Gruvbox Colorscheme
      colorscheme = "gruvbox",
      -- colorscheme = "gruvbox-material",
      -- Moonbow Colorscheme
      -- colorscheme = "moonbow",
      -- Oxocarbon Colorscheme
      -- colorscheme = "oxocarbon",
      -- Tokyonight Colorscheme
      -- colorscheme = "tokyonight",
      -- style = "night",
    },
  },
}
