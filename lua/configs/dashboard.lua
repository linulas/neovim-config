---@diagnostic disable: missing-fields
local M = {}

M.opts = function()
  local git_dashboard = require("git-dashboard-nvim").setup {
    colors = {
      days_and_months_labels = "#ff79c6",
      empty_square_highlight = "#44475a",
      filled_square_highlights = { "#8be9fd", "#8be9fd", "#8be9fd", "#8be9fd", "#8be9fd", "#8be9fd", "#8be9fd" },
      branch_highlight = "#f1fa8c",
      dashboard_title = "#50fa7b",
    },
  }

  return {
    theme = "doom",
    config = {
      header = git_dashboard,
      center = {
        { action = "", desc = "", icon = "", key = "n" },
      },
      footer = function()
        return {}
      end,
    },
  }
end

return M
