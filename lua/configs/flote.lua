local M = {}

M.init = function()
  require("flote").setup {
    notes_dir = vim.env.FLOTE_NOTES_PATH,
    window_border = "single"
  }
end

return M
