return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },

  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      ensure_installed = {
        "bash-debug-adapter",
        "codelldb",
        "debugpy",
        "delve",
        "eslint_d", -- ts/js linter
        "flake8",
        "go-debug-adapter",
        "java-debug-adapter",
        "java-test",
        "js-debug-adapter",
        "perl-debug-adapter",
        "php-debug-adapter",
        "prettier", -- ts/js formatter
        "shellcheck",
        "shfmt",
        "stylua", -- lua formatter
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "bashls",
        "clangd",
        "cssls",
        "emmet_ls",
        "eslint",
        "gopls",
        "harper_ls",
        "html",
        "hyprls",
        "intelephense",
        "jsonls",
        "julials",
        "lua_ls",
        "marksman",
        "prosemd_lsp",
        "pyright",
        "ruff",
        "rust_analyzer",
        "tailwindcss",
        "ts_ls",
        "yamlls",
        "zk",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })
  end,
}
