return {
  "ThePrimeagen/refactoring.nvim",
  -- enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("refactoring").setup({
      -- prompt for return type
      prompt_func_return_type = {
        c = true,
        cpp = true,
        go = true,
        java = true,
      },
      -- prompt for function parameters
      prompt_func_param_type = {
        c = true,
        cpp = true,
        go = true,
        java = true,
      },
    })

    local wk = require("which-key")
    wk.add({
      { "<leader>R", group = "Refactoring" },
      { "<leader>Rb", group = "Block" },
      { "<leader>Re", group = "Extract" },
      { "<leader>Ri", group = "Inline" },
    })

    -- Refactoring Keymaps
    local refactor = require("refactoring")

    -- Extract function supports only Visual mode
    vim.keymap.set("x", "<leader>Ree", function()
      refactor.refactor("Extract Function")
    end, { desc = "V Extract Function" })
    vim.keymap.set("x", "<leader>Ref", function()
      refactor.refactor("Extract Function To File")
    end, { desc = "V Extract Function to File" })

    -- Extract variable supports only Visual mode
    vim.keymap.set("x", "<leader>Rev", function()
      refactor.refactor("Extract Variable")
    end, { desc = "V Extract Variable" })

    -- Inline func supports only Normal
    vim.keymap.set("n", "<leader>Rif", function()
      refactor.refactor("Inline Function")
    end, { desc = "N Inline Function" })

    -- Inline var supports both Normal and Visual mode
    vim.keymap.set({ "n", "x" }, "<leader>Riv", function()
      refactor.refactor("Inline Variable")
    end, { desc = "N,X Inline Variable" })

    -- Extract block supports only Normal mode
    vim.keymap.set("n", "<leader>Rbe", function()
      refactor.refactor("Extract Block")
    end, { desc = "N Extract Block" })
    vim.keymap.set("n", "<leader>Rbf", function()
      refactor.refactor("Extract Block To File")
    end, { desc = "N Extract Block to File" })

    -- Prompt for a refactor to apply when the remap is triggered
    vim.keymap.set({ "n", "x" }, "<leader>Rn", function()
      refactor.select_refactor()
    end, { desc = "N,X Refactoring using in-built Neovim" })
    -- Note that not all refactor support both Normal and Visual mode

    -- You can also use below = true here to change the position of the printf
    -- statement (or set two remaps for either one). This remap must be made in normal mode.
    vim.keymap.set("n", "<leader>Rp", function()
      refactor.debug.printf({ below = false })
    end, { desc = "N Print Debug" })

    -- Print Var
    -- Supports both Normal and Visual mode
    vim.keymap.set({ "x", "n" }, "<leader>Rv", function()
      require("refactoring").debug.print_var()
    end, { desc = "N,X Print Variable" })

    -- Supports only Normal mode
    vim.keymap.set("n", "<leader>Rc", function()
      refactor.debug.cleanup({})
    end, { desc = "N Clean Debug" })
    -- Refactoring Keymaps
  end,
}
