-- Completion plugin with support for LSPs and external sources that updates
-- on every keystroke with minimal overhead

-- https://www.lazyvim.org/extras/coding/blink
-- https://github.com/saghen/blink.cmp
-- Documentation site: https://cmp.saghen.dev/

-- NOTE: Specify the trigger character(s) used for luasnip
-- Configuration variables
local trigger_text = ";"
local disabled_filetypes = { "TelescopePrompt", "minifiles", "snacks_picker_input" }

-- Helper functions
local function is_filetype_enabled()
  local filetype = vim.bo[0].filetype
  return not vim.tbl_contains(disabled_filetypes, filetype)
end

local function create_snippet_transformer()
  return function(_, items)
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
    local trigger_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
    if trigger_pos then
      for _, item in ipairs(items) do
        if not item.trigger_text_modified then
          item.trigger_text_modified = true
          item.textEdit = {
            newText = item.insertText or item.label,
            range = {
              start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
              ["end"] = { line = vim.fn.line(".") - 1, character = col },
            },
          }
        end
      end
    end
    return items
  end
end

-- Source configurations
local source_configs = {
  lazydev = {
    name = "LazyDev",
    enabled = true,
    module = "lazydev.integrations.blink",
    kind = "LDev",
    score_offset = 100,
  },

  lsp = {
    name = "lsp",
    enabled = true,
    module = "blink.cmp.sources.lsp",
    kind = "LSP",
    min_keyword_length = 3,
    fallbacks = { "buffer" },
    score_offset = 85,
    transform_items = function(_, items)
      return vim.tbl_filter(function(item)
        return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
      end, items)
    end,
  },

  path = {
    name = "Path",
    enabled = true,
    module = "blink.cmp.sources.path",
    score_offset = 25,
    fallbacks = { "buffer" },
    min_keyword_length = 3,
    opts = {
      trailing_slash = false,
      label_trailing_slash = true,
      get_cwd = function(context)
        return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
      end,
      show_hidden_files_by_default = true,
    },
  },

  buffer = {
    name = "Buffer",
    enabled = true,
    max_items = 3,
    module = "blink.cmp.sources.buffer",
    min_keyword_length = 3,
    score_offset = 15, -- the higher the number, the higher the priority
    opts = {
      -- default to all visible buffers
      get_bufnrs = function()
        return vim
          .iter(vim.api.nvim_list_wins())
          :map(function(win)
            return vim.api.nvim_win_get_buf(win)
          end)
          :filter(function(buf)
            return vim.bo[buf].buftype ~= "nofile"
          end)
          :totable()
      end,
    },
  },

  git = {
    module = "blink-cmp-git",
    name = "Git",
    opts = {
      -- options for the blink-cmp-git
    },
  },

  -- Example on how to configure dadbod found in the main repo
  -- https://github.com/kristijanhusak/vim-dadbod-completion
  dadbod = {
    name = "Dadbod",
    module = "vim_dadbod_completion.blink",
    min_keyword_length = 3,
    score_offset = 85, -- the higher the number, the higher the priority
  },

  -- https://github.com/moyiz/blink-emoji.nvim
  emoji = {
    module = "blink-emoji",
    name = "Emoji",
    score_offset = 90, -- the higher the number, the higher the priority
    min_keyword_length = 2,
    opts = { insert = true }, -- Insert emoji (default) or complete its name
  },

  -- https://github.com/Kaiser-Yang/blink-cmp-dictionary
  -- In macOS to get started with a dictionary:
  -- cp /usr/share/dict/words ~/github/dotfiles-latest/dictionaries/words.txt
  --
  -- NOTE: For the word definitions make sure "wn" is installed
  -- brew install wordnet
  dictionary = {
    module = "blink-cmp-dictionary",
    name = "Dict",
    score_offset = 20, -- the higher the number, the higher the priority
    -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
    enabled = true,
    max_items = 10,
    min_keyword_length = 3,
    opts = {
      -- -- The dictionary by default now uses fzf, make sure to have it
      -- -- installed
      -- -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
      --
      -- Do not specify a file, just the path, and in the path you need to
      -- have your .txt files
      dictionary_directories = { vim.fn.expand("/srv/dictionaries") },
      -- Notice I'm also adding the words I add to the spell dictionary
      dictionary_files = {
        vim.fn.expand("/srv/dictionaries/en.utf-8.add"),
      },
      --  NOTE: To disable the definitions uncomment this section below
      --
      -- separate_output = function(output)
      --   local items = {}
      --   for line in output:gmatch("[^\r\n]+") do
      --     table.insert(items, {
      --       label = line,
      --       insert_text = line,
      --       documentation = nil,
      --     })
      --   end
      --   return items
      -- end,
    },
  },

  -- Command Line
  cmdline = {
    name = "cmdline",
    module = "blink.cmp.sources.cmdline",
    -- ignores cmdline completions when executing shell commands
    enabled = function()
      return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
    end,
  },

  omni = {
    name = "Omni",
    module = "blink.cmp.sources.complete_func",
    enabled = true,
    opts = {
      disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
    },
  },

  -- AI Companions
  -- Avante completion
  avante = {
    module = "blink-cmp-avante",
    name = "Avante",
    kind = "Avante",
    min_keyword_length = 3,
    score_offset = 90, -- the higher the number, the higher the priority
    async = true,
    opts = {
      -- options for blink-cmp-avante
    },
  },

  -- Code Companion
  codecompanion = {
    name = "CodeCompanion",
    module = "codecompanion.providers.completion.blink",
    enabled = true,
    kind = "CodeCompanion",
    score_offset = 95, -- show at a higher priority than lsp
    opts = {},
  },

  -- Copilot
  copilot = {
    name = "Copilot",
    enabled = true,
    module = "blink-cmp-copilot",
    kind = "Copilot",
    min_keyword_length = 3,
    score_offset = 90, -- the higher the number, the higher the priority
    async = true,
  },
}

