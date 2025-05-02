return {

  {
    "ldelossa/gh.nvim",
    -- enabled = false,
    dependencies = {
      {
        "ldelossa/litee.nvim",
        config = function()
          require("litee.lib").setup({
            tree = {
              icon_set = "codicons",
            },
            panel = {
              orientation = "left",
              panel_size = 30,
            },
          })
        end,
      },
    },
    config = function()
      require("litee.gh").setup()

      -- Github Keymaps
      local wk = require("which-key")
      wk.add({
        -- { "<leader>g", group = "Git" },
        { "<leader>gH", group = "GitHub" },
        { "<leader>gHc", group = "Commits" },
        { "<leader>gHcc", "<cmd>GHCloseCommit<cr>", desc = "Close" },
        { "<leader>gHce", "<cmd>GHExpandCommit<cr>", desc = "Expand" },
        { "<leader>gHco", "<cmd>GHOpenToCommit<cr>", desc = "Open To" },
        { "<leader>gHcp", "<cmd>GHPopOutCommit<cr>", desc = "Pop Out" },
        { "<leader>gHcz", "<cmd>GHCollapseCommit<cr>", desc = "Collapse" },
        -- { "<leader>gi", group = "Issues" },
        { "<leader>gP", "<cmd>GHPreviewIssue<cr>", desc = "Preview Issue" },
        -- { "<leader>gl", group = "Litee" },
        { "<leader>gT", "<cmd>LTPanel<cr>", desc = "Litee Toggle Panel" },
        { "<leader>gHp", group = "Pull Request" },
        { "<leader>gHpc", "<cmd>GHClosePR<cr>", desc = "Close" },
        { "<leader>gHpd", "<cmd>GHPRDetails<cr>", desc = "Details" },
        { "<leader>gHpe", "<cmd>GHExpandPR<cr>", desc = "Expand" },
        { "<leader>gHpo", "<cmd>GHOpenPR<cr>", desc = "Open" },
        { "<leader>gHpp", "<cmd>GHPopOutPR<cr>", desc = "PopOut" },
        { "<leader>gHpr", "<cmd>GHRefreshPR<cr>", desc = "Refresh" },
        { "<leader>gHpt", "<cmd>GHOpenToPR<cr>", desc = "Open To" },
        { "<leader>gHpz", "<cmd>GHCollapsePR<cr>", desc = "Collapse" },
        { "<leader>gHr", group = "Review" },
        { "<leader>gHrb", "<cmd>GHStartReview<cr>", desc = "Begin" },
        { "<leader>gHrc", "<cmd>GHCloseReview<cr>", desc = "Close" },
        { "<leader>gHrd", "<cmd>GHDeleteReview<cr>", desc = "Delete" },
        { "<leader>gHre", "<cmd>GHExpandReview<cr>", desc = "Expand" },
        { "<leader>gHrs", "<cmd>GHSubmitReview<cr>", desc = "Submit" },
        { "<leader>gHrz", "<cmd>GHCollapseReview<cr>", desc = "Collapse" },
        { "<leader>gHt", group = "Threads" },
        { "<leader>gHtc", "<cmd>GHCreateThread<cr>", desc = "Create" },
        { "<leader>gHtn", "<cmd>GHNextThread<cr>", desc = "Next" },
        { "<leader>gHtt", "<cmd>GHToggleThread<cr>", desc = "Toggle" },
      })
      -- Github Keymaps
    end,
  },

  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {},
  },

  -- {
  --   "pwntester/octo.nvim",
  --   enabled = false,
  --   cmd = "Octo",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("octo").setup({ enable_builtin = true })
  --     vim.cmd([[hi OctoEditable guibg=none]])
  --   end,
  --   keys = {
  --     { "<leader>O", "<cmd>Octo<cr>", desc = "Octo" },
  --   },
  -- },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      -- "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua", -- optional
    },
    config = true,
  },
}
