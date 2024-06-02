local M = {}

-- LSP clients attached to buffer
local clients_lsp = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.buf_get_clients(bufnr)
  if next(clients) == nil then
    return ""
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, client.name)
  end
  return "\u{f085}  LSP ~ " .. table.concat(c, "|")
end

local get_workspace_name = function()
  local name = ""
  local path = vim.fn.getcwd()
  for _, value in string.gmatch(path, "(%w+)/(%w+)") do
    name = value
  end
  -- return "\u{1F4C1} " .. name
  return "\u{f07b} " .. name
end

local options = {
  options = {
    icons_enabled = true,
    theme = "auto",
    -- component_separators = { left = '', right = ''},
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {
      -- {
      --   "buffers",
      --   symbols = {
      --     modified = " ●", -- Text to show when the buffer is modified
      --     alternate_file = "\u{f061} ", -- Text to show to identify the alternate file
      --     directory = "", -- Text to show when the buffer is a directory
      --   },
      -- },
      {
        "filetype",
        colored = true,
        icon_only = true,
        padding = { left = 1, right = 0 },
      },
      {
        "filename",
        padding = { left = 0, right = 1 },
      },
    },
    lualine_x = {
      get_workspace_name,
    },
    lualine_y = { clients_lsp },
    lualine_z = { "progress" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}

M.init = function()
  require("lualine").setup(options)
end

return M
