local M = {}

local options = {
  strategies = {
    chat = {
      adapter = "claude_code",
    },
    inline = {
      adapter = "claude_code",
    },
    cmd = {
      adapter = "claude_code",
    },
  },
  adapters = {
    acp = {
      claude_code = function()
        return require("codecompanion.adapters").extend("claude_code", {
          env = {
            CLAUDE_CODE_OAUTH_TOKEN = vim.env.CODECOMPANION_CLAUDE_TOKEN,
          },
        })
      end,
    },
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