-- Snippet configuration
local snippet_config = {
  name = "snippets",
  enabled = true,
  max_items = 15,
  min_keyword_length = 3,
  module = "blink.cmp.sources.snippets",
  score_offset = 85,
  should_show_items = function()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
    return before_cursor:match(trigger_text .. "%w*$") ~= nil
  end,
  -- Snippet-specific settings...
  transform_items = create_snippet_transformer(),
  opts = {
    use_show_condition = true,
    show_autosnippets = true,
  },
}

return {
  "saghen/blink.cmp",
  -- enabled = false,
  dependencies = {
    "Kaiser-Yang/blink-cmp-avante",
    "Kaiser-Yang/blink-cmp-dictionary",
    "Kaiser-Yang/blink-cmp-git",
    "moyiz/blink-emoji.nvim",
    "nvim-lua/plenary.nvim",
    "rafamadriz/friendly-snippets",
  },

  -- use a release tag to download pre-built binaries
  version = "*",
  event = { "InsertEnter", "CmdlineEnter" },

  -- Plugin configuration with cleaner structure...
  opts = function(_, opts)
    -- Enable/disable based on filetype
    opts.enabled = is_filetype_enabled

    -- Appearance settings
    opts.appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    }

    -- NOTE: The new way to enable LuaSnip
    -- Merge custom sources with the existing ones from lazyvim
    -- NOTE: by default lazyvim already includes the lazydev source, so not adding it here again
    -- Configure sources
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = {
        "avante",
        "codecompanion",
        "copilot",
        "lazydev",
        "lsp",
        "path",
        "snippets",
        "buffer",
        "dadbod",
        "emoji",
        "dictionary",
        "git",
        "omni",
      },

      providers = vim.tbl_extend("force", source_configs, { snippets = snippet_config }),
    })

    opts.cmdline = {
      enabled = true,
    }

    opts.completion = {
      --   keyword = {
      --     -- 'prefix' will fuzzy match on the text before the cursor
      --     -- 'full' will fuzzy match on the text before *and* after the cursor
      --     -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      --     range = "full",
      --   },
      -- menu = {
      --   border = "single",
      -- },
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        update_delay_ms = 50,
        treesitter_highlighting = true,
        window = {
          border = "rounded",
        },
      },
      -- Displays a preview of the selected item on the current line
      ghost_text = {
        enabled = true,
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      menu = {
        border = "rounded",
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
          treesitter = { "lsp" },
        },
      },
    }

    opts.snippets = {
      preset = "luasnip", -- Choose LuaSnip as the snippet engine
    }

    -- -- To specify the options for snippets
    -- opts.sources.providers.snippets.opts = {
    --   use_show_condition = true, -- Enable filtering of snippets dynamically
    --   show_autosnippets = true, -- Display autosnippets in the completion menu
    -- }

    -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    opts.fuzzy = { implementation = "prefer_rust_with_warning" }

    -- The default preset used by lazyvim accepts completions with enter
    -- I don't like using enter because if on markdown and typing
    -- something, but you want to go to the line below, if you press enter,
    -- the completion will be accepted
    -- https://cmp.saghen.dev/configuration/keymap.html#default
    opts.keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },

      ["<C-up>"] = { "scroll_documentation_up", "fallback" },
      ["<C-down>"] = { "scroll_documentation_down", "fallback" },
      ["<S-k>"] = { "scroll_documentation_up", "fallback" },
      ["<S-j>"] = { "scroll_documentation_down", "fallback" },

      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Esc>"] = { "hide", "fallback" },

      ["<A-1>"] = {
        function(cmp)
          cmp.accept({ index = 1 })
        end,
      },
      ["<A-2>"] = {
        function(cmp)
          cmp.accept({ index = 2 })
        end,
      },
      ["<A-3>"] = {
        function(cmp)
          cmp.accept({ index = 3 })
        end,
      },
      ["<A-4>"] = {
        function(cmp)
          cmp.accept({ index = 4 })
        end,
      },
      ["<A-5>"] = {
        function(cmp)
          cmp.accept({ index = 5 })
        end,
      },
      ["<A-6>"] = {
        function(cmp)
          cmp.accept({ index = 6 })
        end,
      },
      ["<A-7>"] = {
        function(cmp)
          cmp.accept({ index = 7 })
        end,
      },
      ["<A-8>"] = {
        function(cmp)
          cmp.accept({ index = 8 })
        end,
      },
      ["<A-9>"] = {
        function(cmp)
          cmp.accept({ index = 9 })
        end,
      },
      ["<A-0>"] = {
        function(cmp)
          cmp.accept({ index = 10 })
        end,
      },
    }

    return opts
  end,
}
