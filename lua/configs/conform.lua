local M = {}
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nix" },
    css = { "prettierd" },
    html = { "prettierd" },
    php = { "php-cs-fixer" },
  },
  formatters = {
    nix = {
      -- Change where to find the command
      command = "/home/linus/.nix-profile/bin/nixpkgs-fmt",
    },
    ["php-cs-fixer"] = {
      command = "php-cs-fixer",
      args = {
        "fix",
        "--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
        "$FILENAME",
      },
      stdin = false,
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
