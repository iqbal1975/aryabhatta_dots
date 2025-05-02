return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  { "rcasia/neotest-bash" },
  { "fredrikaverpil/neotest-golang", version = "*" },
  { "alfaix/neotest-gtest" },
  { "nvim-neotest/neotest-plenary" },
  { "nvim-neotest/neotest-python" },
  { "rouge8/neotest-rust" },
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  { "nvim-neotest/neotest-vim-test" },
  opts = {
    -- Can be a list of adapters like what neotest expects,
    -- or a list of adapter names,
    -- or a table of adapter names, mapped to adapter configs.
    -- The adapter will then be automatically loaded with the config.
    -- adapters = {},
    -- Example for loading neotest-go with a custom config
    adapters = {
      ["neotest-bash"] = {},
      ["neotest-golang"] = {},
      ["neotest-gtest"] = {},
      ["neotest-plenary"] = {},
      ["neotest-python"] = {
        -- Here you can specify the settings for the adapter, i.e.
        -- python = ".venv/bin/python",
        dap = {
          justMyCode = false,
          console = "integratedTerminal",
        },
        args = { "--log-level", "DEBUG", "--quiet" },
        runner = "pytest",
      },
      ["neotest-rust"] = {
        args = { "--no-capture" },
        dap_adapter = "lldb",
      },
      ["neotest-vim-test"] = {
        ignore_file_types = { "lua", "go", "python", "rust", "vim" },
      },
    },
  },
}
