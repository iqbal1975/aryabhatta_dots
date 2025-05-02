-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.env.VSCODE then
  vim.g.vscode = true
end

if vim.loader then
  vim.loader.enable()
end

require("config.lazy")
