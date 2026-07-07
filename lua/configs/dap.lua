local M = {}

-- Reads debug settings from a neovim.json file in the project root:
-- { "dll_path": "path/to/project.dll", "env": { "KEY": "value" } }
local function load_project_config()
  local path = vim.fn.getcwd() .. "/neovim.json"
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read "*a"
  file:close()
  local ok, config = pcall(vim.json.decode, content)
  if not ok then
    vim.notify("Failed to parse " .. path .. ": " .. config, vim.log.levels.ERROR)
    return nil
  end
  return config
end

local function configure()
  -- Settings
  local dap_breakpoint = {
    error = {
      text = "🟥",
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    },
    rejected = {
      text = "",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "⭐️",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }

  vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
  vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
  vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

  local dap = require "dap"

  -- Adapters
  dap.adapters.lldb = {
    type = "executable",
    command = vim.env.LLDB_PATH,
    name = "lldb",
  }

  dap.adapters.coreclr = {
    type = "executable",
    command = vim.env.CORECLR_PATH,
    args = { "--interpreter=vscode" },
  }

  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
      -- add this if on windows, otherwise server won't open successfully
      -- detached = false
    },
  }

  -- configurations
  dap.configurations.cpp = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},

      -- 💀
      -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
      --
      --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      --
      -- Otherwise you might get the following error:
      --
      --    Error on launch: Failed to attach to the target process
      --
      -- But you should be aware of the implications:
      -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
      -- runInTerminal = true,
    },
  }

  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "launch",
      preLaunchTask = "build",
      program = function()
        local config = load_project_config()
        if config and config.dll_path then
          local dll = config.dll_path
          if not dll:match "^/" then
            dll = vim.fn.getcwd() .. "/" .. dll
          end
          if vim.fn.filereadable(dll) == 1 then
            return dll
          end
          vim.notify("dll_path in neovim.json does not exist: " .. dll, vim.log.levels.WARN)
        end
        return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
      end,
      stopOnEntry = true,
      env = function()
        local config = load_project_config()
        return config and config.env or {}
      end,
      console = "integratedTerminal",
    },
  }

  dap.configurations.rust = dap.configurations.cpp
end

local function configure_exts()
  require("nvim-dap-virtual-text").setup {
    commented = true,
  }

  local dap, dapui = require "dap", require "dapui"
  dapui.setup {} -- use default
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  require("dap-go").setup()
end

M.init = function()
  configure() -- Configuration
  configure_exts() -- Extensions
end

return M
