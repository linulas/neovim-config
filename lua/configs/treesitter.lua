local M = {}

local options = {
  ensure_installed = {
    "css",
    "rust",
    "go",
    "html",
    "javascript",
    "lua",
    "luadoc",
    "printf",
    "svelte",
    "vim",
    "vimdoc",
    "toml",
    "typescript",
    "yaml",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  auto_install = true,
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },

  indent = { enable = true },
}

M.init = function()
  require("nvim-treesitter.configs").setup(options)
end

return M
