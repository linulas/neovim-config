local M = {}

M.init = function()
  require("nvim-treesitter").setup()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      -- Enable treesitter highlighting and disable regex syntax
      pcall(vim.treesitter.start)
      -- Enable treesitter-based indentation
      if vim.bo.filetype ~= "cs" then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
  local ensureInstalled = {
    "css",
    "go",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "rust",
    "scss",
    "svelte",
    "vim",
    "vimdoc",
    "toml",
    "typescript",
    "yaml",
  }
  local alreadyInstalled = require("nvim-treesitter.config").get_installed()
  local parsersToInstall = vim
    .iter(ensureInstalled)
    :filter(function(parser)
      return not vim.tbl_contains(alreadyInstalled, parser)
    end)
    :totable()
  require("nvim-treesitter").install(parsersToInstall)
end

return M
