-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- intelephense (node) en vez de phpactor: no necesita PHP local y entiende mejor Laravel
vim.g.lazyvim_php_lsp = "intelephense"

-- docker-compose*.yml con su propio LSP (docker extra)
vim.filetype.add({
  pattern = {
    ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
    ["compose.*%.ya?ml"] = "yaml.docker-compose",
  },
})
