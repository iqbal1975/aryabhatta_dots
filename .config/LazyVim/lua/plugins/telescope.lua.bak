-- Customize Telescope
return {
  "nvim-telescope/telescope.nvim",
  enabled = false,
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-dap.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-project.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "debugloop/telescope-undo.nvim" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        prompt_prefix = " ",
        selection_caret = " ",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          i = {
            ["<c-t>"] = function(...)
              return require("trouble.providers.telescope").open_with_trouble(...)
            end,
            ["<a-t>"] = function(...)
              return require("trouble.providers.telescope").open_selected_with_trouble(...)
            end,
            ["<C-Down>"] = function(...)
              return actions.cycle_history_next(...)
            end,
            ["<C-Up>"] = function(...)
              return actions.cycle_history_prev(...)
            end,
            ["<C-f>"] = function(...)
              return actions.preview_scrolling_down(...)
            end,
            ["<C-b>"] = function(...)
              return actions.preview_scrolling_up(...)
            end,
            ["<C-j>"] = function(...)
              return actions.move_selection_next(...)
            end,
            ["<C-k>"] = function(...)
              return actions.move_selection_previous(...)
            end,
            ["<C-p>"] = function(...)
              return actions.layout.toggle_preview(...)
            end,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
          n = {
            ["j"] = function(...)
              return actions.move_selection_next(...)
            end,
            ["k"] = function(...)
              return actions.move_selection_previous(...)
            end,
            ["gg"] = function(...)
              return actions.move_to_top(...)
            end,
            ["G"] = function(...)
              return actions.move_to_bottom(...)
            end,
            ["<C-p>"] = function(...)
              return actions.layout.toggle_preview(...)
            end,
            ["q"] = function(...)
              return require("telescope.actions").close(...)
            end,
          },
        },
      },
      extensions = {
        project = {
          base_dirs = {
            "~/Workspace",
          },
        },
        undo = {
          use_delta = true,
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.4,
          },
        },
      },
    })

    telescope.load_extension("dap")
    telescope.load_extension("file_browser")
    telescope.load_extension("fzf")
    telescope.load_extension("project")
    telescope.load_extension("undo")
  end,

  keys = {
    -- Project Browser
    {
      "<leader>fP",
      ":Telescope project display_type=full<CR>",
      desc = "Find Project",
    },
    -- add a keymap to browse plugin files
    -- stylua: ignore
    {
      "<leader>fp",
      function()
        require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
      end,
      desc = "Find Plugin File",
    },
    -- Telescope File Browser
    {
      "<leader>sB",
      ":Telescope file_browser path=%:p:h=%:p:h<cr>",
      desc = "Browse Files",
    },
    -- Telescope Live Grep in cwd
    {
      "<leader>fs",
      "<cmd>Telescope live_grep<cr>",
      desc = "Find String in cwd",
    },
    -- Telescope Live Grep under Cursor
    {
      "<leader>fc",
      "<cmd>Telescope grep_string<cr>",
      desc = "Find String under Cursor in cwd",
    },
  },
}
