-- Avante.nvim configuration
-- AI assistant for Neovim

-- Model configurations
local models = {
  claude = {
    endpoint = "https://api.anthropic.com",
    model = "claude-3-7-sonnet",
    timeout = 30000,
    temperature = 0,
    max_tokens = 4096,
    disable_tools = true,
  },

  openai = {
    endpoint = "https://api.openai.com/v1",
    model = "o1-mini",
    timeout = 30000,
    temperature = 0,
    max_tokens = 4096,
    max_completion_tokens = 8192,
    reasoning_effort = "high", -- only supported for "o" models
    disable_tools = true,
  },
}

-- Selected provider
local selected_provider = "openai" -- Options: "openai", "claude"

-- Optional dependencies configuration
local optional_deps = {
  {
    -- Support for image pasting
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = { insert_mode = true },
        use_absolute_path = true, -- required for Windows users
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = { file_types = { "markdown", "Avante" } },
    ft = { "markdown", "Avante" },
  },
}

-- Required dependencies
local required_deps = {
  "nvim-treesitter/nvim-treesitter",
  "stevearc/dressing.nvim",
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
}

return {
  {
    "yetone/avante.nvim",
    -- enabled = false, -- set this to true to enable the plugin
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = selected_provider,
      claude = models.claude,
      openai = models.openai,
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = vim.tbl_extend("force", required_deps, optional_deps),
  },
}
