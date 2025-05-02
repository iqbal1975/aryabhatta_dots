-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Clear Search Highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear Search highlights" })

-- Increment / Decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- Increment
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- Decrement

-- Make Split Windows Equal Width & Height
vim.keymap.set("n", "<leader>=", "<C-w>=", { desc = "Make Splits Equal Size" })

-- DAP Keymaps
local wk = require("which-key")
wk.add({
  { "<leader>D", group = "DAP" },
  { "<leader>Db", group = "Breakpoints" },
  { "<leader>Ds", group = "Steps" },
  { "<leader>Dv", group = "Views" },
})

local dap = require("dap")
local breakpoints = require("dap.breakpoints")
local widgets = require("dap.ui.widgets")

vim.keymap.set("n", "<leader>Dbc", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional Breakpoint" })

vim.keymap.set("n", "<leader>Dbl", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log point message"))
end, { desc = "Logpoint" })

vim.keymap.set("n", "<leader>Dbr", function()
  breakpoints.clear()
end, { desc = "Remove All" })

-- vim.keymap.set("n", "<leader>Dbs", "<CMD>Telescope dap list_breakpoints<CR>", { desc = "Show All" })

vim.keymap.set("n", "<leader>Dbt", function()
  dap.toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

vim.keymap.set("n", "<leader>Dc", function()
  dap.continue()
end, { desc = "Continue" })

vim.keymap.set({ "n", "v" }, "<leader>De", function()
  widgets.hover(nil, { border = "none" })
end, { desc = "Evaluate Expression" })

vim.keymap.set("n", "<leader>Dp", function()
  dap.pause()
end, { desc = "Pause" })

-- vim.keymap.set("n", "<leader>Dr", "<CMD>Telescope dap configurations<CR>", { desc = "Run" })

vim.keymap.set("n", "<leader>Dsb", function()
  dap.step_back()
end, { desc = "Step Back" })

vim.keymap.set("n", "<leader>Dsc", function()
  dap.run_to_cursor()
end, { desc = "Run to Cursor" })

vim.keymap.set("n", "<leader>Dsi", function()
  dap.step_into()
end, { desc = "Step Into" })

vim.keymap.set("n", "<leader>Dso", function()
  dap.step_over()
end, { desc = "Step Over" })

vim.keymap.set("n", "<leader>Dsx", function()
  dap.step_out()
end, { desc = "Step Out" })

vim.keymap.set("n", "<leader>Dx", function()
  dap.terminate()
end, { desc = "Terminate" })

vim.keymap.set("n", "<leader>Dvf", function()
  widgets.centered_float(widgets.frames, { border = "none" })
end, { desc = "Show Frames" })

vim.keymap.set("n", "<leader>Dvr", function()
  dap.repl.open(nil, "20split")
end, { desc = "Show Repl" })

vim.keymap.set("n", "<leader>Dvs", function()
  widgets.centered_float(widgets.scopes, { border = "none" })
end, { desc = "Show Scopes" })

vim.keymap.set("n", "<leader>Dvt", function()
  widgets.centered_float(widgets.threads, { border = "none" })
end, { desc = "Show Threads" })
-- DAP Keymaps

-- Diagnostics Keymap
vim.keymap.set('n', '<leader>uv', function()
  vim.diagnostic.config({ virtual_lines = { current_line = false }, virtual_text = true })

  vim.api.nvim_create_autocmd('CursorMoved', {
    group = vim.api.nvim_create_augroup('line-diagnostics', { clear = true }),
    callback = function()
      vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
      return true
    end,
  })
end, {desc = "Toggle Diagnostic Virtual Lines / Text" })
-- Diagnostics Keymap
