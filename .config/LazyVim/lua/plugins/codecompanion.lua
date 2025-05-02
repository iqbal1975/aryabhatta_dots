-- CodeCompanion configuration
-- AI assistant for Neovim

-- Configuration variables
local user_name = "Iqbal"
local selected_adapter = "openai"
local selected_model = "o1-mini" -- Options: "gpt-4o", "o1-2024-12-17", "o1-mini"

-- OpenAI adapter configuration
local function configure_openai()
  return require("codecompanion.adapters").extend("openai", {
    env = {
      api_key = "OPENAI_API_KEY",
    },
    schema = {
      model = {
        default = selected_model,
      },
    },
  })
end

-- Chat display configuration
local chat_display = {
  intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
  show_header_separator = false,
  separator = "─",
  show_references = true,
  show_settings = false,
  show_token_count = true,
  start_in_insert_mode = false,
  icons = {
    pinned_buffer = " ",
    watched_buffer = "👀 ",
  },
  debug_window = {
    width = vim.o.columns - 5,
    height = vim.o.lines - 2,
  },
  window = {
    layout = "vertical",
    position = nil,
    border = "single",
    height = 0.8,
    width = 0.45,
    relative = "editor",
    opts = {
      breakindent = true,
      cursorcolumn = false,
      cursorline = false,
      foldcolumn = "0",
      linebreak = true,
      list = false,
      numberwidth = 1,
      signcolumn = "no",
      spell = false,
      wrap = true,
    },
  },
  token_count = function(tokens)
    return " (" .. tokens .. " tokens)"
  end,
}

-- Diff display configuration
local diff_display = {
  enabled = true,
  close_chat_at = 240,
  layout = "vertical",
  opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
  provider = "default",
}

-- Chat strategy configuration
local chat_strategy = {
  adapter = selected_adapter,
  keymaps = {
    send = {
      modes = { n = "<CR>", i = "<CR>" },
    },
    close = {
      modes = { n = "<C-c>", i = "<C-c>" },
    },
  },
  roles = {
    llm = function(adapter)
      return "CodeCompanion (" .. adapter.formatted_name .. ")"
    end,
    user = user_name,
  },
}

-- Inline strategy configuration
local inline_strategy = {
  adapter = "copilot",
  keymaps = {
    accept_change = {
      modes = { n = "ga" },
      description = "Accept the suggested change",
    },
    reject_change = {
      modes = { n = "gr" },
      description = "Reject the suggested change",
    },
  },
}

return {
  "olimorris/codecompanion.nvim",
  -- enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "j-hui/fidget.nvim",
    -- "ravitemer/mcphub.nvim",
  },
  opts = {
    send_code = false,
    adapters = {
      openai = configure_openai,
    },
    display = {
      chat = chat_display,
      inline = {
        layout = "vertical", -- vertical|horizontal|buffer
      },
      diff = diff_display,
    },
    strategies = {
      chat = chat_strategy,
      inline = inline_strategy,
    },
    opts = {
      log_level = "DEBUG", -- or "TRACE"
      stream = true,
    },
  },
  init = function()
    require("plugins.codecompanion.fidget-spinner"):init()
  end,
}
