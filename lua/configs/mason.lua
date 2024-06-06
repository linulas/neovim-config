local M = {}

local options = {
  ensure_installed = {
    "csharp-language-server",
    "css",
    "codelldb",
    "go",
    "gopls",
    "html",
    "javascript",
    "lua-language-server",
    "marksman",
    "shfmt",
    "shellcheck",
    "stylua",
    "toml",
    "typescript",
    "yaml-language-server",
  }, -- not an option from mason.nvim

  PATH = "prepend",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = " 󰚌",
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },

  max_concurrent_installers = 10,
}

M.init = function()
  require("mason").setup(options)

  -- custom cmd to install all mason binaries listed
  vim.api.nvim_create_user_command("MasonInstallAll", function()
    if options.ensure_installed and #options.ensure_installed > 0 then
      vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
    end
  end, {})

  vim.g.mason_binaries_list = options.ensure_installed
end

return M
