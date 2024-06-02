local M = {}

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
    command = vim.env.LLDB_PATH, -- adjust as needed, must be absolute path
    name = "lldb",
  }

  -- dap.adapters.coreclr = {
  --   type = "executable",
  --   command = "/usr/local/netcoredbg",
  --   args = { "--interpreter=vscode" },
  -- }

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

  -- dap.configurations.cs = {
  --   {
  --     type = "coreclr",
  --     name = "launch - netcoredbg",
  --     request = "launch",
  --     preLaunchTask = "build",
  --     program = function()
  --       return vim.fn.input("Path to dll", vim.fn.getcwd() .. "", "file")
  --     end,
  --   },
  -- }

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

  -- require("dap-go").setup {
  --   -- Additional dap configurations can be added.
  --   -- dap_configurations accepts a list of tables where each entry
  --   -- represents a dap configuration. For more details do:
  --   -- :help dap-configuration
  --   dap_configurations = {
  --     {
  --       type = "go",
  --       request = "attach",
  --       name = "Attach to Go Process",
  --       mode = "local",
  --       processId = require("dap.utils").pick_process,
  --     },
  --   },
  -- }
end

M.init = function()
  configure() -- Configuration
  configure_exts() -- Extensions
end

return M
