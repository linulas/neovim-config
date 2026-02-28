local M = {}

local options = {
  strategies = {
    chat = {
      adapter = "openai",
    },
    inline = {
      adapter = "openai",
    },
    cmd = {
      adapter = "openai",
    },
  },
  adapters = {
    http = {
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = vim.env.GEMINI_API_KEY,
          },
        })
      end,
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          env = {
            api_key = vim.env.OPENAI_API_KEY,
          },
        })
      end,
    },
  },
}

M.init = function()
  require("codecompanion").setup(options)
end

return M
