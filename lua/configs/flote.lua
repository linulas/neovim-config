local M = {}

M.init = function()
  require("flote").setup {
    notes_dir = "/home/linus/Dokument/Anteckningar" .. "/flote",
  }
end

return M
