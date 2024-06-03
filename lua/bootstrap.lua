local M = {}

local default_settings = {
  ENABLE_PLUGIN_MASON = true,
  ENABLE_PLUGIN_DAP = true,
  ENABLE_PLUGIN_OBSIDIAN = false,
  LLDB_PATH = "/usr/local/opt/llvm/bin/lldb-vscode",
  OBSIDIAN_VAULT_PATH = "~/Documents"
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

-- TODO: Setup Env for minimal or full config
-- _G.startup_prompt = function()
--   local env_file = vim.fn.expand "%:p:h" .. "/.env"
--   local key = "CONFIGURATION_TYPE"
--   local key_value_pair = vim.fn.system('grep -E "^' .. key .. '=" ' .. env_file)
--   local current_config = ""
--   for value in key_value_pair:gmatch "[^=]+" do
--     current_config = value
--   end
--
--   -- Check if the .env file exists
--   if vim.fn.filereadable(env_file) == 0 then
--     -- Create an empty .env file
--     local file = io.open(env_file, "w")
--     if file then
--       file:close()
--       print(".env file created at " .. env_file)
--     else
--       print("Failed to create .env file at " .. env_file)
--       return
--     end
--   end
--
--   print("Current configuration: " .. current_config)
--
--   if not (current_config == "minimal" or current_config == "full") then
--     local choices = { "Minimal", "Full" }
--     local prompt = "Which configuration do you want to use?"
--     vim.ui.select(choices, { prompt = prompt }, function(choice)
--       if choice == "Minimal" then
--         vim.fn.system("echo " .. key .. "=minimal >> " .. env_file)
--       elseif choice == "Full" then
--         vim.fn.system("echo " .. key .. "=full >> " .. env_file)
--       else
--         print "No valid choice made, defaulting to minimal"
--         vim.fn.system("echo " .. key .. "=minimal >> " .. env_file)
--       end
--     end)
--   end
--
--   print "\nWrote configuration type to .env"
-- end

-- Call the function on startup using an autocommand
-- vim.api.nvim_create_autocmd("VimEnter", {
--   pattern = "*",
--   callback = _G.startup_prompt,
-- })

return M
