local M = {}
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nix" },
    css = { "prettierd" },
    html = { "prettierd" },
  },
  formatters = {
    nix = {
      -- Change where to find the command
      command = "/home/linus/.nix-profile/bin/nixpkgs-fmt",
    },
  },
  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

M.init = function()
  require("conform").setup(options)
end

return M
