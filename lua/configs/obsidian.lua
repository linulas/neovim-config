local M = {}

M.init = function()
  require("obsidian").setup {
    -- A list of workspace names, paths, and configuration overrides.
    -- If you use the Obsidian app, the 'path' of a workspace should generally be
    -- your vault root (where the `.obsidian` folder is located).
    -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
    -- the workspace to the first workspace in the list whose `path` is a parent of the
    -- current markdown file being edited.
    workspaces = {
      {
        name = "personal",
        path = vim.env.OBSIDIAN_VAULT_PATH,
      },
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    -- Optional, for templates (see below).
    templates = {
      folder = "eget/mallar",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },

    ---@diagnostic disable-next-line: missing-fields
    picker = {
      name = "telescope.nvim",
      -- Optional, configure key mappings for the picker. These are the defaults.
      mappings = {
        new = "<C-x>",
        insert_link = "<C-z>",
      },
    },

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      local fileName = spec.title ~= nil and spec.title ~= "" and spec.title or spec.id
      local path = spec.dir / tostring(fileName)
      return path:with_suffix ".md"
    end,
  }
end

return M
