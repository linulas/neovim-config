local M = {}

local options = {
  terminals = {
    shell = vim.o.shell,
    list = {},
    type_opts = {
      float = {
        relative = 'editor',
        row = 0.1,
        col = 0.05,
        width = 0.9,
        height = 0.72,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = .5, },
      vertical = { location = "rightbelow", split_ratio = .3 },
    }
  },
}

M.init = function()
  require("nvterm").setup(options)
end

return M
