return {
  {
    "mfussenegger/nvim-dap",
    "leoluz/nvim-dap-go",
    "mfussenegger/nvim-dap-python",
    event = "VeryLazy",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
      },
      -- {
      --   "igorlfs/nvim-dap-view",
      --   opts = {
      --     windows = {
      --       terminal = {
      --         -- NOTE Don't copy paste this snippet
      --         -- Use the actual names for the adapters you want to hide
      --         -- `go` is known to not use the terminal.
      --         hide = { "go" },
      --       },
      --     },
      --   },
      -- },
    },

    config = function()
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })
      require("dap").defaults.fallback.terminal_win_cmd = "enew | set filetype=dap-terminal"
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function()
          require("dap.ext.autocompl").attach()
        end,
      })
    end,

    -- vim.api.nvim_create_autocmd({ "FileType" }, {
    --   pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
    --   callback = function(evt)
    --     vim.keymap.set("n", "q", "<C-w>q", { silent = true, buffer = evt.buf })
    --   end,
    -- }),
  },
}
