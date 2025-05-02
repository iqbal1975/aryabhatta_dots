return {
  "mickael-menu/zk-nvim",
  config = function()
    require("zk").setup()

    local wk = require("which-key")
    wk.add({
      { "<leader>z", group = "Zk Notes" },
    })
  end,

  -- Zk Keymaps
  -- Create a new note after asking for its title.
  vim.keymap.set(
    "n",
    "<leader>zn",
    "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
    { noremap = true, silent = false, desc = "Create New Note" }
  ),
  -- Open notes.
  vim.keymap.set(
    "n",
    "<leader>zo",
    "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
    { noremap = true, silent = false, desc = "Open Notes" }
  ),
  -- Open notes associated with the selected tags.
  vim.keymap.set(
    "n",
    "<leader>zt",
    "<Cmd>ZkTags<CR>",
    { noremap = true, silent = false, desc = "Open Notes with Tags" }
  ),
  -- Search for the notes matching a given query.
  vim.keymap.set(
    "n",
    "<leader>zf",
    "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
    { noremap = true, silent = false, desc = "Search Notes Matching" }
  ),
  -- Search for the notes matching the current visual selection.
  vim.keymap.set(
    "v",
    "<leader>zf",
    ":'<,'>ZkMatch<CR>",
    { noremap = true, silent = false, desc = "Search Notes Matching" }
  ),
  -- Zk Keymaps
}
