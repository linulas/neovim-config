local M = {}

M.init = function()
  require("flote").setup {
    notes_dir = vim.env.FLOTE_NOTES_PATH,
  }
end

return M
