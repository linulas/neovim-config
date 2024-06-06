local M = {}

local colors = {
  background = "#282a36",
  currentLine = "#44475a",
  foreground = "#f8f8f2",
  comment = "#6272a4",
  cyan = "#8be9fd",
  green = "#50fa7b",
  orange = "#ffb86c",
  pink = "#ff79c6",
  purple = "#bd93f9",
  red = "#ff5555",
  yellow = "#f1fa8c",
}

function Theme()
  return {
    inactive = {
      a = { fg = colors.background, bg = nil, gui = "bold" },
      b = { fg = colors.foreground, bg = colors.currentLine },
      c = { fg = colors.comment, bg = nil },
      x = { fg = colors.comment, bg = nil },
      y = { fg = colors.foreground, bg = colors.currentLine },
      z = { fg = colors.background, bg = colors.green, gui = "bold" },
    },
    visual = {
      a = { fg = colors.background, bg = colors.foreground, gui = "bold" },
      b = { fg = colors.foreground, bg = colors.currentLine },
      c = { fg = colors.comment, bg = nil },
      x = { fg = colors.comment, bg = nil },
      y = { fg = colors.foreground, bg = colors.currentLine },
      z = { fg = colors.background, bg = colors.green, gui = "bold" },
    },
    replace = {
      a = { fg = colors.background, bg = colors.orange, gui = "bold" },
      b = { fg = colors.foreground, bg = colors.currentLine },
      c = { fg = colors.comment, bg = nil },
      x = { fg = colors.comment, bg = nil },
      y = { fg = colors.foreground, bg = colors.currentLine },
      z = { fg = colors.background, bg = colors.green, gui = "bold" },
    },
    normal = {
      a = { fg = colors.background, bg = colors.purple, gui = "bold" },
      b = { fg = colors.foreground, bg = colors.currentLine },
      c = { fg = colors.comment, bg = nil },
      x = { fg = colors.comment, bg = nil },
      y = { fg = colors.foreground, bg = colors.currentLine },
      z = { fg = colors.background, bg = colors.green, gui = "bold" },
    },
    insert = {
      a = { fg = colors.background, bg = colors.cyan, gui = "bold" },
      b = { fg = colors.foreground, bg = colors.currentLine },
      c = { fg = colors.comment, bg = nil },
      x = { fg = colors.comment, bg = nil },
      y = { fg = colors.foreground, bg = colors.currentLine },
      z = { fg = colors.background, bg = colors.green, gui = "bold" },
    },
    command = {
      a = { fg = colors.background, bg = colors.yellow, gui = "bold" },
      b = { fg = colors.foreground, bg = colors.currentLine },
      c = { fg = colors.comment, bg = nil },
      x = { fg = colors.comment, bg = nil },
      y = { fg = colors.foreground, bg = colors.currentLine },
      z = { fg = colors.background, bg = colors.green, gui = "bold" },
    },
  }
end

-- LSP clients attached to buffer
local clients_lsp = function()
  local clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
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
  return "\u{f07b} " .. name
end

local options = {
  options = {
    icons_enabled = true,
    theme = Theme(),
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diagnostics" },
    lualine_c = {
      {
        "buffers",
        hide_filename_extension = true,
        use_mode_colors = true,
        buffers_color = {
          active = { bg = nil, fg = colors.foreground },
        },
      },
      "diff",
    },
    lualine_x = {
      "searchcount",
      get_workspace_name,
    },
    lualine_y = { clients_lsp },
    lualine_z = { "progress" },
  },
}

M.init = function()
  require("lualine").setup(options)
end

return M
