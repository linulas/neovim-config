local M = {}

local default_settings = {
  CORECLR_PATH = "/usr/local/netcoredbg",
  ENABLE_PLUGIN_MASON = true,
  ENABLE_PLUGIN_DAP = true,
  ENABLE_PLUGIN_OBSIDIAN = false,
  FLOTE_NOTES_PATH = "~/Documents/flote",
  LLDB_PATH = "/usr/local/opt/llvm/bin/lldb-vscode",
  OBSIDIAN_VAULT_PATH = "~/Documents",
  TYPESCRIPT_PLUGIN_PATH= "/usr/local/lib/node_modules/@vue/typescript-plugin",
  RUST_ANALYZER_FEATURES= "",
  GEMINI_API_KEY="",
  OPENAI_API_KEY=""
}

--- Parses a configuration file and sets environment varaiables accordingly.
--- Falls back to default settings if no existing config file is provided.
--
-- @param path - The path to the configuration file.
M.parse_config_file_and_set_environment_variables = function(path)
  local file = io.open(path, "r")
  if not file then
    Set_environment_variables(default_settings)
  else
    local settings = default_settings
    for line in file:lines() do
      local key, value = line:match "^([^=]+)=(.*)$"
      if key and value then
        settings[key] = value
      end
    end
    file:close()
    Set_environment_variables(settings)
  end
end

function Set_environment_variables(settings)
  for key, value in pairs(settings) do
    vim.env[key] = tostring(value) -- Set the variable in the os environment
  end
end

return M
