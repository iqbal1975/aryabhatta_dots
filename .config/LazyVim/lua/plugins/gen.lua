return {
  {
    "David-Kunz/gen.nvim",
    config = function()
      vim.keymap.set("v", "<leader>cn", ":Gen<CR>")
      vim.keymap.set("n", "<leader>cn", ":Gen<CR>")
      require("gen").model = "codellama"
      require("gen").container = "ollama"
    end,
  },

  { "augmentcode/augment.vim" },
}
