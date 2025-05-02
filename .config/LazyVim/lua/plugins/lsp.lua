return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "saghen/blink.cmp" },
    { "antosha417/nvim-lsp-file-operations", config = true },
    {
      "b0o/SchemaStore.nvim",
      version = false, -- last release is way too old
    },
    { "jose-elias-alvarez/typescript.nvim" },
  },
  optional = true,
  opts = {
    diagnostics = {
      virtual_text = false,
      virtual_lines = true,
    },
  },
  -- setup = {},
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    local keymap = vim.keymap -- for conciseness

    local opts = { noremap = true, silent = true }
    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Goto Declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Goto Definition"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      opts.desc = "Goto Implementation"
      keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gT", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart Rename"
      keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts) -- smart rename

      opts.desc = "Show Buffer Diagnostics"
      keymap.set("n", "<leader>xD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

      opts.desc = "Show Line Diagnostics"
      keymap.set("n", "<leader>xd", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Go to Previous Diagnostic"
      keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

      opts.desc = "Go to Next Diagnostic"
      keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>cR", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
    end

    -- configure clangd server
    lspconfig["clangd"].setup({
      capabilities = vim.tbl_deep_extend("force", capabilities, {
        offsetEncoding = { "utf-16" },
      }),
      on_attach = on_attach,
    })

    -- configure css server
    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure emmet language server
    lspconfig["emmet_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    -- configure eslint server
    lspconfig["eslint"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
        workingDirectory = { mode = "auto" },
      },
    })

    -- configure gopls server
    lspconfig["gopls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure graphql language server
    lspconfig["graphql"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    -- configure harper server
    lspconfig["harper_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      enabled = true,
      filetypes = { "markdown" },
      settings = {
        ["harper-ls"] = {
          userDictPath = "~/apps/dictionaries/en.utf-8.add",
          linters = {
            ToDoHyphen = false,
            -- SentenceCapitalization = true,
            -- SpellCheck = true,
          },
          isolateEnglish = true,
          markdown = {
            -- [ignores this part]()
            -- [[ also ignores my marksman links ]]
            IgnoreLinkTitle = true,
          },
        },
      },
    })

    -- configure html server
    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure jdtls server
    lspconfig["jdtls"].setup({
      -- Override the default jdtls server startup to use nvim-jdtls.
      jdtls = function()
        -- The lspconfig configuration for jdtls contains two useful items:
        -- 1. The list of filetypes on which to match.
        -- 2. Custom method for finding the root for a java project.
        local lsp_config = require("lspconfig.server_configurations.jdtls").default_config
        local find_java_project_root = lsp_config.root_dir
        local filetypes = lsp_config.filetypes
        -- lookup paths for java test and debugger package
        local mason_registry = require("mason-registry")
        local bundles = {}
        if mason_registry.has_package("java-test") and mason_registry.has_package("java-debug-adapter") then
          -- jdtls tools configuration for debugging support
          local java_test_pkg = mason_registry.get_package("java-test")
          local java_test_path = java_test_pkg:get_install_path()
          local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
          local java_dbg_path = java_dbg_pkg:get_install_path()
          local jar_patterns = {
            java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
            java_test_path .. "/extension/server/*.jar",
          }
          for _, jar_pattern in ipairs(jar_patterns) do
            for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
              table.insert(bundles, bundle)
            end
          end
        end
        -- Attach jdtls for the proper filetypes (i.e. java).
        -- Existing server will be reused if the root_dir matches.
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("MyJdtls", { clear = true }),
          pattern = filetypes,
          callback = function()
            local fname = vim.api.nvim_buf_get_name(0)
            local root_dir = find_java_project_root(fname)
            local project_name = root_dir and vim.fs.basename(root_dir)
            local cmd = { "jdtls" }
            if project_name then
              local jdtls_cache_dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "jdtls", project_name)
              vim.list_extend(cmd, {
                "-configuration",
                vim.fs.joinpath(jdtls_cache_dir, "config"),
                "-data",
                vim.fs.joinpath(jdtls_cache_dir, "workspace"),
              })
            end
            local jdtls_base_config = {
              on_attach = require("lazyvim.util").on_attach(function(_, buffer)
                if mason_registry.has_package("java-test") then
                  -- custom keymaps for Java test runner (not yet compatible with neotest)
                  vim.keymap.set("n", "<leader>tT", function()
                    require("jdtls").pick_test({ bufnr = buffer })
                  end, { buffer = buffer, desc = "Run specific Test" })
                  vim.keymap.set("n", "<leader>tt", function()
                    require("jdtls").test_class({ bufnr = buffer })
                  end, { buffer = buffer, desc = "Run File" })
                  vim.keymap.set("n", "<leader>tr", function()
                    require("jdtls").test_nearest_method({ bufnr = buffer })
                  end, { buffer = buffer, desc = "Run nearest" })
                end
                if mason_registry.has_package("java-debug-adapter") then
                  -- custom init for Java debugger
                  require("jdtls").setup_dap({ hotcodereplace = "auto" })
                  require("jdtls.dap").setup_dap_main_class_configs()
                end
                require("jdtls.setup").add_commands()
              end),
              cmd = cmd,
              root_dir = root_dir,
              init_options = {
                bundles = bundles,
              },
            }
            local jdtls_opts = require("lazyvim.util").opts("nvim-jdtls")
            require("jdtls").start_or_attach(vim.tbl_deep_extend("force", jdtls_opts or {}, jdtls_base_config))
            require("which-key").register({ c = { x = { name = "Extract" } } }, { prefix = "<leader>" })
          end,
        })
        return true -- avoid duplicate servers
      end,
      capabilities = capabilities,
      on_attach = on_attach,
      -- stylua: ignore
      keys = {
        { "<leader>co", function() require("jdtls").organize_imports() end, desc = "Organize Imports", },
        { "<leader>cR", function() require("jdtls").rename_file() end, desc = "Rename File", },
        { "<leader>cxv", function() require("jdtls").extract_variable() end, desc = "Extract Variable", },
        { "<leader>cxv", function() require("jdtls").extract_variable({ visual = true }) end, mode = "v", desc = "Extract Variable", },
        { "<leader>cxc", function() require("jdtls").extract_constant() end, desc = "Extract Constant", },
        { "<leader>cxc", function() require("jdtls").extract_constant({ visual = true }) end, mode = "v", desc = "Extract Constant", },
        { "<leader>cxm", function() require("jdtls").extract_method({ visual = true }) end, mode = "v", desc = "Extract Method", },
      },
    })

    -- configure jsonls server
    lspconfig["jsonls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure lua server (with special settings)
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = { -- custom settings for lua
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim", "Snacks" },
            telemetry = { enable = false },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- configure marksman server
    lspconfig["marksman"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure prisma orm server
    lspconfig["prismals"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure python server
    lspconfig["pyright"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure python server
    lspconfig["ruff_lsp"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure rust_analyzer server
    -- lspconfig["rust_analyzer"].setup({
    --   capabilities = capabilities,
    --   on_attach = on_attach,
    -- })

    -- configure svelte server
    lspconfig["svelte"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure tailwindcss server
    lspconfig["tailwindcss"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes_exclude = { "markdown" },
    })

    -- configure typescript server with plugin
    lspconfig["tsserver"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
