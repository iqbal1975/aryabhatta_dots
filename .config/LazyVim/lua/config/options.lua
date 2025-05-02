-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- {{{ Alphabetical listing of settings I like.

local options = {
  background = "dark", -- set this to dark or light
  clipboard = "unnamedplus",
  colorcolumn = "120",
  completeopt = { "menuone", "noinsert", "noselect" },
  listchars = { -- list of hidden characters
    tab = "» ",
    trail = "•",
    precedes = "←",
    extends = "→",
    eol = "↲",
    space = "␣",
  },
  nrformats = { "alpha", "octal", "hex" },
  showbreak = "↪",
  splitbelow = true,
  splitright = true,
  -- statuscolumn = "%l %r",
  -- winbar = "%=%m %f"
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd([[filetype plugin indent on]])

-- Function to get the number of open buffers using the :ls command
-- local function get_buffer_count()
--   return vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 }))
-- end

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

vim.keymap.set("n", "gF", function()
  local filepath = vim.fn.expand("<cfile>")
  if vim.fn.filereadable(filepath) == 0 then
    -- Create missing directories
    vim.fn.mkdir(vim.fn.fnamemodify(filepath, ":h"), "p")
    -- Create and open the file
    vim.cmd("edit " .. filepath)
    print("Created new file: " .. filepath)
  else
    -- Open the existing file
    vim.cmd("edit " .. filepath)
  end
end, { desc = "Open or Create file under cursor with missing directories" })

-- Snacks Options
vim.ui.input = "Snacks.input"
vim.ui.select = "Snacks.picker.select"

-- Views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- ------------------------------------------------------------------------- }}}
